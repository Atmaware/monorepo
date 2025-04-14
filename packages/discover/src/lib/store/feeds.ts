import { mergeMap, Observable, OperatorFunction } from 'rxjs'
import { sqlClient } from './db'
import { RuminerFeed } from '../../types/Feeds'
import { fromPromise } from 'rxjs/internal/observable/innerFrom'

export const getRssFeeds$ = fromPromise(
  (async (): Promise<RuminerFeed[]> => {
    const { rows } = (await sqlClient.query(
      `SELECT * FROM ruminer.discover_feed WHERE title != 'OMNIVORE_COMMUNITY'`
    )) as { rows: RuminerFeed[] }

    return rows
  })()
).pipe(mergeMap((it) => it))
