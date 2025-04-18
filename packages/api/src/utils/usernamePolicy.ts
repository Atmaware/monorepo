const REGEX_POLICY = /^[a-z0-9][a-z0-9_]+[a-z0-9]$/

const RESERVED_NAMES = new Set([
  'ruminer',
  'supportdetails',
  'support-details',
  'stacks',
  'imulus',
  'github',
  'twitter',
  'facebook',
  'google',
  'apple',
  'about',
  'account',
  'activate',
  'add',
  'admin',
  'administrator',
  'api',
  'app',
  'apps',
  'archive',
  'archives',
  'article',
  'articles',
  'auth',
  'blog',
  'cache',
  'cancel',
  'careers',
  'cart',
  'changelog',
  'checkout',
  'codereview',
  'collect',
  'company',
  'compare',
  'config',
  'configuration',
  'connect',
  'contact',
  'create',
  'delete',
  '_debug',
  'digest',
  'digests',
  'discover',
  'direct_messages',
  'documentation',
  'download',
  'downloads',
  'edit',
  'email',
  'employment',
  'enterprise',
  'faq',
  'favorites',
  'feed',
  'feedback',
  'feeds',
  'fleet',
  'fleets',
  'follow',
  'followers',
  'following',
  'for',
  'friend',
  'friends',
  'gist',
  'group',
  'groups',
  'help',
  'home',
  'hosting',
  'hostmaster',
  'idea',
  'ideas',
  'index',
  'info',
  'ingest',
  'install',
  'invitations',
  'invite',
  'is',
  'it',
  'job',
  'jobs',
  'join',
  'json',
  'landing',
  'language',
  'languages',
  'lists',
  'login',
  'logout',
  'logs',
  'mail',
  'map',
  'maps',
  'mine',
  'mis',
  'news',
  'no_url',
  'oauth',
  'oauth_clients',
  'offers',
  'openid',
  'order',
  'orders',
  'organizations',
  'plans',
  'popular',
  'post',
  'posts',
  'postmaster',
  'privacy',
  'profile',
  'projects',
  'put',
  'recruitment',
  'register',
  'remove',
  'replies',
  'robots.txt',
  'root',
  'rss',
  'sales',
  'save',
  'search',
  'security',
  'security.txt',
  'sessions',
  'settings',
  'shop',
  'signup',
  'sitemap',
  'ssl',
  'ssladmin',
  'ssladministrator',
  'sslwebmaster',
  'status',
  'stories',
  'styleguide',
  'subscribe',
  'subscriptions',
  'support',
  'sysadmin',
  'sysadministrator',
  'terms',
  'tour',
  'tools',
  'translations',
  'trends',
  'unfollow',
  'unsubscribe',
  'update',
  'url',
  'user',
  'waitlist',
  'weather',
  'webmaster',
  'widget',
  'widgets',
  'wiki',
  'ww',
  'www',
  'wwww',
  'welcome',
  'xfn',
  'xml',
  'xmpp',
  'yaml',
  'yml',
])

export const validateUsername = (username: string): boolean => {
  const lowerCasedUsername = username.toLowerCase()
  if (RESERVED_NAMES.has(lowerCasedUsername)) {
    return false
  }

  if (lowerCasedUsername.length < 4 || lowerCasedUsername.length > 15) {
    return false
  }

  if (
    lowerCasedUsername.includes('ruminer') ||
    lowerCasedUsername.includes('admin')
  ) {
    return false
  }

  return REGEX_POLICY.test(lowerCasedUsername)
}
