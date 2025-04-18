/* eslint-disable @typescript-eslint/no-unsafe-call */

import { EmbeddedRuminerLabel } from '../ai/embedding'
import { filter, map, mergeMap } from 'rxjs/operators'
import { toSql } from 'pgvector/pg'
import { OperatorFunction } from 'rxjs'
import { fromPromise } from 'rxjs/internal/observable/innerFrom'
import { sqlClient } from './db'
import { Label } from '../../types/RuminerSchema'

const hasLabelsStoredInDatabase = async (label: string) => {
  const { rows } = await sqlClient.query(
    `SELECT label FROM label_embeddings where label = $1`,
    [label]
  )
  return rows && rows.length === 0
}

export const removeDuplicateLabels = mergeMap((x: Label) =>
  fromPromise(hasLabelsStoredInDatabase(x.name)).pipe(
    filter(Boolean),
    map(() => x)
  )
)

export const insertLabels = async (
  label: EmbeddedRuminerLabel
): Promise<EmbeddedRuminerLabel> => {
  if (label.label.name && label.label.description) {
    await sqlClient.query(
      'INSERT INTO ruminer.discover_topic_embedding_link(discover_topic_name, embedding_description, embedding) VALUES($1, $2, $3)',
      [label.label.name, label.label.description, toSql(label.embedding)]
    )
  }
  return label
}

// export const insertLabelsToFile = async (
//   label: EmbeddedRuminerLabel,
// ): Promise<EmbeddedRuminerLabel> => {
//   fs.appendFileSync('./output.json', JSON.stringify(label))
//   return label
// }

export const insertLabelToStore: OperatorFunction<
  EmbeddedRuminerLabel,
  EmbeddedRuminerLabel
> = mergeMap((x) => fromPromise(insertLabels(x)))
