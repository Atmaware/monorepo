import normalizeUrl from 'normalize-url'

const BLOCKED_SITES = [
  'https://mail.google.com/',
  'https://accounts.google.com/',
  'https://dev.ruminer.app',
  'https://demo.ruminer.app',
  'https://ruminer.app',
]

export const isSiteBlockedForParse = (urlToParse: string): boolean => {
  let isBlocked = false
  const host = getHost(urlToParse)

  for (const site of BLOCKED_SITES) {
    const blockedHost = getHost(site)

    isBlocked = host === blockedHost
    if (isBlocked) break
  }

  return isBlocked
}

const getHost = (url: string): string =>
  new URL(normalizeUrl(url, { stripWWW: true })).host
