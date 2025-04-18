npm install
cp -r ../../converters ./
npm run build
cd converters
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
playwright install
cd ..
rm -rf ~/Library/CloudStorage/OneDrive-Personal/应用/Logseq/.obsidian/plugins/conversation-importer
cp -r . ~/Library/CloudStorage/OneDrive-Personal/应用/Logseq/.obsidian/plugins/conversation-importer