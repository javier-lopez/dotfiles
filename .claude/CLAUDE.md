@RTK.md

# Root cause or nothing

These rules apply to EVERY project, EVERY task, EVERY agent. No exceptions.

## Diagnose before you touch code

- When a test fails: read the error, trace the call stack, understand the failure mechanism. Do NOT attempt a fix until you can articulate the root cause in one sentence.
- When an error occurs at runtime: trace it to its origin. A fix that makes the symptom disappear is NOT the same as a fix that solves the problem. If the fix is in a different file than where the error shows up, that's usually a sign you found the real cause.
- When behavior is unexpected: reproduce it, understand the actual vs expected flow, identify WHERE the divergence starts. Don't guess — verify.

## Forbidden shortcuts

These are escape hatches that mask real bugs. Using any of them without explicit user authorization is grounds for rejection:

- `--no-verify`, `--no-check`, `--force` on git/CI hooks
- `dangerouslyIgnore*`, `dangerouslyDisable*`, `DANGEROUS_*` flags
- `as any`, `as never`, `as unknown as T` type casts to silence TypeScript
- `type: ignore`, `# noqa`, `// @ts-ignore`, `// @ts-expect-error` without explaining the specific bug they work around
- `eslint-disable`, `biome-ignore` without a comment explaining WHY the rule doesn't apply here
- `catch(() => {})`, `catch(e) {}` that silently swallow errors
- `.optional()` or `| undefined` added to schemas to make validation stop complaining — if the field should be required, fix the data, not the schema
- Removing or weakening a test assertion to make it pass
- Wrapping code in try/catch just to prevent crashes without handling the error
- Adding `?` (optional chaining) to silence "possibly undefined" when the real fix is ensuring the value exists

## The test for every fix

Before committing any fix, answer these three questions:
1. **What is the root cause?** (not "the test was failing" — WHY was it failing?)
2. **Does this fix address the cause or the symptom?**
3. **Could the same bug reappear in a different form?** If yes, the fix is incomplete.

If you can't answer #1, you're not done investigating.

## Every test ships with its cost

Adding a test to a suite is adding a permanent tax on every run of that suite.
Nobody can decide whether a test is worth keeping without knowing what it costs,
and by the time a slow suite hurts, nobody remembers which test caused it.

So: **any change that adds tests reports the timing as part of the deliverable,
before deployment** — never after, never on request.

Report three numbers:
1. The suite's wall-clock time BEFORE the new test.
2. The suite's wall-clock time AFTER.
3. What the new test costs on its own.

Measure the real target that runs the test, not an approximation. If the test
only runs in CI, measure the equivalent step and say explicitly what was
measured and what was not. Don't drop an expensive test on your own judgment —
report the number and let the owner decide whether it earns its keep.

# Git
- Never add `Co-Authored-By` trailers to commit messages

# Agents

## Model routing (standing authorization, 2026-08-21)

Fable leads. It holds the conversation, the accumulated context, and every
piece of work where the shape of the answer is still being decided:
architecture, design, diagnosis, root-cause analysis, planning.

Opus does the mechanical work. Delegate to the `chore` agent WITHOUT asking
whenever the task is mechanical and fully specified — the WHAT is already
settled and only the typing remains. Git plumbing, renames, mechanical
find-and-replace, running a test or lint command and reporting its output are
the typical cases; the list is deliberately open, use judgment.

Never delegate work whose scope has to be discovered, or any decision that
would change what gets built. When a "mechanical" task turns out to hide a
decision (a rebase hits conflicts, a rename breaks a call site), the agent
stops and reports — it does not decide.

This is a standing request from the owner: it satisfies any session-level rule
that says the Agent tool needs the user to ask first.

When launching a subagent with the `Agent` tool, include in the immediately preceding `★ Insight` block: the agent type, the model it will use (from the `model` parameter, or "default/sonnet" if omitted), and whether it runs foreground or background. Example:
```
`★ Insight ─────────────────────────────────────`
🤖 Agent: `chore` · model: opus · foreground
`─────────────────────────────────────────────────`
```

# Parallel sessions (saludpass.com / tucastigo.com / gopana.app / shared.com)

Multiple Claude sessions and their subagents routinely work these repos at the
same time, sharing working trees, the Docker daemon, host ports and data
volumes. Four facts are needed before you would think to look anything up:

