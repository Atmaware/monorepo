/* eslint-disable @typescript-eslint/no-unsafe-call */
import { mergeMap } from 'rxjs/operators'
import { RuminerArticle } from '../../types/RuminerArticle'
import { OperatorFunction, pipe, share } from 'rxjs'
import { fromPromise } from 'rxjs/internal/observable/innerFrom'
import { client } from '../clients/ai/client'
import { onErrorContinue, rateLimiter } from '../utils/reactive'
import { Label } from '../../types/RuminerSchema'
import { sqlClient } from '../store/db'
import { toSql } from 'pgvector/pg'

export type EmbeddedRuminerArticle = {
  embedding: Array<number>
  article: RuminerArticle
  topics: string[]
}

export type EmbeddedRuminerLabel = {
  embedding: Array<number>
  label: Label
}

// Remove, for instance, "The Verge" and " - The Verge" to avoid the cosine similarity matching on that.
const prepareTitle = (article: RuminerArticle): string =>
  article.title
    .replace(article.site, '')
    .replace(/[`~!@#$%^&*()_|+\-=?;:'",.<>{}[]\\\/]/gi, '')

const getEmbeddingForArticle = async (
  it: RuminerArticle
): Promise<EmbeddedRuminerArticle> => {
  // console.log(`${prepareTitle(it)}: ${it.description}`)
  const embedding = await client.getEmbeddings(
    `${prepareTitle(it)}: ${it.summary}`
  )

  return {
    embedding,
    article: it,
    topics: [],
  }
}

const addTopicsToArticle = async (
  it: EmbeddedRuminerArticle
): Promise<EmbeddedRuminerArticle> => {
  const articleEmbedding = it.embedding

  const topics = await sqlClient.query(
    `SELECT name, similarity
     FROM (SELECT discover_topic_name as name, MAX(ABS(embed.embedding <#> $1)) AS "similarity" FROM ruminer.ruminer.discover_topic_embedding_link embed group by discover_topic_name)  topics
     ORDER BY similarity desc`,
    [toSql(articleEmbedding)]
  )

  // OpenAI seems to cluster things around 0.7-0.9. Through trial and error I have found 0.77 to be a fairly accurate score.
  const topicNames = topics.rows
    .filter(({ similarity }) => similarity > 0.77)
    .map(({ name }) => name as string)

  if (topicNames.length == 0) {
    topicNames.push(topics.rows[0]?.name)
  }

  // I basically want to check if there's anything between the top one and the others.
  // If the gap is miniscule, then we should include it. IE: 0.7688 and 0.765
  const topTopic = topics.rows[0]
  const extraTopics = topics.rows
    .filter(
      ({ similarity, name }) =>
        similarity < 0.77 &&
        topTopic.name != name &&
        topTopic.similarity - similarity < 0.01
    )
    .map(({ name }) => name as string)

  if (extraTopics.length > 0) {
    console.log(`${it.article.title}: ${it.article.description}`)
    console.log(topics.rows)
    console.log(extraTopics)
  }
  topicNames.push(...extraTopics)

  if (it.article.type == 'community') {
    topicNames.push('Community Picks')
  }

  return {
    ...it,
    topics: topicNames,
  }
}

const getEmbeddingForLabel = async (
  label: Label
): Promise<EmbeddedRuminerLabel> => {
  const embedding = await client.getEmbeddings(
    `${label.name}${label.description ? ' : ' + label.description : ''}`
  )
  console.log(
    `${label.name}${label.description ? ' : ' + label.description : ''}`
  )

  return {
    embedding,
    label,
  }
}

export const rateLimitEmbedding = <T>() =>
  pipe(share(), rateLimiter<T>({ resetLimit: 1000, timeMs: 60_000 }))

export const rateLimiting = rateLimitEmbedding<any>()

export const addEmbeddingToLabel$: OperatorFunction<
  Label,
  EmbeddedRuminerLabel
> = pipe(
  rateLimiting,
  mergeMap((it: Label) => fromPromise(getEmbeddingForLabel(it)))
)

export const addEmbeddingToArticle$: OperatorFunction<
  RuminerArticle,
  EmbeddedRuminerArticle
> = pipe(
  rateLimiting,
  onErrorContinue(
    mergeMap((it: RuminerArticle) => fromPromise(getEmbeddingForArticle(it)))
  )
)

export const addTopicsToArticle$: OperatorFunction<
  EmbeddedRuminerArticle,
  EmbeddedRuminerArticle
> = pipe(
  onErrorContinue(
    mergeMap((it: EmbeddedRuminerArticle) =>
      fromPromise(addTopicsToArticle(it))
    )
  )
)
