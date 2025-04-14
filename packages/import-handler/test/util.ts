import { Readability } from '@ruminer/readability'
import { RedisDataSource } from '@ruminer/utils'
import { ArticleSavingRequestStatus, ImportContext } from '../src'

export const stubImportCtx = (
  redisDataSource: RedisDataSource
): ImportContext => {
  return {
    userId: '',
    countImported: 0,
    countFailed: 0,
    urlHandler: (
      ctx: ImportContext,
      url: URL,
      state?: ArticleSavingRequestStatus,
      labels?: string[]
    ): Promise<void> => {
      return Promise.resolve()
    },
    contentHandler: (
      ctx: ImportContext,
      url: URL,
      title: string,
      originalContent: string,
      parseResult: Readability.ParseResult
    ): Promise<void> => {
      return Promise.resolve()
    },
    redisDataSource,
    taskId: '',
    source: 'csv-importer',
  }
}
