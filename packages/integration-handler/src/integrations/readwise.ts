import axios from 'axios'
import { wait } from '..'
import { highlightUrl, Item, RetrievedData, RetrievedResult, RetrieveRequest, State } from '../item'
import { IntegrationClient } from './integration'

interface ReadwiseHighlight {
  // The highlight text, (technically the only field required in a highlight object)
  text: string
  // The title of the page the highlight is on
  title?: string
  // The author of the page the highlight is on
  author?: string
  // The URL of the page image
  image_url?: string
  // The URL of the page
  source_url?: string
  // A meaningful unique identifier for your app
  source_type?: string
  // One of: books, articles, tweets or podcasts
  category?: string
  // Annotation note attached to the specific highlight
  note?: string
  // Highlight's location in the source text. Used to order the highlights
  location?: number
  // One of: page, order or time_offset
  location_type?: string
  // A datetime representing when the highlight was taken in the ISO 8601 format
  highlighted_at?: string
  // Unique url of the specific highlight
  highlight_url?: string
}

export class ReadwiseClient extends IntegrationClient {
  name = 'READWISE'
  apiUrl = 'https://readwise.io/api/v2'

  /**
   * Retrieve books and highlights from Readwise
   * This implementation uses Readwise's API to fetch user's books and highlights
   */
  retrieve = async (req: RetrieveRequest): Promise<RetrievedResult> => {
    try {
      const { token, since, offset = 0, count = 100 } = req;
      
      // Configure headers with authentication
      const headers = {
        'Authorization': `Token ${token}`,
        'Content-Type': 'application/json',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36'
      };

      // First, fetch books from Readwise API v2
      const books = await this.getAllDataV2('books', token, since);
      
      // Then fetch highlights from Readwise API v2
      const highlights = await this.getAllDataV2('highlights', token, since);
      
      // Also fetch documents from Readwise API v3
      const documents = await this.getAllDataV3(token, since);
      
      // Process the data into the required format
      const retrievedData = this.processReadwiseData(books, highlights, documents);
      
      // Apply pagination
      const paginatedData = retrievedData.slice(offset, offset + count);
      
      return {
        data: paginatedData,
        hasMore: offset + count < retrievedData.length,
        since: Date.now()
      };
    } catch (error) {
      console.error('Error retrieving Readwise content:', error);
      return {
        data: [],
        hasMore: false,
        since: since || Date.now()
      };
    }
  }

  /**
   * Fetch all data from Readwise API v2
   * @param category 'books' or 'highlights'
   * @param token Readwise API token
   * @param since Unix timestamp in milliseconds
   */
  private getAllDataV2 = async (
    category: 'books' | 'highlights',
    token: string,
    since?: number
  ): Promise<any[]> => {
    const headers = {
      'Authorization': `Token ${token}`,
      'Content-Type': 'application/json',
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36'
    };
    
    const params: Record<string, any> = {
      page_size: 999
    };
    
    if (since) {
      // Convert milliseconds to ISO string for Readwise API
      const sinceDate = new Date(since).toISOString();
      params.updated__gt = sinceDate;
    }
    
    let url = `${this.apiUrl}/${category}/`;
    const data: any[] = [];
    
    while (url) {
      try {
        const response = await axios.get(url, { headers, params });
        data.push(...response.data.results);
        url = response.data.next;
        
        // Clear params for subsequent requests as they're included in the next URL
        params = {};
      } catch (error) {
        console.error(`Error fetching ${category} from Readwise:`, error);
        break;
      }
    }
    
    return data;
  }

