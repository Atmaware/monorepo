import axios from 'axios'
import { IntegrationClient } from './integration'
import { PocketClient } from './pocket'
import { ReadwiseClient } from './readwise'
import { TwitterClient } from './twitter'
import { ZhihuClient } from './zhihu'
import { BilibiliClient } from './bilibili'
import { YouTubeClient } from './youtube'
import { ZoteroClient } from './zotero'
import { WeReadClient } from './weread'
import { DiscordClient } from './discord'
import { InstapaperClient } from './instapaper'
import { NotionClient } from './notion'
import { ObsidianClient } from './obsidian'
import { ChatGPTClient } from './chatgpt'
import { GmailClient } from './gmail'
import { OneNoteClient } from './onenote'
import { PodcastClient } from './podcast'

interface SetIntegrationResponse {
  data: {
    setIntegration: {
      integration: {
        id: string
      }
      errorCodes: string[]
    }
  }
}

const clients: IntegrationClient[] = [
  new ReadwiseClient(), 
  new PocketClient(),
  new TwitterClient(),
  new ZhihuClient(),
  new BilibiliClient(),
  new YouTubeClient(),
  new ZoteroClient(),
  new WeReadClient(),
  new DiscordClient(),
  new InstapaperClient(),
  new NotionClient(),
  new ObsidianClient(),
  new ChatGPTClient(),
  new GmailClient(),
  new OneNoteClient(),
  new PodcastClient()
]

export const getIntegrationClient = (name: string): IntegrationClient => {
  const client = clients.find((s) => s.name === name)
  if (!client) {
    throw new Error(`Integration client not found: ${name}`)
  }
  return client
}

export const updateIntegration = async (
  apiEndpoint: string,
  id: string,
  syncedAt: Date,
  name: string,
  integrationToken: string,
  token: string,
  type: string,
  taskName?: string | null
): Promise<boolean> => {
  const requestData = JSON.stringify({
    query: `
      mutation SetIntegration($input: SetIntegrationInput!) {
        setIntegration(input: $input) {
          ... on SetIntegrationSuccess {
            integration {
              id
              enabled
            }
          }
          ... on SetIntegrationError {
            errorCodes
          }
        }
      }`,
    variables: {
      input: {
        id,
        syncedAt,
        name,
        token: integrationToken,
        enabled: true,
        type,
        // taskName, // TODO: remove this
      },
    },
  })

  try {
    const response = await axios.post<SetIntegrationResponse>(
      `${apiEndpoint}/graphql`,
      requestData,
      {
        headers: {
          Cookie: `auth=${token};`,
          'Content-Type': 'application/json',
          'X-RuminerClient': 'integration-handler',
        },
      }
    )

    if (response.data.data.setIntegration.errorCodes) {
      console.error(response.data.data.setIntegration.errorCodes)
      return false
    }

    return true
  } catch (error) {
    console.error(error)
    return false
  }
}
