#!/usr/bin/env node

/**
 * Ruminer Local Export
 * 
 * This script exports all user-saved content from Ruminer to a local folder in markdown format.
 * It can be run manually or scheduled to run periodically to keep the local folder in sync.
 * 
 * Usage:
 *   node local-export.js --token=YOUR_API_TOKEN --output=./export-folder
 */

const fs = require('fs');
const path = require('path');
const axios = require('axios');
const { execSync } = require('child_process');
const TurndownService = require('turndown');
const cron = require('node-cron');
const yargs = require('yargs/yargs');
const { hideBin } = require('yargs/helpers');

// Parse command line arguments
const argv = yargs(hideBin(process.argv))
  .option('token', {
    alias: 't',
    type: 'string',
    description: 'Your Ruminer API token'
  })
  .option('output', {
    alias: 'o',
    type: 'string',
    default: './ruminer-export',
    description: 'Output directory for exported content'
  })
  .option('schedule', {
    alias: 's',
    type: 'string',
    description: 'Cron schedule for automatic exports (e.g., "0 * * * *" for hourly)'
  })
  .option('baseUrl', {
    type: 'string',
    default: 'https://ruminer.app',
    description: 'Base URL for the Ruminer API'
  })
  .help()
  .argv;

// Initialize HTML to Markdown converter
const turndownService = new TurndownService({
  headingStyle: 'atx',
  hr: '---',
  bulletListMarker: '-',
  codeBlockStyle: 'fenced'
});

// Add support for highlighting
turndownService.addRule('highlight', {
  filter: ['mark', 'span.highlight'],
  replacement: function(content) {
    return `==${content}==`;
  }
});

// GraphQL query to fetch all items
const ITEMS_QUERY = `
query GetAllItems($after: Int, $first: Int) {
  search(after: $after, first: $first, query: "in:all") {
    edges {
      node {
        id
        slug
        title
        description
        author
        originalArticleUrl
        isArchived
        readingProgressPercent
        image
        labels {
          name
        }
        savedAt
        updatedAt
        publishedAt
        content
        highlights {
          id
          type
          quote
          annotation
          labels {
            name
          }
        }
      }
    }
    pageInfo {
      hasNextPage
      endCursor
    }
  }
}
`;

// Function to ensure directory exists
function ensureDirectoryExists(dirPath) {
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
  }
}

