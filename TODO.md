## Do It Now

- [ ] Fix: images are not loaded in reader view
- [ ] Make a local dir which stores all saved content in open format (MD)
- [ ] Import local dirs like Screenshots and Obsidian Vault on Android
- [ ] Implement OCR for imported screenshots
- [ ] Build connections with {c}
    - [ ] Readwise
    - [ ] Obsidian
    - [ ] Github repo, e.g. MyVault (c.f. Note-Gen)
    - [ ] Raindrop
    - [ ] Keep
    - [ ] Browser (Firefox bookmarks API, Chrome bookmarks API) {c}
        - [ ] Use content-fetch to fetch all bookmarked pages
- [ ] Fix failed CI/CD on github
- [ ] Utilize late chunking in chonkie
- [ ] Update integration_plan.md
- [ ] Setup mail server
- [ ] Update logos
- [ ] Review starred github repos, convert them to TODO items and consider unstar to clean up
- [ ] Experiment with auto-tagging tools {c}
    - [ ] https://github.com/karakeep-app/karakeep
    - [ ] https://github.com/lucagrippa/obsidian-ai-tagger
    - [ ] https://github.com/PAIR-code/autonotes
    - [ ] https://github.com/Bistard/nota

## Later

- [ ] AI-guided onboarding configuration (connections with third parties, etc.)
- [ ] Implement hierarchical summarization with expand/collapse actions in reader
- [ ] How to bidirectionally sync with Notion, Obsidian, OneNote, etc?
- [ ] Consider introducing branching in AI chatting

## Integration Plan

- **Use Note-Gen as main frontend**
- **Use Karakeep as main backend**
- Use local file and content search from ripgrep-all/czkawka
- Use AI pipeline from txtai, haystack, langchain
- Use AI tool calling, PDF processing, (OCR?), audio transcription, payment integration, AWS boto3, twilio from Khoj
- Use microservices (PDF, EBook, RSS, emails, Pocket, Readwise, Discover, browser extension) from Omnivore
- Use android widget, sharing functionality, importing (onenote, keep, evernote) from Notesnook
- Use directory monitoring, open storage (md files), (widget, sharing) from OpenNote-Compose
- Use knowledge graph from graphbrain/Neurite
- Use Geldata/Supabase for cloud graph DB service and OAuth

### UI Design

- Search UI: morphic
- Sidebar: Memos?
- Thought process & tool using: Khoj & morphic

## Read Articles
- https://maartengr.github.io/BERTopic/getting_started/semisupervised/semisupervised.html {cm:2025-04-16}
- Comparing txtai with langchain, llamaindex: https://medium.com/neuml/vector-search-rag-landscape-a-review-with-txtai-a7f37ad0e187 {cm:2025-04-16}
- https://blog.omnivore.app/p/deploying-a-minimal-self-hosted-omnivore
- https://danielprindii.com/blog/read-it-later-alternatives-after-omnivore-shutting-down
- https://github.com/omnivore-app/omnivore/issues/4550
- https://vanderwalt.de/blog/ai-bookmark-organizer
- https://github.com/FullStackRetrieval-com/RetrievalTutorials/blob/main/tutorials/LevelsOfTextSplitting/5_Levels_Of_Text_Splitting.ipynb
- https://docs.unstructured.io/open-source/core-functionality/partitioning
- https://docs.unstructured.io/open-source/core-functionality/chunking
- https://github.com/neuml/txtai/blob/master/examples/58_Advanced_RAG_with_graph_path_traversal.ipynb
- https://github.com/neuml/txtai/blob/master/examples/09_Building_abstractive_text_summaries.ipynb
- https://github.com/neuml/txtai/blob/master/examples/13_Similarity_search_with_images.ipynb
- https://github.com/neuml/txtai/blob/master/examples/38_Introducing_the_Semantic_Graph.ipynb
- https://github.com/neuml/txtai/blob/master/examples/53_Integrate_LLM_Frameworks.ipynb
- https://github.com/neuml/txtai/blob/master/examples/57_Build_knowledge_graphs_with_LLM_driven_entity_extraction.ipynb

## Ideas to Implement

### High Level Ideas

- The user only has to save content. Everything else is automated by AI but user has full control of each step.

Major Steps:
- Centralize: connect with folders, platforms and collect saved content
- Ingest: clean and chunk content into cuds (atomic items)
- Organize: build an index tree of cuds and generate embeddings, tags, links using AI
- Search: craft a unified search UI and API for text & semantic & structured search

Questions:
- How to best integrate the knowledge in personally collected content and the inherent knowledge in an LLM?
- Ask four questions to associate items: Where does this come from? What does this lead to? What is similar to? What is this opposite to? (Zettel Compass)

### Technical Ideas

- Everything is a node. Nodes can have attributes and be infinitely nested. Nodes can be connected and embedded in text. (Tana)
- Supertag: defines structure and behavior of nodes; can contain fields and inherit from another supertag; can be queried and filtered by fields; fields are embedded in the YAML frontmatter; a date is a node. (Tana)

## Similar Products

- [Note-Gen](https://github.com/note-gen/note-gen)
- [Karakeep](https://github.com/karakeep-app/karakeep)
- [Omnivore](https://github.com/omnivore-app/omnivore)
- [Raindrop](https://github.com/raindropio/app)
- [Memos](https://github.com/usememos/memos)
- [Shiori](https://github.com/go-shiori/shiori)
- [Linkwarden](https://github.com/linkwarden/linkwarden)
- [Khoj](https://github.com/khoj-ai/khoj)
- [Notesnook](https://github.com/notesnook/notesnook)
- [Logseq](https://github.com/logseq/logseq)
- [curio](https://github.com/skyline-apps/curio)
- [infoflow](https://www.infoflow.app/en)
- [Remnote](https://www.remnote.com/)
- [mem.ai](https://mem.ai)
- [Memowise](https://memowise.ink/)
- [Reflect](https://reflect.app)
- [Mymemo](https://mymemo.ai)
- [Coral AI]
- Readwise
- MyMind
- get笔记
- 纳米AI
- 腾讯ima
- Flomo
- Tana
- Fabric
- Napkin
- Wallabag
- Pincone