---
name: showlinks
description: Use when the user asks to search online, look up a topic on the web, research a library/tool/framework, find documentation, or investigate anything requiring web research. Triggers on phrases like "search for", "look up", "research", "find docs", or "check the web".
version: 1.0.0
---

# Showlinks

Research topics by finding official documentation and reputable sources, then delivering direct links with recommendations. First, search for official documentation sites — the project's own docs site, GitHub repo, or published API reference — and confirm the documented version matches the user's local version (check package.json, Cargo.toml, requirements.txt, or equivalent). Prioritize highly reputable sources in this order: official docs > official forums/repos > community-maintained docs > curated guides. Avoid generic blog posts or tutorials when official sources exist.

After gathering sources, dispatch a generic subagent to review the collected links. The reviewer evaluates each source for reputation and version relevance, returning a pass or stop. If the reviewer returns stop (with motivation and reasoning for each rejected source), refine the search (different query, different source type, or targeted version search) and re-run the review. Only return results to the user once the reviewer gives a pass. Include one sentence per source covering what it documents, how authoritative it is, and whether the version aligns.
