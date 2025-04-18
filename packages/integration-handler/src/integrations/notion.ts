import axios from 'axios'
import {
  IntegrationClient,
  RetrievedResult,
  RetrieveRequest,
  State,
} from './integration'

interface NotionPage {
  id: string
  url: string
  properties: {
    title?: {
      title: Array<{
        plain_text: string
      }>
    }
    [key: string]: any
  }
  parent: {
    type: string
    database_id?: string
  }
}

interface NotionResponse {
  results: NotionPage[]
  next_cursor: string | null
  has_more: boolean
}

export class NotionClient extends IntegrationClient {
  name = 'NOTION'
  apiUrl = 'https://api.notion.com/v1'

  retrieve = async ({
    token,
    since = 0,
    count = 100,
    offset = 0,
    state,
  }: RetrieveRequest): Promise<RetrievedResult> => {
    try {
      const pages = await this.fetchPages(token, since, count, offset);
      
      const data = pages.map(page => ({
        url: page.url,
        labels: ['notion', 'page'],
        state: State.UNARCHIVED,
      }));
      
      return {
        data,
        hasMore: pages.length === count,
        since: Date.now()
      };
    } catch (error) {
      console.error('Error retrieving Notion content:', error);
      return {
        data: [],
        hasMore: false,
        since: since || Date.now()
      };
    }
  }
  
  private fetchPages = async (
    token: string,
    since: number,
    count: number,
    offset: number
  ): Promise<NotionPage[]> => {
    const headers = {
      'Authorization': `Bearer ${token}`,
      'Notion-Version': '2022-06-28',
      'Content-Type': 'application/json'
    };
    
    let allPages: NotionPage[] = [];
    let startCursor: string | null = null;
    let hasMore = true;
    
    // Convert since timestamp to ISO date string
    const sinceDate = since ? new Date(since).toISOString() : undefined;
    
    while (hasMore && allPages.length < offset + count) {
      try {
        // Search for pages
        const response = await axios.post<NotionResponse>(
          `${this.apiUrl}/search`,
          {
            filter: {
              value: 'page',
              property: 'object'
            },
            sort: {
              direction: 'descending',
              timestamp: 'last_edited_time'
            },
            page_size: 100,
            start_cursor: startCursor
          },
          { headers }
        );
        
        // Filter pages by last_edited_time if since is provided
        const filteredPages = sinceDate 
          ? response.data.results.filter(page => {
              const lastEditedTime = page.properties.last_edited_time?.date?.start;
              return lastEditedTime && new Date(lastEditedTime) >= new Date(sinceDate);
            })
          : response.data.results;
        
        allPages = [...allPages, ...filteredPages];
        startCursor = response.data.next_cursor;
        hasMore = response.data.has_more && !!startCursor;
      } catch (error) {
        console.error('Error fetching Notion pages:', error);
        break;
      }
    }
    
    // Apply pagination
    return allPages.slice(offset, offset + count);
  }
}
