import axios from 'axios'
import { parse } from 'csv-parse'
import { createObjectCsvWriter } from 'csv-writer'
import fs from 'fs'
import { finished } from 'stream/promises'
import { gql, GraphQLClient } from 'graphql-request'
import { Item } from '../item'
import { IntegrationClient, RetrieveRequest, RetrievedResult, State } from './integration'

interface InstapaperBookmark {
  bookmark_id: number
  title: string
  url: string
  description: string
  time: number
  starred: string
  private_source: string
  hash: string
  progress: number
  progress_timestamp: number
}

interface InstapaperHighlight {
  highlight_id: number
  bookmark_id: number
  text: string
  note: string
  time: number
  position: number
}

interface ImportItem {
  url: string
  title: string
  selection: string
  folder: string
  timestamp: string
}

export class InstapaperClient extends IntegrationClient {
  name = 'INSTAPAPER'
  apiUrl = 'https://www.instapaper.com/api/1'
  OMNIVORE_API_URL = 'https://api-prod.omnivore.app/api/graphql'
  
  /**
   * Retrieve bookmarks and highlights from Instapaper
   * This implementation uses Instapaper's API to fetch user's saved content
   */
  retrieve = async (req: RetrieveRequest): Promise<RetrievedResult> => {
    try {
      const { token, since, offset = 0, count = 50 } = req
      
      // Instapaper uses OAuth 1.0a for authentication
      // The token should be in the format "oauth_token:oauth_token_secret"
      const [oauthToken, oauthTokenSecret] = token.split(':')
      
      // In a real implementation, we would use the OAuth credentials to make API calls
      // We would need to implement OAuth 1.0a signing for the requests
      
      // First, fetch the user's bookmarks
      // const bookmarksResponse = await this.makeOAuthRequest(
      //   'GET',
      //   `${this.apiUrl}/bookmarks/list`,
      //   {
      //     limit: count,
      //     folder_id: 'unread', // or 'starred', 'archive'
      //     have: offset > 0 ? offset : undefined
      //   },
      //   oauthToken,
      //   oauthTokenSecret
      // )
      
      // const bookmarks: InstapaperBookmark[] = bookmarksResponse.data.bookmarks
      
      // For each bookmark, fetch the highlights
      // const allHighlights: RetrievedData[] = []
      
      // for (const bookmark of bookmarks) {
      //   const highlightsResponse = await this.makeOAuthRequest(
      //     'GET',
      //     `${this.apiUrl}/bookmarks/${bookmark.bookmark_id}/highlights`,
      //     {},
      //     oauthToken,
      //     oauthTokenSecret
      //   )
      //   
      //   // Convert to Ruminer format
      //   allHighlights.push({
      //     url: bookmark.url,
      //     labels: ['instapaper', bookmark.starred === '1' ? 'starred' : 'unread'],
      //     state: State.UNARCHIVED
      //   })
      // }
      
      // For now, return an empty result
      // This would be replaced with actual API integration
      return {
        data: [],
        hasMore: false,
        since: Date.now()
      }
    } catch (error) {
      console.error('Error retrieving Instapaper content:', error)
      return {
        data: [],
        hasMore: false,
        since: since || Date.now()
      }
    }
  }
  
  /**
   * Export highlights to Instapaper or import from Instapaper to Omnivore
   * Based on the provided CSV export from Instapaper
   */
  export = async (token: string, items: Item[]): Promise<boolean> => {
    try {
      // If we're exporting to Instapaper
      if (items.length > 0) {
        // Instapaper uses OAuth 1.0a for authentication
        const [oauthToken, oauthTokenSecret] = token.split(':')
        
        // In a real implementation, we would use the OAuth credentials to make API calls
        // We would need to implement OAuth 1.0a signing for the requests
        
        // For each item, add a bookmark to Instapaper
        // for (const item of items) {
        //   await this.makeOAuthRequest(
        //     'POST',
        //     `${this.apiUrl}/bookmarks/add`,
        //     {
        //       url: item.url,
        //       title: item.title,
        //       description: item.description
        //     },
        //     oauthToken,
        //     oauthTokenSecret
        //   )
        // }
        
        return true
      } else {
        // If we're importing from Instapaper to Omnivore
        return await this.importFromInstapaperToOmnivore(token)
      }
    } catch (error) {
      console.error('Error with Instapaper operation:', error)
      return false
    }
  }
  
