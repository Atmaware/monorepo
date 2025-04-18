1. Purchased a domain name "feedup.today" from GoDaddy
2. Set up Amazon SES and added CNAME records to my domain name
3. Enabled GMail API in my GCP project and downloaded OAuth credentials JSON file
4. Implemented `migrate_subs/search_subs.py` to search for all email subscriptions in a user's GMail account
5. Created an AWS S3 bucket to store the email feeds
6. Created an AWS Lambda function to summarize the emails in the bucket and send a report to the user