#!/usr/bin/env python3

import asyncio
from playwright.async_api import async_playwright, BrowserContext
import yaml
import argparse
import sys
from markdownify import markdownify
from typing import Dict, List, Optional
import json
from pathlib import Path

async def ensure_authenticated(context: BrowserContext, playwright) -> bool:
    """Ensure we're logged into ChatGPT."""
    page = None
    browser = None
    login_context = None
    try:
        # Check if already logged in
        page = await context.new_page()
        await page.goto('https://chat.openai.com')
        
        try:
            await page.wait_for_selector('div.text-message', timeout=5000)
            await page.close()
            return True
        except:
            await page.close()
        
        # Launch a visible browser for interactive login
        print("Opening browser for ChatGPT login...")
        browser = await playwright.chromium.launch(
            headless=False,
            args=['--start-maximized']  # Make the window visible and maximized
        )
        login_context = await browser.new_context(
            viewport=None,  # Use the window size
            accept_downloads=True
        )
        
        login_page = await login_context.new_page()
        await login_page.goto('https://chat.openai.com')
        
        # Wait for successful login (user will handle the login process)
        try:
            await login_page.wait_for_selector('div.text-message', timeout=300000)  # 5 minutes timeout
            
            # Save cookies and storage state
            storage_state = await login_context.storage_state()
            await context.add_cookies(storage_state['cookies'])
            
            await login_context.close()
            await browser.close()
            return True
            
        except Exception as e:
            print("Login timeout or error. Please try again.", file=sys.stderr)
            if login_context:
                await login_context.close()
            if browser:
                await browser.close()
            return False
        
    except Exception as e:
        print(f"Error during authentication: {e}", file=sys.stderr)
        if page and not page.is_closed():
            await page.close()
        if login_context:
            await login_context.close()
        if browser:
            await browser.close()
        return False

async def fetch_chatgpt_conversation(url: str, browser_context: BrowserContext) -> Optional[Dict]:
    """Fetch the conversation data from a shared ChatGPT conversation using Playwright."""
    page = None

    try:
        page = await browser_context.new_page()
            
        # Navigate to the URL and wait for the content to load
        await page.goto(url)
        # Wait for the conversation to be loaded
        await page.wait_for_selector('div.text-message')

        # Get the conversation title
        title_element = await page.query_selector('meta[property="og:title"]')
        title = await title_element.get_attribute('content') if title_element else "ChatGPT Conversation"

        # Initialize data structure
        models = set()
        data = {
            'conversation_id': url.split('/')[-1],
            'title': title,
            'version': '1.0',
            'participants': [
                {
                    'id': 'user',
                    'name': 'User'
                },
            ],
            'messages': []
        }
        
        # Extract all messages
        messages = data['messages']
        elements = await page.query_selector_all('div.text-message')
        
        for idx, element in enumerate(elements):
            # Get the role (user/assistant)
            role = await element.get_attribute('data-message-author-role')

            # Get the model name
            model_name = 'ChatGPT'
            if role == 'assistant':
                model_slug = await element.get_attribute('data-message-model-slug')
                if model_slug:
                    model_name = f'ChatGPT {model_slug}'
                    models.add(model_name)

            # Get the HTML content and convert to markdown
            html_content = await element.evaluate('el => el.innerHTML')
            content = markdownify(html_content, heading_style="ATX")
            
            messages.append({
                'msg_id': f"msg_{idx}",
                'sender': 'User' if role == 'user' else model_name,
                'content': content.strip(),
                'type': 'text'
            })
        
        for model in models:
            data['participants'].append({
                'id': model.lower().replace(' ', '_'),
                'name': model,
            })

        await page.close()
        return data
            
    except Exception as e:
        print(f"Error fetching conversation from {url}: {e}", file=sys.stderr)
        if page and not page.is_closed():
            await page.close()
        return None

def convert_to_markchat(data: Dict) -> str:
    """Convert parsed messages to MarkChat format with YAML frontmatter and Markdown content."""
    # Prepare the YAML frontmatter
    frontmatter = data.copy()
    messages = frontmatter.pop('messages')
    title = frontmatter.pop('title')
    
    # Convert frontmatter to YAML
    yaml_content = yaml.dump(frontmatter, allow_unicode=True, sort_keys=False, default_flow_style=False)
    
    # Build the markdown content
    markdown_lines = [
        f"# {title}",
        ""
    ]
    
    # Add each message
    for msg in messages:
        timestamp = msg.get('timestamp', None)
        sender = msg['sender']
        content = msg['content']
        
        # Format the message header with timestamp and sender
        head = sender
        if timestamp:
            head += f" [{timestamp}]"
        markdown_lines.append(f"**{head}**  ")
        markdown_lines.append("---  ")
        
        # Add the message content, ensuring proper line breaks
        content_lines = content.strip().split('\n')
        markdown_lines.extend(content_lines)
        markdown_lines.append("")  # Add an empty line after each message
    
    # Combine everything
    full_content = "---\n" + yaml_content + "---\n\n" + "\n".join(markdown_lines)
    return full_content

async def process_urls(urls: List[str], output_dir: Path, format_md: bool = False) -> None:
    """Process multiple URLs concurrently."""
    async with async_playwright() as p:
        # Launch single browser instance for headless operation
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context()
        
        try:
            # Ensure we're authenticated if needed
            if any('share' not in url for url in urls):
                if not await ensure_authenticated(context, p):
                    await browser.close()
                    sys.exit(1)
                print("Successfully logged in!")
            
            # Create output directory if it doesn't exist
            output_dir.mkdir(parents=True, exist_ok=True)
            
            # Process all URLs concurrently
            tasks = []
            for url in urls:
                task = fetch_chatgpt_conversation(url, context)
                tasks.append(task)
            
            # Wait for all tasks to complete
            results = await asyncio.gather(*tasks)
            
            # Process results and save files
            for data in results:
                if data:
                    # Generate filename from title
                    safe_title = "".join(c for c in data['title'] if c.isalnum() or c in (' ', '-', '_')).strip()
                    ext = '.md' if format_md else '.json'
                    output_file = output_dir / f"{safe_title}{ext}"
                    
                    try:
                        if format_md:
                            content = convert_to_markchat(data)
                            with open(output_file, 'w', encoding='utf-8') as f:
                                f.write(content)
                        else:
                            with open(output_file, 'w', encoding='utf-8') as f:
                                json.dump(data, f, ensure_ascii=False, indent=2)
                        print(f"Saved conversation to {output_file}")
                    except Exception as e:
                        print(f"Error saving file {output_file}: {e}", file=sys.stderr)
        
        finally:
            await browser.close()

async def main():
    parser = argparse.ArgumentParser(description='Convert ChatGPT conversations to JSON or MarkChat format')
    parser.add_argument('urls', nargs='*', help='URLs of the ChatGPT conversations')
    parser.add_argument('-o', '--output-dir', type=Path, default=Path.cwd()/'conversations',
                        help='Output directory (default: ./data)')
    parser.add_argument('-m', '--md', action='store_true',
                        help='Save conversations as Markdown files instead of JSON')
    
    args = parser.parse_args()

    if not args.urls:
        parser.print_help()
        return
    
    await process_urls(args.urls, args.output_dir, args.md)

if __name__ == '__main__':
    asyncio.run(main())