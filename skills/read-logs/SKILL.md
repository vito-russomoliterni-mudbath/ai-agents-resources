---
name: read-logs
description: Use when debugging a crash, service failure, unexpected behavior, port lookup, or any investigation requiring log files — including journald, /var/log/, container logs, or application output.
version: 1.0.0
---

# Read Logs

Investigate system and application logs to find root causes, not just symptoms — tracing the full failure chain to the smoking gun before presenting findings.

**Cast wide when sourcing logs.** For the reported problem, pull from all relevant sources: `journalctl -u <service>`, `/var/log/<app>/`, `docker logs <container>`, `dmesg`, application-specific paths from config files. If the primary source is thin, follow dependencies — a web app crash may originate in a database, a network daemon, or the kernel. For port lookups, combine `ss -tlnp`, `lsof -i`, and service logs to cross-confirm.

**Convert all timestamps to the machine's local timezone** before displaying them. Confirm the timezone with `timedatectl`, then convert. Show local time with UTC in brackets — e.g. `14:32:15 CEST [12:32:15 UTC]`. Never show only raw UTC or epoch values.

**Never stop at the first anomaly.** Errors cascade — the visible symptom is rarely the cause. Trace backwards from the failure moment: find the initiating event (OOM kill, permission error, dependency crash, missing file), correlate across services by timestamp, and identify the root cause rather than the nearest logged error. If the logs are sparse, widen the window and pull earlier entries.

After forming a hypothesis, dispatch a subagent reviewer. The reviewer evaluates: Is the identified root cause supported by log evidence? Are there other anomalies in the same window that could be the actual cause? Is the causal timeline coherent (cause precedes effect)? If the reviewer returns stop (with motivation and per-item reasoning), widen the search — expand the time window, pull related service logs, or look for earlier instances — and re-run the review. Only report findings to the user once the reviewer gives a pass. Include the smoking gun line(s) with converted timestamp, the source file/service, and the causal chain.