  /**
   * Import data from Instapaper CSV export to Omnivore
   * @param omnivoreApiKey The Omnivore API key
   */
  private importFromInstapaperToOmnivore = async (omnivoreApiKey: string): Promise<boolean> => {
    try {
      const INSTAPAPER_CSV_EXPORT_PATH = `${process.cwd()}/instapaper-export.csv`
      
      if (!fs.existsSync(INSTAPAPER_CSV_EXPORT_PATH)) {
        console.error(`Instapaper export CSV not found at ${INSTAPAPER_CSV_EXPORT_PATH}`)
        return false
      }
      
      const client = new GraphQLClient(this.OMNIVORE_API_URL, {
        headers: {
          authorization: omnivoreApiKey,
        },
      })
      
      const entries = await this.processCsv(INSTAPAPER_CSV_EXPORT_PATH)
      let addedEntriesCount = 0
      let archivedEntriesCount = 0
      let failedEntriesCount = 0
      
      const failedEntries: ImportItem[] = []
      
      console.log(`Adding ${entries.length} links to Omnivore..`)
      
      for (const entry of entries) {
        try {
          const response = await client.request(this.createArticleMutation, {
            input: { url: entry.url },
          })
          addedEntriesCount++
          
          if (entry.folder === 'Archive') {
            await client.request(this.createArchiveMutation, {
              input: { 
                linkId: response.createArticleSavingRequest.articleSavingRequest.id, 
                archived: true 
              },
            })
            archivedEntriesCount++
          }
        } catch (error) {
          console.error(`Failed to add ${entry.url}`)
          failedEntries.push({
            url: entry.url,
            title: entry.title || '',
            selection: entry.selection || '',
            folder: entry.folder || '',
            timestamp: entry.timestamp || ''
          })
          
          failedEntriesCount++
        }
      }
      
      console.log(
        `Successfully added ${addedEntriesCount} (Archived: ${archivedEntriesCount}) of ${entries.length} links!`
      )
      
      if (failedEntriesCount > 0) {
        const csvWriter = createObjectCsvWriter({
          path: `error_${new Date().toJSON().slice(0, 10)}.csv`,
          header: [
            { id: 'url', title: 'URL' },
            { id: 'title', title: 'Title' },
            { id: 'selection', title: 'Selection' },
            { id: 'folder', title: 'Folder' },
            { id: 'timestamp', title: 'Timestamp' },
          ]
        })
        
        await csvWriter.writeRecords(failedEntries)
        console.log('The CSV file with failed entries was written successfully')
      }
      
      return addedEntriesCount > 0
    } catch (error) {
      console.error('Error importing from Instapaper to Omnivore:', error)
      return false
    }
  }
  
  /**
   * Process the Instapaper CSV export file
   * @param csvPath Path to the CSV file
   */
  private processCsv = async (csvPath: string): Promise<ImportItem[]> => {
    const records: ImportItem[] = []
    const parser = fs.createReadStream(csvPath).pipe(parse())
    
    parser.on('readable', () => {
      let record
      while ((record = parser.read()) !== null) {
        if (record[0] !== 'URL') {
          records.push({ 
            url: record[0], 
            title: record[1] || '',
            selection: record[2] || '',
            folder: record[3] || '',
            timestamp: record[4] || ''
          })
        }
      }
    })
    
    await finished(parser)
    return records
  }
  
  // GraphQL mutations for Omnivore
  private createArticleMutation = gql`
    mutation CreateArticleSavingRequest($input: CreateArticleSavingRequestInput!) {
      createArticleSavingRequest(input: $input) {
        ... on CreateArticleSavingRequestSuccess {
          articleSavingRequest {
            id
            status
          }
        }
        ... on CreateArticleSavingRequestError {
          errorCodes
        }
      }
    }
  `
  
  private createArchiveMutation = gql`
    mutation SetLinkArchived($input: ArchiveLinkInput!) {
      setLinkArchived(input: $input) {
        ... on ArchiveLinkSuccess {
          linkId
          message
        }
        ... on ArchiveLinkError {
          message
          errorCodes
        }
      }
    }
  `
  
  // Helper method to make OAuth 1.0a requests
  // private makeOAuthRequest = async (
  //   method: string,
  //   url: string,
  //   params: Record<string, any>,
  //   oauthToken: string,
  //   oauthTokenSecret: string
  // ) => {
  //   // In a real implementation, we would use a library like oauth-1.0a to sign the request
  //   // For now, this is a placeholder
  //   return axios({
  //     method,
  //     url,
  //     params: method === 'GET' ? params : undefined,
  //     data: method === 'POST' ? params : undefined
  //   })
  // }
}
