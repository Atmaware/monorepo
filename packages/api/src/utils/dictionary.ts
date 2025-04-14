/* eslint-disable @typescript-eslint/naming-convention */
export enum UserRole {
  ADMIN = 'admin',
}

export enum SetClaimsRole {
  USER = 'user',
  ADMIN = 'admin',
}

export enum Table {
  USER = 'ruminer.user',
  LINKS = 'ruminer.links',

  PAGES = 'ruminer.pages',
  USER_PROFILE = 'ruminer.user_profile',
  USER_FRIEND = 'ruminer.user_friends',
  USER_FEED_ARTICLE = 'ruminer.user_feed_articles',
  USER_PERSONALIZATION = 'ruminer.user_personalization',
  ARTICLE_SAVING_REQUEST = 'ruminer.article_saving_request',
  UPLOAD_FILES = 'ruminer.upload_files',
  HIGHLIGHT = 'ruminer.highlight',
  HIGHLIGHT_REPLY = 'ruminer.highlight_reply',
  REACTION = 'ruminer.reaction',
  REMINDER = 'ruminer.reminders',
  LABELS = 'ruminer.labels',
  LINK_LABELS = 'ruminer.link_labels',
}
