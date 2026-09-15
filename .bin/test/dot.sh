#!/bin/sh
#description: tests for .bin/dot, every case under a throwaway $HOME
#usage: sh .bin/test/dot.sh

#example: git clone https://github.com/javier-lopez/dotfiles && sh dotfiles/.bin/test/dot.sh

REPO="$(cd "$(dirname "${0}")/../.." && pwd)"
TMP="$(mktemp -d)" || exit 1
trap 'rm -rf "${TMP}"' EXIT
trap 'exit 1' INT TERM

PASS="0"; FAIL="0"

_t() { #runs one test line in a subshell, its exit status is the verdict
    if (eval "${1}") >/dev/null 2>&1; then
        PASS="$((PASS + 1))"
    else
        FAIL="$((FAIL + 1))"; printf "%s\\n" "FAIL: ${1}"
    fi
}

#dot runs git against $HOME: every case points it at a scratch dir, so a
#refusal that regresses reaches a throwaway home, never the real one
PATH="${REPO}/.bin:${PATH}"; export PATH
HOME="${TMP}/refuse"; export HOME; mkdir -p "${HOME}"

#usage and refusals
_t 'dot; test X"${?}" = X"1"'
_t 'dot -h; test X"${?}" = X"0"'
_t 'dot --help; test X"${?}" = X"0"'
_t 'test X"$(dot | head -1)" = X""'
_t 'test X"$(dot 2>&1 | head -1)" = X"Usage: dot [git command] [args]..."'
_t 'test X"$(dot -h | head -1)" = X"Usage: dot [git command] [args]..."'
_t 'test X"$(dot --help | head -1)" = X"Usage: dot [git command] [args]..."'
_t 'dot clean; test X"${?}" = X"1"'
_t 'dot clean -n; test X"${?}" = X"1"'
_t 'dot add -A; test X"${?}" = X"1"'
_t 'dot add --all; test X"${?}" = X"1"'
_t 'dot add .; test X"${?}" = X"1"'
_t 'dot reset --hard; test X"${?}" = X"1"'
_t 'dot checkout -f; test X"${?}" = X"1"'
_t 'dot switch --discard-changes master; test X"${?}" = X"1"'
_t 'dot pull --autostash; test X"${?}" = X"1"'
_t 'dot get; test X"${?}" = X"1"'
_t 'dot get 2>&1 | grep -q "needs a path"'
_t 'test X"$(dot clean 2>&1 | cut -d: -f1-2)" = X"dot: refused"'
_t 'test X"$(dot add -A 2>&1 | cut -d: -f1-2)" = X"dot: refused"'
_t 'test X"$(dot reset --hard 2>&1 | cut -d: -f1-2)" = X"dot: refused"'
_t 'test X"$(dot pull --autostash 2>&1 | cut -d: -f1-2)" = X"dot: refused"'

#bootstrap: a remote holding this repo's HEAD as master (the clone may sit on
#a detached HEAD), and a machine that already has its own .bashrc plus an
#.inputrc identical to the repo's
git clone -q --bare "${REPO}" "${TMP}/remote.git"
git --git-dir="${TMP}/remote.git" update-ref refs/heads/master HEAD
git --git-dir="${TMP}/remote.git" symbolic-ref HEAD refs/heads/master
REMOTE="file://${TMP}/remote.git"

#a stub shundle, so bootstrap's install step is exercised without the network:
#its installer only records that it ran and with which rc file
mkdir -p "${TMP}/shundle/bin"
printf "%s\\n" "#stub" > "${TMP}/shundle/shundle"
printf "%s\\n" "#!/bin/sh" "printf \"%s\\n\" \"install \${SHUNDLE_RC}\" >> \"${TMP}/shundle-ran\"" \
    > "${TMP}/shundle/bin/shundle"
chmod +x "${TMP}/shundle/bin/shundle"
(cd "${TMP}/shundle" && git init -q . && git add -A . &&
 git -c user.name=t -c user.email=t@t commit -qm stub) >/dev/null 2>&1
DOT_SHUNDLE_URL="file://${TMP}/shundle"; export DOT_SHUNDLE_URL

#this machine's .bashrc asks for plugins, so bootstrap must set shundle up
HOME="${TMP}/home"; export HOME; mkdir -p "${HOME}/project"
printf "%s\\n" "local bashrc" "Bundle='javier-lopez/shundle'" > "${HOME}/.bashrc"
git --git-dir="${TMP}/remote.git" show HEAD:.inputrc > "${HOME}/.inputrc"

#run it the way the README does: sh -c "$(curl ...)" dot bootstrap
sh -c "$(cat "${REPO}/.bin/dot")" dot bootstrap "${REMOTE}" >/dev/null 2>&1
BOOTSTRAP="${?}"
_t 'test X"${BOOTSTRAP}" = X"0"'
_t 'test X"$(head -1 "${HOME}/.bashrc")" = X"local bashrc"'
_t 'test X"$(dot status --short)" = X" M .bashrc"'
_t 'dot sparse-checkout list | grep -qx "/.inputrc"'
_t 'test -x "${HOME}/.bin/dot"'
_t 'test -f "${HOME}/.gitignore"'
_t 'test -f "${HOME}/.claude/CLAUDE.md"'
_t 'test -f "${HOME}/.claude/RTK.md"'
_t 'test -f "${HOME}/.claude/parallel-sessions.md"'
_t 'test ! -e "${HOME}/.claude/settings.json"'
_t 'test ! -e "${HOME}/.vimrc"'
_t 'test ! -e "${HOME}/README.md"'
_t 'test ! -e "${HOME}/.bin/test"'
_t 'test ! -e "${HOME}/.config/nvim"'
_t 'test -f "${HOME}/.dot/include"'
_t 'test -f "${HOME}/.ban.wcd"'
_t 'dot sparse-checkout list | grep -qx "/.dot/include"'
_t 'dot sparse-checkout list | grep -qx "/.ban.wcd"'
_t 'test X"$(cd "${HOME}/project" && dot ls-files | wc -l)" = X"$(dot ls-files | wc -l)"'
_t 'dot check-ignore -q --no-index .bin/other'
_t 'dot check-ignore -q --no-index .bin/dot; test X"${?}" = X"1"'
_t 'dot check-ignore -q --no-index .config/x/.bin/y'
_t 'dot check-ignore -q --no-index .bin/test/dot.sh; test X"${?}" = X"1"'
_t 'dot check-ignore -q --no-index .ssh/other'
_t 'dot check-ignore -q --no-index .ssh/config; test X"${?}" = X"1"'

