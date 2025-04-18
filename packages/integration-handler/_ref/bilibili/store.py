# %%
import json
import os
import dotenv
from pathlib import Path
from pymongo import MongoClient

dotenv.load_dotenv()

# Connect to the MongoDB cluster
client = MongoClient(f'mongodb://{os.getenv("MONGO_USERNAME")}:{os.getenv("MONGO_PASSWORD")}@{os.getenv("MONGO_URL")}:27017/?directConnection=true&tls=true')
client.drop_database('bilibili')

# Create the database if it doesn't exist
db = client['bilibili']
collection = db['fav']

# %%
def store(file: Path, collection=collection):
    with open(file, 'r') as f:
        data = json.load(f)
    documents = []
    for item in data.values():
        if item['是否失效']:
            continue
        documents.append(dict(
            collection = file.stem,
            bv_id = item['BV'],
            up_id = item['up主']['ID'],
            up_name = item['up主']['昵称'],
            title = item['视频信息']['标题'],
            brief = item['视频信息']['简介'],
            duration = item['视频信息']['时长'],
            tags = item['标签'],
        ))
        if item.get('AI总结', ''):
            documents[-1]['brief'] += '\n\nAI 总结：\n' + item['AI总结']
    collection.insert_many(documents)
    print("Data inserted successfully from", file)

if __name__ == '__main__':
    for file in Path('收藏夹信息').glob('*.json'):
        store(file, collection)