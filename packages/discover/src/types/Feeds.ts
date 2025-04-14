export type RuminerFeed = {
  id: string
  description?: string
  image?: string
  link: string
  title: string
  type: string
}

export type RuminerContentFeed = {
  feed: RuminerFeed
  content: string
}
