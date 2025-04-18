import axios from 'axios'
import {
  IntegrationClient,
  RetrievedResult,
  RetrieveRequest,
  State,
} from './integration'

interface EmailMessage {
  id: string
  threadId: string
  subject: string
  snippet: string
  from: string
  to: string[]
  date: string
  labels: string[]
  hasAttachments: boolean
}

export class GmailClient extends IntegrationClient {
  name = 'GMAIL'
  apiUrl = 'https://gmail.googleapis.com/gmail/v1'

  retrieve = async ({
    token,
    since = 0,
    count = 100,
    offset = 0,
    state,
  }: RetrieveRequest): Promise<RetrievedResult> => {
    try {
      const emails = await this.fetchEmails(token, since, count, offset);
      
      const data = emails.map(email => ({
        url: `https://mail.google.com/mail/u/0/#inbox/${email.threadId}`,
        labels: ['email', ...(email.labels || [])],
        state: this.mapEmailStateToState(email.labels),
      }));
      
      return {
        data,
        hasMore: emails.length === count,
        since: Date.now()
      };
    } catch (error) {
      console.error('Error retrieving Email content:', error);
      return {
        data: [],
        hasMore: false,
        since: since || Date.now()
      };
    }
  }
  
  private mapEmailStateToState = (labels: string[]): State => {
    if (labels.includes('TRASH')) {
      return State.DELETED;
    } else if (labels.includes('SPAM')) {
      return State.ARCHIVED;
    } else if (labels.includes('INBOX')) {
      return State.UNREAD;
    } else {
      return State.UNARCHIVED;
    }
  }
  
  private fetchEmails = async (
    token: string,
    since: number,
    count: number,
    offset: number
  ): Promise<EmailMessage[]> => {
    const headers = {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    };
    
    try {
      // First, get message IDs that match our criteria
      let query = '';
      if (since) {
        const sinceDate = new Date(since);
        query = `after:${sinceDate.getFullYear()}/${sinceDate.getMonth() + 1}/${sinceDate.getDate()}`;
      }
      
      const listResponse = await axios.get(
        `${this.apiUrl}/users/me/messages`,
        {
          headers,
          params: {
            q: query,
            maxResults: count,
            pageToken: offset > 0 ? String(offset) : undefined
          }
        }
      );
      
      // Then fetch detailed information for each message
      const messagePromises = listResponse.data.messages.map(async (message: { id: string }) => {
        const messageResponse = await axios.get(
          `${this.apiUrl}/users/me/messages/${message.id}`,
          { headers }
        );
        
        const headers = messageResponse.data.payload.headers;
        const subject = headers.find((h: { name: string }) => h.name.toLowerCase() === 'subject')?.value || '';
        const from = headers.find((h: { name: string }) => h.name.toLowerCase() === 'from')?.value || '';
        const to = headers.find((h: { name: string }) => h.name.toLowerCase() === 'to')?.value.split(',') || [];
        const date = headers.find((h: { name: string }) => h.name.toLowerCase() === 'date')?.value || '';
        
        return {
          id: message.id,
          threadId: messageResponse.data.threadId,
          subject,
          snippet: messageResponse.data.snippet,
          from,
          to,
          date,
          labels: messageResponse.data.labelIds || [],
          hasAttachments: !!messageResponse.data.payload.parts?.some(
            (part: { filename: string }) => part.filename && part.filename.length > 0
          )
        };
      });
      
      return Promise.all(messagePromises);
    } catch (error) {
      console.error('Error fetching emails:', error);
      return [];
    }
  }
}
