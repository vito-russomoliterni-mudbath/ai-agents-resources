---
name: show-logs
description: Use when the user asks to debug a crash, investigate logs, find log files, determine why a service/process failed, or locate log commands. Triggers on phrases like "debug crash", "investigate logs", "check logs", "where are the logs", "why did service fail", or "log files for X".
version: 1.0.0
---

# Show Logs

Research log locations (file paths, journald units, container log commands) by finding official documentation and reputable sources, then deliver direct log paths/commands with recommendations.

**First, check for available MCP documentation servers** (e.g., context7). If one is available and responds, use it as the primary source — MCP servers fetch versioned, structured docs directly and are more reliable than web search. Confirm the documented version matches the user's local version (check package.json, Cargo.toml, requirements.txt, CLI --version output, OS release files, or equivalent). If no MCP documentation server is available or the query fails, fall back to web search.

**Supplement with web search** even when an MCP server responds, if the response needs more research — for example: the docs don't cover the specific log location or command the user is asking about, the version is mismatched and migration guidance is needed, the topic requires community context beyond reference docs (known bugs, workarounds, real-world log locations), or the MCP result is too sparse to be actionable.

**When using web search**, look for official documentation sites — the project's own docs site, GitHub repo, or published admin/reference guide. Prioritize highly reputable sources in this order: official docs > official forums/repos > community-maintained docs > curated guides. Avoid generic blog posts or tutorials when official sources exist.

After gathering sources, dispatch a generic subagent to review the collected log-location claims. The reviewer evaluates each source for reputation and version relevance, returning a pass or stop. If the reviewer returns stop (with motivation and reasoning for each rejected source), refine the search (different query, different source type, or targeted version search) and re-run the review. Only return results to the user once the reviewer gives a pass. Include one sentence per source covering what log it documents, how authoritative it is, and whether the version aligns.
