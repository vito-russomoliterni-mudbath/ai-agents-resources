---
name: show-links
description: Use when the user asks to search online, look up a topic on the web, research a library/tool/framework, find documentation, or investigate anything requiring web research. Triggers on phrases like "search for", "look up", "research", "find docs", or "check the web".
version: 1.0.0
---

# Show Links

Research topics by finding official documentation and reputable sources, then delivering direct links with recommendations.

**First, check for available MCP documentation servers** (e.g., context7). If one is available and responds, use it as the primary source — MCP servers fetch versioned, structured docs directly and are more reliable than web search. Confirm the documented version matches the user's local version (check package.json, Cargo.toml, requirements.txt, or equivalent). If no MCP documentation server is available or the query fails, fall back to web search.

**Supplement with web search** even when an MCP server responds, if the response needs more research — for example: the docs don't cover the specific API or flag the user is asking about, the version is mismatched and migration guidance is needed, the topic requires community context beyond reference docs (known bugs, workarounds, real-world usage), or the MCP result is too sparse to be actionable.

**When using web search**, look for official documentation sites — the project's own docs site, GitHub repo, or published API reference. Prioritize highly reputable sources in this order: official docs > official forums/repos > community-maintained docs > curated guides. Avoid generic blog posts or tutorials when official sources exist.

After gathering sources, dispatch a generic subagent to review the collected links. The reviewer evaluates each source for reputation and version relevance, returning a pass or stop. If the reviewer returns stop (with motivation and reasoning for each rejected source), refine the search (different query, different source type, or targeted version search) and re-run the review. Only return results to the user once the reviewer gives a pass. Include one sentence per source covering what it documents, how authoritative it is, and whether the version aligns.
