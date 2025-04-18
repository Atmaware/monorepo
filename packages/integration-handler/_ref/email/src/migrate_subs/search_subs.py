import os
import google.auth
import google_auth_oauthlib.flow
from googleapiclient.discovery import build
from google.auth.transport.requests import Request
import pickle

def setup_gmail_service():
    # Load or request credentials
    SCOPES = ['https://www.googleapis.com/auth/gmail.readonly']
    creds = None

    # Check if token.pickle exists to skip re-authentication
    if os.path.exists('token.pickle'):
        with open('token.pickle', 'rb') as token:
            creds = pickle.load(token)

    # If no valid credentials, authenticate and save token
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = google_auth_oauthlib.flow.InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server(port=8080)
        with open('token.pickle', 'wb') as token:
            pickle.dump(creds, token)

    # Initialize Gmail API service
    return build('gmail', 'v1', credentials=creds)

def list_unsubable_senders(service):
    # Search for messages containing "unsubscribe"
    results = service.users().messages().list(userId='me', q="unsubscribe").execute()
    messages = results.get('messages', [])

    sender_addresses = []
    for msg in messages:
        msg_data = service.users().messages().get(userId='me', id=msg['id'], format='metadata').execute()
        headers = msg_data['payload']['headers']
        # Extract the 'From' address
        for header in headers:
            if header['name'] == 'From':
                sender_addresses.append(header['value'])
                break

    return sender_addresses

# Run the function and print results
if __name__ == '__main__':
    unsubscribe_senders = list_unsubable_senders(setup_gmail_service())
    print("Senders of emails containing 'unsubscribe':")
    for sender in set(unsubscribe_senders):
        print(sender)
