# Design: show-logs Skill

## Goal

Create a new reusable skill, `show-logs`, that nudges an agent toward official, version-aware documentation when the user needs to find log files or commands for debugging.

## Scope

- Single-file skill: `skills/show-logs/SKILL.md`.
- Mirrors the structure and workflow of the existing `show-links` skill.
- Output is log locations and commands, not a full debugging playbook.

## Audience

- Dev agents debugging application bugs.
- Sysadmin-style agents investigating software malfunction.

## Trigger Conditions

The skill activates on phrases such as:

- "debug crash"
- "investigate logs"
- "check logs"
- "where are the logs"
- "why did service fail"
- "log files for X"

## Workflow

1. **Prefer MCP documentation servers** (e.g., `context7`). If one is available and responds, use it as the primary source. MCP servers fetch versioned, structured docs directly and are more reliable than web search.
2. **Confirm version alignment.** Check local version indicators such as `package.json`, `Cargo.toml`, `requirements.txt`, CLI `--version` output, or OS release files. Match the documented version to the local version.
3. **Fall back to web search** when no MCP server is available, the query fails, or the MCP response is sparse.
4. **Supplement with web search** when:
   - the MCP docs do not cover the specific log location or command,
   - the version is mismatched and migration guidance is needed,
   - the topic needs community context (known bugs, workarounds, real-world log locations).
5. **Prioritize official sources** when searching: official docs > official forums/repos > community-maintained docs > curated guides. Avoid generic blog posts or tutorials when official sources exist.
6. **Review sources with a subagent.** Dispatch a generic reviewer subagent to evaluate each collected source for reputation and version relevance. The reviewer returns `pass` or `stop` with reasoning for rejected sources.
7. **Refine if rejected.** If the reviewer returns `stop`, refine the search (different query, source type, or targeted version search) and re-run the review.
8. **Return results only on pass.** Present one sentence per source describing what log it documents, how authoritative it is, and whether the version aligns.

## File Structure

```text
skills/
└── show-logs/
    └── SKILL.md
```

## Content Mapping from show-links

| show-links concept | show-logs translation |
|---|---|
| URLs / links | Log file paths, journald units, container log commands |
| Web research | Log-location research |
| Documentation servers | Same MCP documentation servers (e.g., context7) |
| Source reputation | Source reputation + version relevance |
| Subagent link review | Subagent log-location claim review |

## Success Criteria

- The skill is a single `SKILL.md` under `skills/show-logs/`.
- It keeps the MCP-first, official-docs-first workflow from `show-links`.
- The translation from web links to log locations is logical and complete.
- It triggers on debugging and log-investigation phrases.
