# Ruminer

[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/atmaware/ruminer/run-tests.yaml?branch=main)](https://github.com/atmaware/ruminer/actions/workflows/run-tests.yaml)
[![Discord](https://img.shields.io/discord/844965259462311966?label=Join%20our%20Discord)](https://discord.gg/h2z5rppzz9)
[![Mastodon Follow](https://img.shields.io/mastodon/follow/109458738600914558?domain=https%3A%2F%2Fpkm.social)](https://pkm.social/@ruminer)
[![Twitter Follow](https://img.shields.io/twitter/follow/ruminerapp)](https://twitter.com/RuminerApp)
![GitHub](https://img.shields.io/github/license/atmaware/ruminer)

<img align="right" src="https://avatars.githubusercontent.com/u/70113176?s=400&u=506b21d9f019f3160963c010ef363667fb24c7c9&v=4" height="150px" alt="Ruminer Logo">

[Ruminer](https://ruminer.app) is a complete, open source read-it-later solution for people who like text.

Aggregate your saved content from all over the web! Start scrolling over your own collection! Search them, ask AI about them, and receive weekly summaries by email!

Extra features:
- auto create notes from screenshots via OCR
- quick notes via mobile app widgets
- save content by sharing from other apps

We built Ruminer because we love reading and we want it to be more social. Join us!

- Highlighting, notes, search, and sharing
- Full keyboard navigation
- Automatically saves your place in long articles
- Add newsletter articles via email (with substack support!)
- PDF support
- [Web app](https://ruminer.app/) written in Node.js and TypeScript
- [Native iOS app](https://ruminer.app/install/ios) ([source](https://github.com/atmaware/ruminer/tree/main/apple))
- [Android app](https://ruminer.app/install/android) ([source](https://github.com/atmaware/ruminer/tree/main/android/Ruminer))
- Progressive web app for Android users
- Browser extensions for [Chrome](https://ruminer.app/install/chrome), [Safari](https://ruminer.app/install/safari), [Firefox](https://ruminer.app/install/firefox), and [Edge](https://ruminer.app/install/edge)
- Labels (aka tagging)
- Offline support
- Text to speech (iOS only)
- [Logseq](https://logseq.com/) support via our [Logseq Plugin](https://github.com/atmaware/logseq-ruminer)
- [Obsidian](https://obsidian.md/) support via our [Obsidian Plugin](https://github.com/atmaware/obsidian-ruminer)

Every single part is fully open source! Fork it, extend it, or deploy it to your own server.

A guide for running a self hosted server can be found [here](./self-hosting/GUIDE.md)

<img width="981" alt="web-screenshot-listview" src="https://github.com/atmaware/ruminer/assets/75189/df7c797a-4255-42f4-a686-ad94866cb580">

## Join us on Discord! :speech_balloon:

We're building our community on Discord. [Join us!](https://discord.gg/h2z5rppzz9)

Read more about Ruminer on our blog. <https://blog.ruminer.app/p/getting-started-with-ruminer>

## Shoutouts :tada:

Ruminer takes advantage of some great open source software:

- [TypeScript](https://www.typescriptlang.org/) - Most of our backend and frontend are written in TypeScript.
- [Next.js](https://nextjs.org/) - Our frontend is a Next.JS app and is hosted on [Vercel](https://vercel.com/).
- [SWR](https://swr.vercel.app/) - We do all our data fetching on the web using SWR.
- [Stitches](https://stitches.dev/) - We use Stitches on the frontend to style our components.
- [Mozilla Readability](https://github.com/mozilla/readability) - We use Mozilla's Readability library to make pages easier to read.
- [Swift GraphQL](https://www.swift-graphql.com/) - We generate our GraphQL queries on iOS using Swift GraphQL.
- [Apollo GraphQL](https://www.apollographql.com/) - We generate our GraphQL queries on Android using Apollo GraphQL.
- [Radix](https://www.radix-ui.com/) - We use Radix UI's components on our frontend.
- [PDF.js](https://github.com/mozilla/pdf.js) - PDF.js is used to have open source pdf functionality. 
- And many more awesome libraries, just checkout our package files to see what we are using.

## Importing Libraries

Check out our [docs](https://docs.ruminer.app/using/importing.html) for information on importing your data from other apps.

## How to setup local development :computer:

The easiest way to get started with local development is to use `docker compose up`. This will start a postgres container, our web frontend, an API server, and our content fetching microservice.

### Requirements for development

Ruminer is written in TypeScript and JavaScript.

- [Node.js](https://nodejs.org/) (v18.16) and [Yarn](https://classic.yarnpkg.com/lang/en/) -- Versions are managed by [Volta](https://docs.volta.sh/guide/getting-started).
- [Chromium](https://www.chromium.org/chromium-projects/) -- See below for installation info.

### Running the web and API services

#### 1. Start docker compose

```bash
git clone https://github.com/atmaware/ruminer
cd ruminer
docker compose up
```

This will start postgres, initialize the database, and start the web and api services.

#### 2. Open the browser

Open <http://localhost:3000> and confirm Ruminer is running

#### 3. Login with the test account

During database setup docker compose creates an account `demo@ruminer.app`, password: `demo_password`.

Go to <http://localhost:3000/> in your browser and choose `Continue with Email` to login.

### Frontend Development

If you want to work on just the frontend of Ruminer you can run the backend services
with docker compose and the frontend locally:

```bash
docker compose up api content-fetch
cd packages/web
cp .env.template .env.local
yarn dev
```

You will need to configure some values in the new `.env.local` file. These are
the values for running the `web` service directly on your host machine and
running `api` and `content-fetch` within docker:

```sh
NEXT_PUBLIC_BASE_URL=http://localhost:3000
NEXT_PUBLIC_HIGHLIGHTS_BASE_URL=http://localhost:3000
NEXT_PUBLIC_LOCAL_BASE_URL=http://localhost:3000
NEXT_PUBLIC_SERVER_BASE_URL=http://localhost:4000
NEXT_PUBLIC_LOCAL_SERVER_BASE_URL=http://localhost:4000
```

### Running the puppeteer-parse service outside of Docker

To save pages you need to run the `puppeteer-parse` service.

#### 1. Install and configure Chromium

```bash
brew install chromium --no-quarantine
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export CHROMIUM_PATH=`which chromium`
```

#### 2. Navigate to the service directory, setup your env file, and install dependencies

```bash
cd packages/puppeteer-parse
cp .env.example .env
yarn
```

#### 3. Start the service

```bash
yarn start
```

This will start the puppeteer-parse service on port 9090.

In your browser go to <http://localhost:3000/home>, click the `Add Link` button,
and enter a URL such as `https://blog.ruminer.app/p/getting-started-with-ruminer`.

You should see a Chromium window open and navigate to your link. When the service
is done fetching your content you will see it in your library.

## How to deploy to your own server

A guide for running a self hosted server can be found [here](./self-hosting/GUIDE.md)

## License

Ruminer and our extensions to Readability.js are under the AGPL-3.0 license.
