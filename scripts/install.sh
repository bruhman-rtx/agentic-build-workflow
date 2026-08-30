#!/bin/sh
#
# install.sh - install the night command files into ~/.claude/commands/
#
# POSIX equivalent of install.ps1, for macOS, Linux, WSL, and Git Bash.
#
# NOTE ON THE WATCHDOG
# --------------------
# The watchdog (scripts/night-watchdog.ps1) is PowerShell, and on a non-Windows
# machine it needs `pwsh` (PowerShell 7+) on PATH:
#
#     # macOS
#     brew install --cask powershell
#     # Debian/Ubuntu - see https://learn.microsoft.com/powershell/scripting/install/
#
# This script copies it into ~/.claude/night/ if pwsh is available, and tells
# you what to do if it is not. It also watches the session transcript directory
# and relaunches `claude`, so it assumes the Claude Code CLI is on PATH too.
#
# IDEMPOTENT. Safe to re-run: a file whose contents already match is reported as
# up to date and left alone.
#
# NEVER OVERWRITES WITHOUT ASKING. A customised nightmax.md is not ours to
# replace. If a destination exists and differs you are prompted; with no TTY the
# file is SKIPPED, never overwritten. Pass --force to overwrite deliberately.
#
# Usage:
#   ./install.sh                      install, prompting on conflicts
#   ./install.sh --force              overwrite differing files without asking
#   ./install.sh --symlink            link instead of copy
#   ./install.sh --claude-home DIR    non-default location
#   ./install.sh --dry-run            show what would happen, change nothing

set -eu

CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
FORCE=0
SYMLINK=0
DRY_RUN=0

while [ $# -gt 0 ]; do
  case "$1" in
    --force)        FORCE=1 ;;
    --symlink)      SYMLINK=1 ;;
    --dry-run)      DRY_RUN=1 ;;
    --claude-home)  shift; CLAUDE_HOME="${1:?--claude-home needs a path}" ;;
    -h|--help)      sed -n '2,32p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *)              echo "unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(dirname -- "$SCRIPT_DIR")
SRC_COMMANDS="$REPO_ROOT/commands"
SRC_SCRIPTS="$REPO_ROOT/scripts"
DST_COMMANDS="$CLAUDE_HOME/commands"
DST_NIGHT="$CLAUDE_HOME/night"

[ -d "$SRC_COMMANDS" ] || {
  echo "commands/ not found at $SRC_COMMANDS - run this from inside a clone of the repo." >&2
  exit 1
}

n_installed=0
n_current=0
n_skipped=0
skipped_names=""

say()  { printf '%s\n' "$*"; }
step() { printf '  %-11s %s\n' "$1" "$2"; }

same_file() {
  # Portable content comparison; cmp is POSIX and present everywhere.
  cmp -s "$1" "$2" 2>/dev/null
}

make_dir() {
  [ -d "$1" ] && return 0
  if [ "$DRY_RUN" -eq 1 ]; then step "would mkdir" "$1"; return 0; fi
  mkdir -p "$1"
  step "created" "$1"
}

install_one() {
  src="$1"
  dst="$2"
  name=$(basename -- "$dst")

  if [ -e "$dst" ]; then
    if same_file "$src" "$dst"; then
      step "up to date" "$name"
      n_current=$((n_current + 1))
      return 0
    fi

    if [ "$FORCE" -ne 1 ]; then
      if [ ! -t 0 ]; then
        step "SKIPPED" "$name (exists and differs; no TTY)"
        n_skipped=$((n_skipped + 1))
        skipped_names="$skipped_names $name"
        return 0
      fi
      say ""
      say "  $name already exists at $dst and differs from this repo's copy."
      printf '  Overwrite it? [y/N] '
      read -r answer || answer=""
      case "$answer" in
        y|Y|yes|YES) ;;
        *)
          step "SKIPPED" "$name (kept your version)"
          n_skipped=$((n_skipped + 1))
          skipped_names="$skipped_names $name"
          return 0
          ;;
      esac
    fi
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    step "would install" "$name"
    return 0
  fi

  if [ "$SYMLINK" -eq 1 ]; then
    ln -sf "$src" "$dst"
    step "linked" "$name"
  else
    cp -f "$src" "$dst"
    step "installed" "$name"
  fi
  n_installed=$((n_installed + 1))
}

say ""
say "Installing to $CLAUDE_HOME"
say ""

make_dir "$DST_COMMANDS"
make_dir "$DST_NIGHT"

say ""
say "Commands:"

found_any=0
for f in "$SRC_COMMANDS"/*.md; do
  [ -e "$f" ] || continue
  [ "$(basename -- "$f")" = "README.md" ] && continue
  found_any=1
  install_one "$f" "$DST_COMMANDS/$(basename -- "$f")"
done
[ "$found_any" -eq 1 ] || step "(none)" "no command files in commands/"

say ""
say "Watchdog:"

WATCHDOG="$SRC_SCRIPTS/night-watchdog.ps1"
if [ -f "$WATCHDOG" ]; then
  install_one "$WATCHDOG" "$DST_NIGHT/night-watchdog.ps1"
  if ! command -v pwsh >/dev/null 2>&1; then
    say ""
    say "  NOTE: the watchdog is PowerShell and 'pwsh' is not on your PATH."
    say "  Install PowerShell 7+ before arming a night run, or the run will have"
    say "  only the in-session cron nudge - which dies with the session and"
    say "  therefore cannot survive a crash or a usage-limit lockout."
  fi
else
  step "missing" "night-watchdog.ps1 not found in scripts/"
fi

say ""
say "--------------------------------------------------------------------"
say "Installed: $n_installed   Already current: $n_current   Skipped: $n_skipped"

if [ "$n_skipped" -gt 0 ]; then
  say ""
  say "Kept your existing versions of:$skipped_names"
  say "Re-run with --force to replace them, or diff them against this repo first."
fi

cat <<NEXT

Next steps

  1. Write the two documents. Start at prompts/01-prd-interrogation.md.
     Templates: templates/PRD-template.md, templates/PIPELINE-template.md

  2. Put PRD.md, PIPELINE.md and CLAUDE.md in the target repo root.
     Template: templates/CLAUDE.md.template

  3. Fill the night brief - this is the memory across crashes:
       $DST_NIGHT/brief.md
     Template: templates/brief.md.template

  4. Walk templates/preflight-checklist.md, then arm the run.

  Kill switch: create $DST_NIGHT/STOP to stop the watchdog.
NEXT
