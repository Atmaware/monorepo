---
created: 2025-04-19T01:15:13.886Z
updated: 2025-04-19T01:15:13.882Z
assigned: ""
progress: 0
tags: []
---

# Implement high-level UX design

Use windsurf for reference.

Overall idea: aggregate your saved content all over the web and start scrolling over your own collection!

Three modes:
  - Scrolling: randomly scroll saved content cud by cud (according to some algorithms to suggest semantically related content in the next cud, e.g. nearest neighbor, graph walk)
  - Searching: content in the explorer are displayed in a similar way as in the search results of vscode - a list/tree/grid of entries; user can add conditions in the search field like sorting, grouping, labels, etc.  
    Chatting: use the same text field as in search UI. Use a button to switch between normal search and AI chat. How to display the previous messages if the text box is at the top? Perhaps automatically scroll down to show the current response to the query right below the text box, and the user can manually scroll up to view previous messages. Consider implementing multi-step thinking, c.f. Khoj.
  - Overview: display folder content, file content, search results, and AI response in a unified UI. The fundamental structure is a tree. It can be similar to the search results in vscode. For file content, it can be folded/unfolded at different nodes according to its syntactic/semantic structure. For search results, it can be folded/unfolded according to the user-specified grouping strategy (by default file path). For chat history, it can be folded/unfolded at 1) message level 2) auto-detected semantic chunks of messages 3) message branches (like in git). 

Components:
- side bar
  - a tab for random scrolling (name: Chew!)
  - tabs (can be grouped)
  - bookmarks (paths, saved input, etc.)
  - settings
- search bar (without entering anything in the search bar, the content in the explorer is equal to the search result of `*` (anything))
  - filters (persistent over multiple searches)
    - file path (similar to the path at the top of the editor; each node in the path can be expanded into a list of entries at that level)
    - other filters like `later than DATE`, `belongs to PLATFORM`
  - sort by (timestamp, name, etc.)
  - group by (path, label, etc.)
  - input field
    - hybrid search (full text and semantic)
    - AI query
- explorer (entries displayed in list/grid view; each entry can be a folder, a file, a block of content in a file, or a message in a conversation)
  - add button (add folder, platform, note, content block, etc., depending on the type of current path)
  - collapose/expand all

## Relations

- [add-quick-feedback-ui-button-message-box-ai-chat](add-quick-feedback-ui-button-message-box-ai-chat.md)
- [implement-hybrid-search](implement-hybrid-search.md)
- [upgrade-explorer-ui](upgrade-explorer-ui.md)
- [](.md)

## Comments

- date: 2025-04-18T13:29:29.947Z
  
