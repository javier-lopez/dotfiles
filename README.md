# dotfiles

Personal configuration, versioned with `$HOME` itself as the work tree of a
bare git repository. Nothing is copied or symlinked: the file your shell,
editor or Claude Code reads **is** the tracked file, so `dot status` shows
every change made to it, by you or by a tool.

## Layout

- Files at the root of the repo map to `~` (`.bashrc` → `~/.bashrc`).
- `.gitignore` ignores everything (`/*`), re-includes dotfiles (`!.*`), then
  excludes the dotfiles that must never be published. This is a **public**
  repo: secrets are committed only as `.gpg` files.
- `.bin/dot` is the helper that runs git on this repo. It lands in
  `~/.bin/dot`; the other scripts in `~/.bin` come from the
  [learn](https://github.com/javier-lopez/learn) repo and are not versioned here.
- `init.lua` is the Neovim config. It is not a dotfile and is not mapped to `~`.
- `.profile.ps1` holds PowerShell settings for Windows (see [Windows](#windows)).
- `README.md` is this file. It sits outside every machine's sparse checkout,
  so it never lands in `~`.

## Bootstrap a machine

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/javier-lopez/dotfiles/master/.bin/dot)" dot bootstrap
~/.bin/dot diff          # repo version -> local version, file by file
```

`dot bootstrap` clones the repo into `~/.dotfiles.git`, configures it (not
bare, untracked listing off, fast-forward-only pulls, no autostash) and checks
out only what this machine already has, plus `.gitignore` and `.bin/dot`.
Everything else stays in the repo; to take one more file, run
`dot sparse-checkout add /<path>`. Until `~/.bashrc` puts `~/.bin` on `PATH`,
call the helper as `~/.bin/dot`.

`sh -c "$(curl ...)"` runs the script only once it is fully downloaded: a
`curl | sh` pipe would run a cut-off download as far as it got. Bootstrapping
twice is refused: it would reset the index and drop whatever is staged there.

**Local files win.** Nothing under `~` is overwritten, so a file that already
exists keeps its local content and shows up in `dot diff` as a change against
the repo. Decide per file: commit the local version, or take the repo one with
`dot restore <file>`.

It uses sparse checkout, not `update-index --skip-worktree`: a skip-worktree
file that changes upstream is written into `~` on the next pull anyway, while
files outside a sparse pattern stay out.

## Daily use

```sh
dot status               # tracked files only (the untracked listing is off)
dot diff                 # what changed locally
dot add <path>           # always an explicit path
dot commit -m "..." && dot push
dot pull                 # fast-forward only; aborts if a local change is in the way
```

## Safety rules

The work tree is the whole home directory, so a careless git command reaches
the whole home directory too. `dot` refuses:

| Command | Why |
|---|---|
| `clean` | deletes untracked files across `~`: `~/.ssh` keys, directories that are not repos, and nested repos with `-ff` |
| `add -A`, `add --all`, `add .` | stages every untracked, non-ignored dotfile (tokens, caches) into a public repo |
| `reset --hard`, `checkout -f`, `switch -f` | overwrite local dotfiles |
| `--autostash` | a conflict lands as `<<<<<<<` markers in the live file, e.g. a broken `~/.bashrc` |

Use the helper, not an alias: aliases do not reach non-interactive shells
(scripts, cron, Claude Code's Bash tool), and `~/.bin` is on `PATH`.

`dot` runs git from `~`, so paths are always relative to `~`, whatever the
current directory. Every directory under `~` is inside this work tree, and
plain git makes `ls-files` output and pathspecs relative to the current
directory: run from `~/project`, `ls-files` lists nothing, and a sparse pattern
built from it drops every clean dotfile from `~`.

Use `~/.dotfiles.git` (bare), never `~/.git`: git looks for `.git` upwards, so
a `~/.git` would claim every directory under `~` that is not its own repo.

## Per-machine settings

What differs between machines stays out of the tracked files. `.bashrc`
sources `~/.credentials` (ignored) at the end; machine-local overrides and
secrets go there. A local edit to a tracked file blocks `dot pull` until it is
committed or reverted, on purpose.

## Claude Code

Versioned, and whitelisted in `.gitignore`: `~/.claude/CLAUDE.md`, `RTK.md`,
`parallel-sessions.md` and `settings.json`.

Never versioned: `~/.claude.json` (account and MCP servers, with tokens),
`~/.claude/.credentials.json`, transcripts and session state under `~/.claude/`
(`projects/`, `history.jsonl`, `file-history/`, ...) and
`~/.claude/plugins/cache/`, which is reinstallable. Claude Code rewrites
`settings.json` itself (permission rules, plugin installs), so review
`dot diff .claude/settings.json` before committing it.

## Windows

`.profile.ps1` holds PowerShell settings meant to be pasted into `$PROFILE`
(`notepad $profile`). It is copied by hand and not wired to a work tree.

## Editing this README

It lives outside the sparse checkout. Edit it on GitHub, or bring it into `~`
with `dot sparse-checkout add /README.md`, then drop that line from
`dot sparse-checkout list` and `set` the rest when done.
