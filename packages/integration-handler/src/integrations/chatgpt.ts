import axios from 'axios'
import {
  IntegrationClient,
  RetrievedResult,
  RetrieveRequest,
  State,
} from './integration'

interface ChatGPTConversation {
  id: string
  title: string
  create_time: string
  update_time: string
  mapping: Record<string, {
    message?: {
      content: {
        parts: string[]
      }
      author: {
        role: string
      }
      create_time: number
    }
  }>
}

interface ChatGPTResponse {
  items: ChatGPTConversation[]
  has_more: boolean
  limit: number
  offset: number
}

export class ChatGPTClient extends IntegrationClient {
  name = 'CHATGPT'
  apiUrl = 'https://chat.openai.com/backend-api'

  retrieve = async ({
    token,
    since = 0,
    count = 100,
    offset = 0,
    state,
  }: RetrieveRequest): Promise<RetrievedResult> => {
    try {
      const conversations = await this.fetchConversations(token, since, count, offset);
      
      const data = conversations.map(conversation => ({
        url: `https://chat.openai.com/c/${conversation.id}`,
        labels: ['chatgpt', 'conversation'],
        state: State.UNARCHIVED,
      }));
      
      return {
        data,
        hasMore: conversations.length === count,
        since: Date.now()
      };
    } catch (error) {
      console.error('Error retrieving ChatGPT content:', error);
      return {
        data: [],
        hasMore: false,
        since: since || Date.now()
      };
    }
  }
  
  private fetchConversations = async (
    token: string,
    since: number,
    count: number,
    offset: number
  ): Promise<ChatGPTConversation[]> => {
    const headers = {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    };
    
    try {
      const response = await axios.get<ChatGPTResponse>(
        `${this.apiUrl}/conversations`,
        {
          headers,
          params: {
            offset,
            limit: count,
            order: 'updated'
          }
        }
      );
      
      // Filter conversations by update_time if since is provided
      if (since) {
        return response.data.items.filter(conversation => {
          const updateTime = new Date(conversation.update_time).getTime();
          return updateTime >= since;
        });
      }
      
      return response.data.items;
    } catch (error) {
      console.error('Error fetching ChatGPT conversations:', error);
      return [];
    }
  }
}
