import { RedisDataSource } from '@ruminer/utils'
import { Queue } from 'bullmq'

const QUEUE_NAME = 'ruminer-backend-queue'
const JOB_NAME = 'update-pdf-content'

export type State = 'SUCCEEDED' | 'FAILED'

type UpdatePageJobData = {
  fileId: string
  content?: string
  title?: string
  author?: string
  description?: string
  state?: State
}

export const queueUpdatePageJob = async (
  redisDataSource: RedisDataSource,
  data: UpdatePageJobData
) => {
  const queue = new Queue(QUEUE_NAME, {
    connection: redisDataSource.queueRedisClient,
  })

  return queue.add(JOB_NAME, data, {
    priority: 5,
    attempts: 3,
    backoff: {
      type: 'exponential',
      delay: 1000,
    },
  })
}
