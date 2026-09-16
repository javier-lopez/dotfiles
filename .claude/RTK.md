# RTK - Rust Token Killer

**Usage**: Token-optimized CLI proxy (60-90% savings on dev operations)

## Meta Commands (always use rtk directly)

```bash
rtk gain              # Show token savings analytics
rtk gain --history    # Show command usage history with savings
rtk discover          # Analyze Claude Code history for missed opportunities
rtk proxy <cmd>       # Execute raw command without filtering (for debugging)
```

## Installation Verification

```bash
rtk --version         # Should show: rtk X.Y.Z
rtk gain              # Should work (not "command not found")
which rtk             # Verify correct binary
```

⚠️ **Name collision**: If `rtk gain` fails, you may have reachingforthejack/rtk (Rust Type Kit) installed instead.

## Hook-Based Usage

All other commands are automatically rewritten by the Claude Code hook.
Example: `git status` → `rtk git status` (transparent, 0 tokens overhead)

Refer to CLAUDE.md for full command reference.

## ⚠️ When the filter LIES — use `rtk proxy` to bypass

For some commands rtk substitutes the actual output with a SCHEMATIC representation to save tokens. The filtered output is structurally similar to the real one but contains type placeholders instead of values, e.g. `curl https://api.example.com/version` may return:

```
{
  build_date: string,
  commit: string,
  environment: string,
  version: string
}
```

instead of the real JSON `{"build_date":"2026-...","commit":"cc7ddb4",...}`.

This is intentional and saves tokens on read-only inspection. But it has bitten agents:

- Health-check / version-check skills that PARSE the response have reported "prod is broken / returns invalid JSON" when prod is actually fine — because the agent saw rtk's schematic output.
- Sanity-check `curl` calls that compare a token to an expected value silently fail because rtk returned `string` instead of the real token.

**Rule**: when you need the ACTUAL VALUES of an HTTP response (not just its shape), wrap the command in `rtk proxy`:

```bash
rtk proxy curl -s https://tucastigo.com/version
```

Use `rtk proxy` for: `/version`-style anchors, prod readiness checks before/after deploy, secret/config readbacks, anything whose output you'll diff against an expected value.

Use raw `curl` (or any HTTP client) for: structural verification only ("is the endpoint up", "does it return JSON-shaped"), browsing logs, debugging.

If a script returns suspiciously-typed JSON (`{ key: string, ... }` without quotes around values), treat that as the rtk-filtered version and re-run with `rtk proxy`. Never report "the upstream is returning bad JSON" off that output.
