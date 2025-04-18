import axios from 'axios'
import {
  IntegrationClient,
  RetrievedResult,
  RetrieveRequest,
  State,
} from './integration'

interface OneNotePage {
  id: string
  title: string
  createdDateTime: string
  lastModifiedDateTime: string
  contentUrl: string
  links: {
    oneNoteClientUrl: {
      href: string
    }
  }
}

interface OneNoteSection {
  id: string
  displayName: string
  pages: OneNotePage[]
}

interface OneNoteNotebook {
  id: string
  displayName: string
  sections: OneNoteSection[]
}

export class OneNoteClient extends IntegrationClient {
  name = 'ONENOTE'
  apiUrl = 'https://graph.microsoft.com/v1.0/me/onenote'

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
        url: page.links.oneNoteClientUrl.href,
        labels: ['onenote', 'note'],
        state: State.UNARCHIVED,
      }));
      
      return {
        data,
        hasMore: pages.length === count,
        since: Date.now()
      };
    } catch (error) {
      console.error('Error retrieving OneNote content:', error);
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
  ): Promise<OneNotePage[]> => {
    const headers = {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    };
    
    try {
      // Convert since timestamp to ISO date string for filtering
      const sinceDate = since ? new Date(since).toISOString() : undefined;
      
      // Fetch pages with filter if since is provided
      let url = `${this.apiUrl}/pages`;
      if (sinceDate) {
        url += `?$filter=lastModifiedDateTime ge ${sinceDate}`;
      }
      
      // Add pagination parameters
      url += sinceDate ? '&' : '?';
      url += `$skip=${offset}&$top=${count}&$orderby=lastModifiedDateTime desc`;
      
      const response = await axios.get(url, { headers });
      
      return response.data.value;
    } catch (error) {
      console.error('Error fetching OneNote pages:', error);
      return [];
    }
  }
}
