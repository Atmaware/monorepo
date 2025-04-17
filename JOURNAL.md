### 3 Mar 2025

- Asked Claude to organize my development ideas into README.md and DEVELOPMENT_PLAN.md
- Did extensive research to find the most suitable databse for ScrollSage. Candidates include Realm+PowerSync+MongoDB (PowerSync needs another server), Ditto+MongoDB (connector not free), Supabase, Couchbase Lite (bound with Couchbase Server), ObjectBox (sync not free), WatermelonDB, RxDB, and EdgeDB. Finally I chose RxDB for local storage and Supabase for cloud service. Reasons include:
  - Can be used in React Native
  - Simple setup of realtime syncing with cloud DB
  - Local-first & NoSQL (easy data access without Internet or even DB installation)
  - Local vector search (and full-text search with plugin)

### 4 Mar 2025

[DISCARDED]
Implemented the widget components:
  - ScrollSageWidget.tsx: The main widget component that registers with the Android home screen. It displays a minimalistic search bar in its collapsed state.
  - ScrollSageWidgetExpanded.tsx: Demonstrates the expanded UI when a user interacts with the widget. It includes:
    - An input field at the top with a check icon to submit
    - A row of action buttons (plus, microphone, web, magic pen, down arrow)
    - A scrollable area for search history
  - ExpandedMenu.tsx: A component that renders the expandable menus that appear when a user long-presses or swipes down on an action button. This follows the design requirement where buttons expand into menus with icons and labels.
  - MagicModeWidget.tsx: A variant of the widget with a "magical" style applied, as specified in the design document for when the user is in AI query mode.
  - widget-config.ts: Configuration file for the Android widget, defining its appearance, size options, and update frequency.
  - index.ts: A simple export file to make all widget components easily accessible.

Note that this implementation focuses solely on the UI aspect as requested, without the actual functionality. The next steps would be to connect these UI components to the actual functionality of the app, including:
- Handling user input and search queries
- Implementing the file upload/capture functionality
- Adding speech-to-text capabilities
- Implementing web search integration
- Adding AI revision and query features

## 13 Apr

Designed a sketch of app logo and used [Dzine](https://www.dzine.ai/canvas) to generate refined versions. Found a satisfactory version after many iterations.

## 14 Apr

Replaced "omnivore" with "ruminer" everywhere.
- snippets/rename_omnivore_to_ruminer.sh
- snippets/update_file_contents.sh

Set up GCP VM to deploy Ruminer.

Set up my domain name at ruminer.atmaware.com and Nginx reverse proxy (self-hosting/setup.sh).

## 15 Apr

Debugging docker image building. Finally able to login to "ruminer.atmaware.com" with the demo user name as well as signing up using my own email.

Finished `todos/01.setup-testing-vm.md`.

## 16 Apr

fix android login

[TODO]
Replacing logos with my newly created one.