  /**
   * Fetch all data from Readwise API v3
   * @param token Readwise API token
   * @param since Unix timestamp in milliseconds
   */
  private getAllDataV3 = async (
    token: string,
    since?: number
  ): Promise<any[]> => {
    const headers = {
      'Authorization': `Token ${token}`,
      'Content-Type': 'application/json',
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36'
    };
    
    const params: Record<string, any> = {};
    
    if (since) {
      // Convert milliseconds to ISO string for Readwise API
      const sinceDate = new Date(since).toISOString();
      params.updatedAfter = sinceDate;
    }
    
    const url = 'https://readwise.io/api/v3/list/';
    const data: any[] = [];
    
    while (true) {
      try {
        const response = await axios.get(url, { headers, params });
        data.push(...response.data.results);
        
        if (!response.data.nextPageCursor) {
          break;
        }
        
        params.pageCursor = response.data.nextPageCursor;
      } catch (error) {
        console.error('Error fetching documents from Readwise:', error);
        break;
      }
    }
    
    return data;
  }

  /**
   * Process Readwise data into the required format
   * @param books Books from Readwise API v2
   * @param highlights Highlights from Readwise API v2
   * @param documents Documents from Readwise API v3
   */
  private processReadwiseData = (
    books: any[],
    highlights: any[],
    documents: any[]
  ): RetrievedData[] => {
    const result: RetrievedData[] = [];
    
    // Process books
    books.forEach(book => {
      result.push({
        url: book.source_url || `https://readwise.io/bookreview/${book.id}`,
        labels: ['readwise', 'book', book.category].filter(Boolean),
        state: State.UNARCHIVED
      });
    });
    
    // Process documents
    documents.forEach(doc => {
      // Skip if already processed as a book
      const existingUrl = result.find(item => item.url === doc.source_url);
      if (existingUrl) return;
      
      result.push({
        url: doc.source_url || `https://readwise.io/document/${doc.id}`,
        labels: ['readwise', doc.document_type || 'document'].filter(Boolean),
        state: State.UNARCHIVED
      });
    });
    
    return result;
  }

  export = async (token: string, items: Item[]): Promise<boolean> => {
    let result = true

    const highlights = items.flatMap(this.itemToReadwiseHighlight)

    // If there are no highlights, we will skip the sync
    if (highlights.length > 0) {
      result = await this.syncWithReadwise(token, highlights)
    }

    return result
  }

  itemToReadwiseHighlight = (item: Item): ReadwiseHighlight[] => {
    const category = item.siteName === 'Twitter' ? 'tweets' : 'articles'
    return item.highlights
      .map((highlight) => {
        // filter out highlights that are not of type highlight or have no quote
        if (highlight.type !== 'HIGHLIGHT' || !highlight.quote) {
          return undefined
        }

        return {
          text: highlight.quote,
          title: item.title,
          author: item.author || undefined,
          highlight_url: highlightUrl(item.slug, highlight.id),
          highlighted_at: new Date(highlight.createdAt).toISOString(),
          category,
          image_url: item.image || undefined,
          location_type: 'order',
          note: highlight.annotation || undefined,
          source_type: 'ruminer',
          source_url: item.url,
        }
      })
      .filter((highlight) => highlight !== undefined) as ReadwiseHighlight[]
  }

  syncWithReadwise = async (
    token: string,
    highlights: ReadwiseHighlight[],
    retryCount = 0
  ): Promise<boolean> => {
    const url = `${this.apiUrl}/highlights`
    try {
      const response = await axios.post(
        url,
        {
          highlights,
        },
        {
          headers: {
            Authorization: `Token ${token}`,
            'Content-Type': 'application/json',
          },
          timeout: 5000, // 5 seconds
        }
      )
      return response.status === 200
    } catch (error) {
      console.error(error)

      if (axios.isAxiosError(error)) {
        if (error.response?.status === 429 && retryCount < 3) {
          console.log('Readwise API rate limit exceeded, retrying...')
          // wait for Retry-After seconds in the header if rate limited
          // max retry count is 3
          const retryAfter = error.response?.headers['retry-after'] || '10' // default to 10 seconds
          await wait(parseInt(retryAfter, 10) * 1000)
          return this.syncWithReadwise(token, highlights, retryCount + 1)
        }
      }

      return false
    }
  }
}
