import os
import dotenv
import requests

dotenv.load_dotenv()

headers = {
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36',
    'Authorization': f'Token {os.getenv("READWISE_TOKEN")}',
}

def get_daily_reviews():
    url = 'https://readwise.io/api/v2/review/'
    res = requests.get(url, headers=headers).json()
    return res['highlights']

def get_all_data_v2(category, updated__gt=None, **kwargs):
    # category = 'highlights' | 'books'
    url = f'https://readwise.io/api/v2/{category}/'
    params = dict(page_size=999, **kwargs)
    if updated__gt:
        params['updated__gt'] = updated__gt
    data = []
    while True:
        res = requests.get(url, params=params, headers=headers).json()
        data.extend(res['results'])
        if not (url := res['next']): break
    return data

def get_all_data_v3(updated_after=None, location=None):
    full_data = []
    params = {}
    if updated_after:
        params['updatedAfter'] = updated_after
    if location:
        params['location'] = location
    while True:
        response = requests.get(
            url="https://readwise.io/api/v3/list/",
            params=params,
            headers=headers
        ).json()
        full_data.extend(response['results'])
        params['pageCursor'] = response['nextPageCursor']
        if not response['nextPageCursor']: break
    return full_data


if __name__ == '__main__':
    from pymongo import MongoClient

    client = MongoClient(f'mongodb://{os.getenv("MONGO_USERNAME")}:{os.getenv("MONGO_PASSWORD")}@{os.getenv("MONGO_URL")}:27017/?directConnection=true&tls=true')
    client.drop_database('readwise')
    db = client['readwise']

    db['highlights'].insert_many(get_all_data_v2('highlights'))
    db['books'].insert_many(get_all_data_v2('books'))
    db['documents'].insert_many(get_all_data_v3())