#shundle: cloned from DOT_SHUNDLE_URL and told which rc file to read
_t 'test -f "${HOME}/.shundle/bundle/shundle/shundle"'
_t 'grep -qx "install ${HOME}/.bashrc" "${TMP}/shundle-ran"'
_t 'test X"$(wc -l < "${TMP}/shundle-ran")" = X"1"'

#get: one more tracked path into ~, with or without the leading slash
_t 'dot get /.vimrc && test -f "${HOME}/.vimrc"'
_t 'dot sparse-checkout list | grep -qx "/.vimrc"'
_t 'dot get .config/nvim/init.lua && test -f "${HOME}/.config/nvim/init.lua"'
_t 'dot sparse-checkout list | grep -qx "/.config/nvim/init.lua"'

#a second run would reset the index: refused, index untouched
INDEX="$(dot ls-files -s | cksum)"
dot bootstrap "${REMOTE}" >/dev/null 2>&1
AGAIN="${?}"
_t 'test X"${AGAIN}" = X"1"'
_t 'test X"$(dot ls-files -s | cksum)" = X"${INDEX}"'

#a run that died after the clone resumes from it, and a CLAUDE.md the machine
#already had wins over the repo's
HOME="${TMP}/resume"; export HOME; mkdir -p "${HOME}/.claude"
printf "%s\\n" "local claude" > "${HOME}/.claude/CLAUDE.md"
git clone -q --bare "${REMOTE}" "${HOME}/.dotfiles.git"
dot bootstrap "${REMOTE}" > "${TMP}/resume.out" 2>&1
RESUME="${?}"
_t 'test X"${RESUME}" = X"0"'
_t 'test -x "${HOME}/.bin/dot"'
_t 'test X"$(cat "${HOME}/.claude/CLAUDE.md")" = X"local claude"'
_t 'test X"$(dot status --short)" = X" M .claude/CLAUDE.md"'

#no .bashrc here, so there is no 'Bundle=' line: shundle is left alone and the
#next step is printed instead of cloning something that would bring no plugins
_t 'test ! -e "${HOME}/.shundle"'
_t 'grep -q "Bundle=" "${TMP}/resume.out"'
_t 'grep -q "restore .bashrc" "${TMP}/resume.out"'

#.dot/include is what decides that list, so a repo without one has to keep
#bootstrapping: dot falls back to its floor, the ignore rules and itself, and
#brings nothing else - not the Claude instructions, not the wcd ban list
git clone -q --bare "${REMOTE}" "${TMP}/nolist.git"
git clone -q "${TMP}/nolist.git" "${TMP}/nolist-work" 2>/dev/null
(cd "${TMP}/nolist-work" && git rm -rq .dot &&
 git -c user.name=t -c user.email=t@t commit -qm "no list" &&
 git push -q origin master) >/dev/null 2>&1

HOME="${TMP}/floor"; export HOME; mkdir -p "${HOME}"
dot bootstrap "file://${TMP}/nolist.git" >/dev/null 2>&1
FLOOR="${?}"
_t 'test X"${FLOOR}" = X"0"'
_t 'test -x "${HOME}/.bin/dot"'
_t 'test -f "${HOME}/.gitignore"'
_t 'test ! -e "${HOME}/.claude/CLAUDE.md"'
_t 'test ! -e "${HOME}/.ban.wcd"'
_t 'test ! -e "${HOME}/.dot"'

#and when there is a list, it is the whole answer: the floor is not merged
#into it. Comments, blank lines, indentation, a leading slash and trailing
#blanks are read the way the file says they are
git clone -q --bare "${REMOTE}" "${TMP}/oddlist.git"
git clone -q "${TMP}/oddlist.git" "${TMP}/oddlist-work" 2>/dev/null
printf "%s\n" "#a comment" "" "   #an indented comment" "/.vimrc  " ".inputrc" \
    > "${TMP}/oddlist-work/.dot/include"
(cd "${TMP}/oddlist-work" && git add .dot/include &&
 git -c user.name=t -c user.email=t@t commit -qm "odd list" &&
 git push -q origin master) >/dev/null 2>&1

HOME="${TMP}/odd"; export HOME; mkdir -p "${HOME}"
dot bootstrap "file://${TMP}/oddlist.git" >/dev/null 2>&1
ODD="${?}"
_t 'test X"${ODD}" = X"0"'
_t 'test -f "${HOME}/.vimrc"'
_t 'test -f "${HOME}/.inputrc"'
_t 'test ! -e "${HOME}/.gitignore"'
_t 'test ! -e "${HOME}/.bin/dot"'
_t 'test X"$(dot sparse-checkout list | wc -l)" = X"2"'

printf "%s\\n" "dot: ${PASS} passed, ${FAIL} failed"
[ "${FAIL}" -eq "0" ]

# vim: set ts=8 sw=4 tw=0 ft=sh :
