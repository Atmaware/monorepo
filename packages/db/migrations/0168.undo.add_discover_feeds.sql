-- Type: UNDO
-- Name: add_discover_feed_tables
-- Description: Add Discovery Feed Tables, including counts.

DROP TABLE ruminer.discover_feed;
DROP TABLE ruminer.discover_feed_subscription;
DROP TABLE ruminer.discover_feed_articles;
DROP TABLE ruminer.discover_feed_save_link CASCADE;
DROP TABLE ruminer.discover_feed_article_topic_link;
DROP TABLE ruminer.discover_topics CASCADE;
DROP TABLE ruminer.discover_topic_embedding_link;