// Function to sanitize filenames
function sanitizeFilename(filename) {
  return filename.replace(/[/\\?%*:|"<>]/g, '-');
}

// Function to format date for filenames
function formatDate(dateString) {
  const date = new Date(dateString);
  return date.toISOString().split('T')[0];
}

// Function to create frontmatter for markdown files
function createFrontmatter(item) {
  const labels = item.labels?.map(label => label.name) || [];
  
  return `---
title: "${item.title?.replace(/"/g, '\\"') || 'Untitled'}"
url: ${item.originalArticleUrl || ''}
author: ${item.author || ''}
date: ${item.publishedAt || item.savedAt || new Date().toISOString()}
tags: [${labels.join(', ')}]
state: ${item.isArchived ? 'archived' : 'active'}
progress: ${item.readingProgressPercent || 0}
ruminer_id: ${item.id}
ruminer_slug: ${item.slug}
---

`;
}

// Function to format highlights as markdown
function formatHighlights(highlights) {
  if (!highlights || highlights.length === 0) {
    return '';
  }

  let markdown = '## Highlights\n\n';
  
  highlights.forEach(highlight => {
    if (highlight.type === 'HIGHLIGHT' && highlight.quote) {
      const quote = highlight.quote.replace(/^(?=\n)$|^\s*?\n/gm, '> ');
      const labels = highlight.labels?.map(label => `#${label.name}`).join(' ') || '';
      const note = highlight.annotation || '';
      
      markdown += `> ${quote}\n\n`;
      
      if (labels) {
        markdown += `${labels}\n\n`;
      }
      
      if (note) {
        markdown += `Note: ${note}\n\n`;
      }
    }
  });
  
  return markdown;
}

// Function to export a single item
async function exportItem(item, outputDir) {
  try {
    // Create sanitized filename with date prefix for sorting
    const datePrefix = formatDate(item.savedAt || item.publishedAt || new Date().toISOString());
    const sanitizedTitle = sanitizeFilename(item.title || 'Untitled');
    const filename = `${datePrefix}-${sanitizedTitle}.md`;
    const filePath = path.join(outputDir, filename);
    
    // Convert HTML content to markdown
    let markdown = createFrontmatter(item);
    
    if (item.content) {
      const contentMarkdown = turndownService.turndown(item.content);
      markdown += contentMarkdown + '\n\n';
    }
    
    // Add highlights section if there are highlights
    if (item.highlights && item.highlights.length > 0) {
      markdown += formatHighlights(item.highlights);
    }
    
    // Write to file
    fs.writeFileSync(filePath, markdown);
    console.log(`Exported: ${filename}`);
    
    return filePath;
  } catch (error) {
    console.error(`Error exporting item ${item.title}:`, error.message);
    return null;
  }
}

// Main function to export all items
async function exportAllItems(token, outputDir, baseUrl) {
  try {
    console.log(`Starting export to ${outputDir}`);
    ensureDirectoryExists(outputDir);
    
    // Create index file
    const indexPath = path.join(outputDir, 'index.md');
    let indexContent = `# Ruminer Export\n\nExported on: ${new Date().toISOString()}\n\n## Articles\n\n`;
    
    const exportedFiles = [];
    let hasNext = true;
    let cursor = 0;
    const batchSize = 20;
    
    while (hasNext) {
      console.log(`Fetching batch starting at cursor ${cursor}`);
      
      const response = await axios.post(
        `${baseUrl}/api/graphql`,
        {
          query: ITEMS_QUERY,
          variables: {
            after: cursor,
            first: batchSize
          }
        },
        {
          headers: {
            'Content-Type': 'application/json',
            'Ruminer-Authorization': token
          }
        }
      );
      
      const data = response.data.data;
      
      if (!data || !data.search || !data.search.edges) {
        console.error('Invalid response from API:', response.data);
        break;
      }
      
      const items = data.search.edges.map(edge => edge.node);
      
      if (items.length === 0) {
        break;
      }
      
      // Export each item
      for (const item of items) {
        const filePath = await exportItem(item, outputDir);
        if (filePath) {
          const relativePath = path.relative(outputDir, filePath);
          exportedFiles.push({
            title: item.title || 'Untitled',
            path: relativePath,
            date: item.savedAt || item.publishedAt,
            labels: item.labels?.map(label => label.name) || []
          });
        }
      }
      
      // Update cursor for next batch
      cursor = data.search.pageInfo.endCursor 
        ? parseInt(data.search.pageInfo.endCursor) 
        : 0;
      hasNext = data.search.pageInfo.hasNextPage;
    }
    
    // Sort exported files by date (newest first)
    exportedFiles.sort((a, b) => new Date(b.date) - new Date(a.date));
    
    // Add entries to index file
    exportedFiles.forEach(file => {
      const labels = file.labels.length > 0 
        ? ` (${file.labels.map(l => `#${l}`).join(' ')})` 
        : '';
      indexContent += `- [${file.title}](${file.path})${labels}\n`;
    });
    
    // Write index file
    fs.writeFileSync(indexPath, indexContent);
    console.log(`Created index file at ${indexPath}`);
    
    console.log(`Export completed. ${exportedFiles.length} items exported to ${outputDir}`);
  } catch (error) {
    console.error('Export failed:', error.message);
    if (error.response) {
      console.error('API response:', error.response.data);
    }
  }
}

// Function to run the export
async function runExport() {
  const { token, output, baseUrl } = argv;
  
  if (!token) {
    console.error('Error: API token is required. Use --token=YOUR_API_TOKEN');
    process.exit(1);
  }
  
  await exportAllItems(token, output, baseUrl);
}

// Main execution
if (argv.schedule) {
  console.log(`Scheduled export with cron pattern: ${argv.schedule}`);
  cron.schedule(argv.schedule, runExport);
} else {
  runExport();
}