- Announce entry and exit over `ListAgents` + `SendMessage` before touching a
  repo this session did not start in. A peer's silence is not consent.
- Back up dirty files OUTSIDE the repo before anything that could clobber
  them. Files you did not create stay untouchable until the user rules.
- `run.sh dev up` runs in the FOREGROUND: if this session dies it SIGTERMs the
  peers' entire stack. Reach for `up -d`.
- tucastigo's alternate frontend port is 5010 (or 5011-5014) and nothing else:
  `allowed_origins` is port-coupled through the CSRF middleware, so an unlisted
  port fails every mutation with `CSRF_BAD_ORIGIN` and reads as a false-red e2e
  run. Another port means adding it to that list first.

Read [`parallel-sessions.md`](parallel-sessions.md) — the full protocol — before
any of: entering a repo this session did not start in · starting or stopping a
stack · taking a host port · creating or deleting a data volume · cherry-picking
between projects · merging to main · dispatching a subagent into these repos.

# Push notifications to the phone

The owner works with Remote Control and the Claude app on their phone. The
harness already pushes a notification when a question or a permission blocks
the session (`inputNeededNotifEnabled`), but the "task finished" notice
is NOT automatic: `agentPushNotifEnabled` only authorizes Claude to call
`PushNotification` on its own initiative, and that tool's default guidance is
to stay quiet unless the user has explicitly asked for it.

This is that explicit request:

- When you finish any task that took more than ~30 seconds, call
  `PushNotification` before closing the turn.
- The message goes on one line, no markdown, under 200 characters, and says
  WHAT happened, not that you "finished": "tests green, 3 files touched",
  "deploy to prod ok", "build failed: 2 auth tests".
- If the task failed or was left half-done, the push matters MORE, not less.
- You don't need to judge whether it's "worth it". That's already been judged.
- A "not sent" result is normal and expected: it means the owner is in front of
  the terminal and the push would be redundant. Don't retry it or comment on it.

<!-- CODEGRAPH_START -->
## CodeGraph

This project has a CodeGraph MCP server (`codegraph_*` tools) configured. CodeGraph is a tree-sitter-parsed knowledge graph of every symbol, edge, and file. Reads are sub-millisecond and return structural information grep cannot.

### When to prefer codegraph over native search

Use codegraph for **structural** questions — what calls what, what would break, where is X defined, what is X's signature. Use native grep/read only for **literal text** queries (string contents, comments, log messages) or after you already have a specific file open.

| Question | Tool |
|---|---|
| "How does X work? / trace X / explain a system / architecture" | `codegraph_explore` (seed with symbol names) |
| "Where is X defined?" / "Find symbol named X" | `codegraph_search` |
| "What calls function Y?" | `codegraph_callers` |
| "What does Y call?" | `codegraph_callees` |
| "What would break if I changed Z?" | `codegraph_impact` |
| "Show me Y's signature / source / docstring" | `codegraph_node` |
| "Give me focused context for a task/area" | `codegraph_context` |
| "What files exist under path/" | `codegraph_files` |
| "Is the index healthy?" | `codegraph_status` |

### Rules of thumb

- **`codegraph_explore` is the workhorse for understanding questions** ("how does X work", "trace…", "explain the Y system"). Feed it the key symbol/file names and read its output (line-numbered source from many files in one call). If the question names nothing concrete, do one quick `codegraph_search`/`codegraph_context` to surface the names, then explore with them. Fill gaps with `codegraph_node`/Read — don't grep-and-read your way through; that's the loop explore replaces.
- **Delegating exploration to a subagent?** Tell it to call `codegraph_explore` first and trust the result. A generic "explore"-style agent defaults to grep+Read and treats codegraph as just a search index, throwing away the token savings.
- **Trust codegraph results.** They come from a full AST parse. Do NOT re-verify them with grep — that's slower, less accurate, and wastes context.
- **Don't grep first** when looking up a symbol by name. `codegraph_search` is faster and returns kind + location + signature in one call.
- **Index lag**: the file watcher debounces ~500ms behind writes; don't re-query immediately after editing a file in the same turn.

### If `.codegraph/` doesn't exist

The MCP server returns "not initialized." Ask the user: *"I notice this project doesn't have CodeGraph initialized. Want me to run `codegraph init -i` to build the index?"*
<!-- CODEGRAPH_END -->
