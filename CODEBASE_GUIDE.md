# Ruminer Codebase Reading Guide

This guide provides a structured approach to understanding the Ruminer codebase, a complete open-source read-it-later solution with web, iOS, and Android clients.

## Project Overview

Ruminer is a monorepo containing multiple components:
- Web application (Next.js)
- API server (GraphQL)
- Database management
- Content fetching services
- Mobile applications (iOS and Android)
- Browser extensions

## Phase 1: Setup and Environment (Days 1-3)

### Day 1: Project Setup
1. Clone the repository
   ```bash
   git clone https://github.com/atmaware/ruminer
   cd ruminer
   ```

2. Start the development environment
   ```bash
   docker compose up
   ```

3. Access the web application at http://localhost:3000
   - Login with demo@ruminer.app / demo_password

### Day 2-3: Explore the Project Structure
1. Understand the monorepo organization
   - `/packages` - Core services and web app
   - `/android` - Android application
   - `/apple` - iOS application
   - `/docs` - Documentation

2. Familiarize yourself with the development workflow
   - Docker compose for local development
   - Database initialization
   - Service dependencies

## Phase 2: Database and API (Days 4-7)

### Day 4: Database Schema
1. Examine the database migrations
   - `/packages/db/migrations/*.sql` - SQL migration files
   - Understand the schema evolution

2. Study the Row Level Security implementation
   - How user permissions are enforced at the database level
   - Role-based access control

### Day 5-6: GraphQL API
1. Explore the GraphQL schema
   - `/packages/api/src/schema.ts` - Main schema definition
   - Understand the types, queries, and mutations

2. Study the resolvers and data sources
   - `/packages/api/src` - API implementation
   - How business logic is separated from data access

### Day 7: Content Fetching
1. Understand the content fetching service
   - `/packages/puppeteer-parse` - Web page parsing
   - `/packages/content-fetch` - Content fetching orchestration

2. Explore ElasticSearch integration
   - How article content is indexed and searched
   - `/packages/db/elastic_migrations` - ElasticSearch setup

## Phase 3: Web Application (Days 8-12)

### Day 8-9: Frontend Architecture
1. Study the Next.js application structure
   - `/packages/web` - Web application
   - Page routing and component organization

2. Understand the styling approach
   - Stitches for CSS-in-JS
   - Component styling patterns

### Day 10-11: Core Features
1. Examine the article reading experience
   - Article rendering and text processing
   - Reading progress tracking

2. Study the highlighting and annotation features
   - How highlights are created and stored
   - Note-taking functionality

### Day 12: State Management
1. Understand data fetching with SWR/React Query
   - API integration patterns
   - Client-side caching

2. Explore user authentication and session management
   - Login flow
   - Session persistence

## Phase 4: Mobile Applications (Days 13-17)

### Day 13-14: iOS Application
1. Study the iOS project structure
   - `/apple/Sources` - Swift source code
   - `/apple/RuminerKit` - Core functionality

2. Understand Swift GraphQL integration
   - How API queries are generated and executed
   - Data synchronization patterns

### Day 15-16: Android Application
1. Examine the Android project structure
   - `/android/app/src` - Kotlin/Java source code
   - Build configuration

2. Study Apollo GraphQL integration
   - How GraphQL is used on Android
   - State management

### Day 17: Shared Functionality
1. Understand cross-platform features
   - Offline support
   - Syncing mechanisms
   - Common UI patterns

## Phase 5: Microservices and Extensions (Days 18-21)

### Day 18-19: Microservices
1. Study the various microservices
   - `/packages/pdf-handler` - PDF processing
   - `/packages/rss-handler` - RSS feed handling
   - `/packages/inbound-email-handler` - Email processing
   - Other specialized services

2. Understand the queue management system
   - How tasks are distributed and processed
   - Error handling and retries

### Day 20-21: Browser Extensions
1. Examine the browser extension code
   - How content is saved from browsers
   - Cross-browser compatibility

2. Study the integration with other tools
   - Logseq plugin
   - Obsidian plugin

## Phase 6: Practical Implementation (Days 22-25)

### Day 22-23: Make a Small Change
1. Implement a simple feature or fix
   - Choose something manageable like:
     - Adding a new field to user preferences
     - Fixing a UI issue
     - Enhancing an existing feature

2. Test your changes locally
   - Verify functionality
   - Ensure no regressions

### Day 24-25: Review and Reflect
1. Document what you've learned
   - Create notes on key components
   - Diagram the system architecture

2. Identify areas for further study
   - Advanced features
   - Performance optimizations
   - Security considerations

## Key Files to Study

### Core Configuration
- `/docker-compose.yml` - Service configuration
- `/packages/web/package.json` - Web dependencies
- `/packages/api/package.json` - API dependencies

### Database
- `/packages/db/migrations` - Database schema evolution
- `/packages/db/elastic_migrations` - ElasticSearch configuration

### API
- `/packages/api/src/schema.ts` - GraphQL schema
- `/packages/api/src/resolvers` - Business logic
- `/packages/api/src/data_sources` - Data access

### Web Application
- `/packages/web/pages` - Next.js pages
- `/packages/web/components` - React components
- `/packages/web/styles` - UI styling

### Mobile
- `/apple/Sources` - iOS application code
- `/android/app/src` - Android application code

### Content Processing
- `/packages/puppeteer-parse` - Web content extraction
- `/packages/pdf-handler` - PDF processing
- `/packages/readabilityjs` - Text extraction

## Learning Tips

1. **Start with user flows**
   - Follow the code path of common user actions
   - Example: Saving an article → reading → highlighting

2. **Use Docker for quick testing**
   - The docker-compose setup makes it easy to run the entire stack

3. **Leverage GraphQL tools**
   - Use GraphQL playground to explore the API
   - Study how queries and mutations are structured

4. **Read code methodically**
   - Start with entry points and follow the execution flow
   - Use grep or code search to find usages of functions/components

5. **Join the Ruminer Discord community**
   - Connect with other developers
   - Ask questions when you get stuck

## Advanced Topics (After Initial Understanding)

1. **Authentication and Security**
   - Row Level Security implementation
   - User authentication flows
   - API security measures

2. **Performance Optimization**
   - Content fetching and processing
   - Database query optimization
   - Frontend rendering performance

3. **Offline Capabilities**
   - How data is synchronized
   - Conflict resolution strategies
   - Local storage mechanisms

4. **Integration Points**
   - Third-party service connections
   - Extension mechanisms
   - API client implementations

This guide provides a structured approach to understanding the Ruminer codebase. Take your time with each phase, and don't hesitate to revisit earlier sections as your understanding grows.
