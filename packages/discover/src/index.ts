import { addEmbeddingToArticle$, addTopicsToArticle$ } from './lib/ai/embedding'
import {
  insertArticleToStore$,
  removeDuplicateArticles$,
} from './lib/store/articles'
import { merge, Observable } from 'rxjs'
import { RuminerArticle } from './types/RuminerArticle'
import { rss$ } from './lib/inputSources/articles/rss/rssIngestor'
import { putImageInProxy$ } from './lib/clients/ruminer/imageProxy'
import { communityArticles$ } from './lib/inputSources/articles/communityArticles'

const enrichedArticles$ = (): Observable<RuminerArticle> => {
  return merge(communityArticles$, rss$) as Observable<RuminerArticle>
}

;(() => {
  enrichedArticles$()
    .pipe(
      // removeDuplicateArticles$,
      addEmbeddingToArticle$,
      addTopicsToArticle$,
      putImageInProxy$,
      insertArticleToStore$
    )
    .subscribe((it) => {
      console.log('enriched: ', it)
    })
})()
