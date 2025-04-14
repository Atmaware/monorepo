import { env } from '../env'

export const corsConfig = {
  credentials: true,
  origin: [
    'https://ruminer.app',
    'https://dev.ruminer.app',
    'https://demo.ruminer.app',
    'https://web-prod.ruminer.app',
    'https://web-dev.ruminer.app',
    'https://web-demo.ruminer.app',
    'http://localhost:3000',
    env.dev.isLocal && 'https://studio.apollographql.com',
    env.client.url,
    'lsp://logseq.io',
    'app://obsidian.md',
    'https://plugins.amplenote.com',
    'amplenote-handler://bundle',
    'capacitor://localhost',
    'http://localhost',
  ],
  maxAge: 86400,
}
