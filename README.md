# dotfiles

Personal configuration, versioned with `$HOME` itself as the work tree of a bare git repository. Nothing is copied or symlinked: the file your shell or editor reads **is** the tracked file.

Files at the root map to `~` (`.bashrc` → `~/.bashrc`).

## Bootstrap a machine

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/javier-lopez/dotfiles/master/.bin/dot)" dot bootstrap
```

One command leaves the machine finished: the repo is cloned into `~/.dotfiles.git`, the files land in `~`, and [shundle](https://github.com/javier-lopez/shundle) is installed and run against the `Bundle=` lines of the tracked `.bashrc`, which is what puts the plugins and `~/.bin` in place. Open a new shell and everything is live.

It checks out only what this machine already has, plus what `.dot/include` lists for every machine. **The repo wins**: a tracked file whose content differs is renamed beside itself first, as `<file>.dotfiles.<timestamp>`, and then replaced. It stays where it was, so `~/.bashrc` from this machine is right there as `~/.bashrc.dotfiles.20260915-233500`. A machine already in sync renames nothing.

```sh
ls -d ~/.*.dotfiles.*            # what this machine had before
diff ~/.bashrc ~/.bashrc.dotfiles.*
```

Those files are ignored, so they never turn up in `dot status`. To keep something from one, copy it back and commit it.

## Daily use

```sh
dot status               # tracked files only
dot diff                 # what changed locally
dot add <path>           # always an explicit path
dot get /<path>          # check one more tracked file out into ~
dot commit -m "..." && dot push
dot pull                 # fast-forward only
```

`dot` is a wrapper around `git` pointed at this repo, so any other git command works as `dot <command>`. Use the helper and not an alias: aliases never reach scripts, cron or Claude Code's Bash tool.

## Safety

The work tree is the whole home directory, so a careless git command reaches the whole home directory too. `dot` refuses `clean`, `add -A`/`--all`/`.`, `reset --hard`, `checkout -f`, `switch -f` and `--autostash` on pull, merge or rebase. `bootstrap` is the one command that overwrites, and it backs up first.

## Windows

`.profile.ps1` holds PowerShell settings meant to be pasted into `$PROFILE` (`notepad $profile`). Copied by hand, not wired to a work tree.

## Tests

From a clone: `sh .bin/test/dot.sh`, which runs `.bin/dot` under throwaway homes.
