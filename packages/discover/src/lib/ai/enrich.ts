import { RuminerClient } from '../clients/ruminer/ruminer'
import { RuminerArticle } from '../../types/RuminerArticle'
import { mergeMap, OperatorFunction, pipe } from 'rxjs'
import { client } from '../clients/ai/client'
import { convert } from 'html-to-text'
import { fromPromise } from 'rxjs/internal/observable/innerFrom'
import { exponentialBackOff, rateLimiter } from '../utils/reactive'
import { env } from '../../env'

const ruminerClient = RuminerClient.createRuminerClient(env.apiKey)

// A basic metric for now, we will see later if anything needs to be improved in this area.
// 10 Words is probably sufficient, and will reduce the need for the bill on the Summary side.
export const needsPopulating = (article: RuminerArticle) => {
  return article.description?.split(' ').length <= 3
}

const setArticleDescription = async (
  article: RuminerArticle
): Promise<RuminerArticle> => {
  const client = await ruminerClient
  const { content } = await client.fetchPage(article.slug)
  return {
    ...article,
    description: convert(content).split(' ').slice(0, 25).join(' '),
  }
}

export const setArticleDescriptionAsSubsetOfContent: OperatorFunction<
  RuminerArticle,
  RuminerArticle
> = mergeMap(
  (it: RuminerArticle) => fromPromise(setArticleDescription(it)),
  10
)

const enrichArticleWithAiSummary = (it: RuminerArticle) =>
  fromPromise(
    (async (article: RuminerArticle): Promise<RuminerArticle> => {
      const omniClient = await ruminerClient
      const { content } = await omniClient.fetchPage(article.slug)

      try {
        const tokens = convert(content).slice(
          0,
          Math.floor(client.tokenLimit * 0.75)
        )
        const description = await client.summarizeText(tokens)
        return { ...article, description }
      } catch (e) {
        console.log(`Error article: ${article.title}`)
        console.log(e)
        throw e
      }
    })(it)
  )

export const enrichArticleWithAiGeneratedDescription: OperatorFunction<
  RuminerArticle,
  RuminerArticle
> = pipe(
  rateLimiter({ resetLimit: 50, timeMs: 60_000 }),
  mergeMap((it: RuminerArticle) =>
    enrichArticleWithAiSummary(it).pipe(exponentialBackOff(30))
  )
)
