# ChatGPT Conversation Converter for Obsidian

This plugin allows you to convert shared ChatGPT conversations to markdown files in your Obsidian vault.

## Features

- Convert multiple ChatGPT conversation URLs at once
- Save conversations as markdown files in a specified folder
- Maintains conversation structure and formatting
- Preserves metadata in YAML frontmatter

## Installation

1. Download the latest release from the releases page
2. Extract the archive into your Obsidian vault's `.obsidian/plugins` folder
3. Enable the plugin in Obsidian's settings

## Usage

1. Open the command palette (Cmd/Ctrl + P)
2. Search for "Convert ChatGPT Conversations"
3. Enter the URLs of the shared ChatGPT conversations (one per line)
4. Click "Convert"

The conversations will be saved as markdown files in the specified output folder (default: `chatgpt/`).

## Settings

- **Output folder**: The folder where converted conversations will be saved (default: `chatgpt`)

## Requirements

- Python 3.7 or higher
- Playwright Python package (`pip install playwright`)
- Other dependencies from the original converter script

## Development

1. Clone this repository
2. Install dependencies:
   ```bash
   npm install
   ```
3. Build the plugin:
   ```bash
   npm run build
   ```

## License

MIT
