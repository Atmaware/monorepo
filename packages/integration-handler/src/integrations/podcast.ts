import axios from 'axios'
import {
  IntegrationClient,
  RetrievedResult,
  RetrieveRequest,
  State,
} from './integration'

interface PodcastEpisode {
  id: string
  title: string
  description: string
  audioUrl: string
  imageUrl: string
  publishDate: string
  duration: number
  podcastName: string
}

export class PodcastClient extends IntegrationClient {
  name = 'PODCAST'
  apiUrl = 'https://api.listennotes.com/api/v2'

  retrieve = async ({
    token,
    since = 0,
    count = 100,
    offset = 0,
    state,
  }: RetrieveRequest): Promise<RetrievedResult> => {
    try {
      // For podcast integration, we'll assume the token is the Listen Notes API key
      const episodes = await this.fetchSubscribedEpisodes(token, since, count, offset)
      
      const data = episodes.map(episode => ({
        url: `https://www.listennotes.com/e/${episode.id}`,
        labels: ['podcast', episode.podcastName],
        state: State.UNARCHIVED,
      }))
      
      return {
        data,
        hasMore: episodes.length === count,
        since: Date.now()
      }
    } catch (error) {
      console.error('Error retrieving Podcast content:', error)
      return {
        data: [],
        hasMore: false,
        since: since || Date.now()
      }
    }
  }
  
  private fetchSubscribedEpisodes = async (
    apiKey: string,
    since: number,
    count: number,
    offset: number
  ): Promise<PodcastEpisode[]> => {
    const headers = {
      'X-ListenAPI-Key': apiKey,
      'Content-Type': 'application/json'
    }
    
    try {
      // First, get the user's subscribed podcasts
      const podcastsResponse = await axios.get(
        `${this.apiUrl}/subscriptions`,
        { headers }
      )
      
      const subscribedPodcasts = podcastsResponse.data.subscriptions
      const allEpisodes: PodcastEpisode[] = []
      
      // For each subscribed podcast, get recent episodes
      for (const podcast of subscribedPodcasts) {
        const episodesResponse = await axios.get(
          `${this.apiUrl}/podcasts/${podcast.id}/episodes`,
          {
            headers,
            params: {
              sort: 'recent_first',
              page_size: 10 // Get 10 most recent episodes per podcast
            }
          }
        )
        
        const episodes = episodesResponse.data.episodes.map((episode: any) => ({
          id: episode.id,
          title: episode.title,
          description: episode.description,
          audioUrl: episode.audio,
          imageUrl: episode.image,
          publishDate: episode.pub_date_ms,
          duration: episode.audio_length_sec,
          podcastName: podcast.title
        }))
        
        // Filter episodes by publish date if since is provided
        const filteredEpisodes = since 
          ? episodes.filter((episode: PodcastEpisode) => new Date(episode.publishDate).getTime() >= since)
          : episodes
        
        allEpisodes.push(...filteredEpisodes)
      }
      
      // Sort episodes by publish date (newest first)
      allEpisodes.sort((a, b) => 
        new Date(b.publishDate).getTime() - new Date(a.publishDate).getTime()
      )
      
      // Apply pagination
      return allEpisodes.slice(offset, offset + count)
    } catch (error) {
      console.error('Error fetching podcast episodes:', error)
      return []
    }
  }
}
