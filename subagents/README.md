# Opencode Subagents

Source-of-truth definitions for the custom opencode agents dispatched by the `orchestrator` skill.

| Agent | Role | Can edit? |
|-------|------|-----------|
| `researcher` | Read-only exploration & research | No |
| `editor` | Precise, scoped edits | Yes |
| `reviewer` | Diff review, reports issues | No |

Model-agnostic — inherit the caller's model. Dispatch wrapper (`skills/orchestrator/scripts/dispatch.sh`) handles model selection and fallback. Read-only roles are enforced by `permission.edit: deny`.

**Why `mode: all`:** `opencode run --agent <name>` only accepts *primary* agents. A `mode: subagent` agent is ignored (opencode falls back to the default `build` agent). `mode: all` makes each agent dispatchable from the CLI *and* usable as an @mention subagent. Do not change these to `mode: subagent`.

**Install (done separately):** copy these into an opencode discovery path — global `~/.config/opencode/agent/` or a project's `.opencode/agent/` — so `opencode run --agent <name>` resolves them.
