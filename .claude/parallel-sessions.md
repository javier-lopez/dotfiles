# Parallel sessions (saludpass.com / tucastigo.com / gopana.app / shared.com)

The four facts needed before you would think to look here live in `CLAUDE.md`.
This file is the rest of the protocol, and cross-project cherry-picks and
backports are normal. Every session AND every dispatched subagent follows it.

## Before touching a repo your session didn't start in

- Run `ListAgents` and coordinate via `SendMessage` with any session working
  there. Announce entry (branch, what you'll run, which ports) and exit.
  A peer's silence is not consent for destructive steps — when a peer is
  active in the repo, wait for their ACK.

## Working tree

- The tree is shared: a checkout/reset by one session destroys another's
  uncommitted work. Before yielding a repo, commit your work or back it up
  outside the repo. If you find dirty files you didn't create, treat them as
  untouchable — ask before any operation that would clobber them.
- Leave the repo as you found it: HEAD back on the branch that was checked
  out, clean tree, stacks down — and say so explicitly when announcing exit.
- Reference your own commits by SHA (not branch) when merging/squashing —
  immune to peer branch surgery.
- shared.com extra: its deploy rsyncs the WORKING TREE, not HEAD. A dirty
  tree does not ship by itself — deploy-site.sh refuses unless `--dirty` is
  passed. The trap is that `--dirty` is ONE flag forgiving TWO repos (the
  site checkout AND shared.com), so passing it for one repo's dirt silently
  ships the other's. Before using it, check `git status` in BOTH.

## Stacks, ports, volumes

- One stack per compose project — two sessions cannot run the same project's
  stack; negotiate turns. Always `./scripts/run.sh`, never raw compose
  (orphan `*com-*` stacks AND data volumes exist as traps).
- Port contention: whoever arrives second moves. Known knobs: tucastigo db →
  `TUCASTIGO_DB_PORT=5433`, saludpass db → `SALUDPASS_DB_PORT`. Announce the
  ports you take.
- tucastigo alternate frontend port MUST be 5010 (or 5011-5014), not any
  free port: `allowed_origins` in config/dev/config.yaml is port-coupled via
  the CSRF middleware (app/middleware/csrf_origin.py rejects mutations from
  unlisted Origins → every POST fails with CSRF_BAD_ORIGIN, reading as a
  false-red e2e run). Need another port? Add it to that list first.
- After a stack down/up, docker recreates the network with a new ID: any
  container still bound to the old network fails with "network ... not
  found" (exit 128). That's a zombie, not stack corruption — `docker rm
  <container>` and let compose recreate it. Watch profile-gated containers
  (e.g. tucastigo's scheduler, only started by certain targets): they age
  unnoticed and surface exactly when a peer's down/up cycled the network.
- Never delete/recreate a data volume while another session may be mid-run;
  confirm first, and verify the volume name against the compose project name
  before any `docker volume rm`.
- Assume DB state is whatever the last session left (possibly wiped or
  unseeded): run the repo's seed target before interpreting test results —
  an empty-DB red is not a code red.

## Cherry-picks / backports across projects

- Land on the target repo's convention branch, never main/master.
- Validate with the TARGET repo's own gates, not the source repo's. Known
  trap: tucastigo's full backend gate is `./scripts/run.sh dev tests:backend`
  (parallel + pyright + serial batch) — `dev tests` silently skips the
  serial tests.
- Adapt call sites to each repo's conventions instead of transplanting
  verbatim; one commit per logical port; document skips with reasons.

## Merges and pushes

- No merge to main without validated e2e (owner ruling).
- Branches without upstream stay local — nothing is pushed to origin unless
  the owner asks.
- The postgres image tag in a site's docker-compose.yml is a PLATFORM knob,
  not a dev knob: shared.com's node-setup derives the shared node's PG_MAJOR
  as the MAX across all deployed site trees (node-setup.sh via site_pg_major
  in lib.sh). Merging a major bump to a site's main drags BOTH sites'
  cluster against a live datadir — postgres major bumps are an
  owner-coordinated platform migration, never a routine merge.

## E2E runs are a shared resource (owner ruling, 2026-09-07, amended 2026-09-08)

- A full `tests:e2e` run costs ~15 min. One green run over a given tree is
  THE result for every session; rerun only when changes landed AFTER that
  run — and only when they touch surface e2e covers.
- No pre-flight and no window negotiation before launching it: run.sh's
  `host_busy_check()` refuses to start on a stressed host — launch and let
  it decide (owner, 2026-09-08). If it refuses, wait and retry later.

## Subagent briefs

- Any subagent dispatched into these repos must carry this section's rules
  in its brief — collisions on 2026-08-20 (clobbered uncommitted files, a
  volume deleted mid-verification, port grabs) all traced to agents
  dispatched without them.
