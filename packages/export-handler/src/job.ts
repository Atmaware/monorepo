import { RedisDataSource } from '@ruminer/utils'
import { Queue } from 'bullmq'

const QUEUE_NAME = 'ruminer-backend-queue'
export const SEND_EMAIL_JOB = 'send-email'

interface SendEmailJobData {
  userId: string
  from?: string
  subject?: string
  html?: string
}

export const queueEmailJob = async (
  redisDataSource: RedisDataSource,
  data: SendEmailJobData
) => {
  const queue = new Queue(QUEUE_NAME, {
    connection: redisDataSource.queueRedisClient,
  })

  await queue.add(SEND_EMAIL_JOB, data)
}
