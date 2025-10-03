#!/usr/bin/env bash
# sync-dir.sh — generic, safe rsync wrapper for containers
# Usage:
#   sync-dir.sh <sync_from> <sync_to> [--dry-run] [--delete] [--mode dotfiles|secrets] \
#               [--exclude GLOB ...] [--exclude-file FILE] [--chmod MODE] [--chown USER:GROUP]
# Examples:
#   sync-dir.sh /repo/dotfiles "$HOME" --mode dotfiles
#   sync-dir.sh /secrets       "$HOME" --mode secrets --dry-run
#   sync-dir.sh /src /dst --exclude '.git' --exclude '.cache' --delete
#
# Notes:
# - Refuses to run on the host (must be inside a container).
# - Never deletes by default (use --delete explicitly).
# - Honors DRY_RUN=1 env or --dry-run flag.
# - Safe guards against syncing from/to "/".
# - Supports default exclude sets for dotfiles/secrets modes.

set -euo pipefail

log() { printf '[sync] %s\n' "$*"; }
err() { printf '[sync][error] %s\n' "$*" >&2; }
die() { err "$@"; exit 1; }

# --- ensure we are inside a container, not on the host ---
if ! { [ -f "/.dockerenv" ] || [ -f "/run/.containerenv" ] || grep -qaE '(docker|podman|lxc|container)' /proc/1/cgroup; }; then
  die "Refusing to run on the host. This script must run inside a container."
fi

command -v rsync >/dev/null 2>&1 || die "rsync is not installed."
: "${HOME:?HOME must be set}"

# Optional: if /repo is not mounted but /distrobox-invoked-from-host exists, symlink it
if [ ! -e /repo ] && [ -e /distrobox-invoked-from-host ]; then
  ln -s /distrobox-invoked-from-host /repo 2>/dev/null || true
fi

# --- parse args ---
[[ $# -ge 2 ]] || die "Usage: $0 <sync_from> <sync_to> [options]"
SRC="$1"; shift
DST="$1"; shift

# Protect from dangerous targets/sources
[[ "$SRC" != "/" ]] || die "Refusing to use '/' as source."
[[ "$DST" != "/" ]] || die "Refusing to use '/' as destination."

RSYNC_FLAGS=(-a)               # archive mode (preserves perms, times, symlinks, etc.)
DRY="${DRY_RUN:-0}"
DELETE=0
MODE=""                        # dotfiles|secrets|empty
EXCLUDES=()
EXCLUDE_FILE=""
CHMOD_ARG=""
CHOWN_ARG=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY=1 ;;
    --delete)  DELETE=1 ;;
    --mode)
      MODE="${2:-}"; shift
      [[ "$MODE" == "dotfiles" || "$MODE" == "secrets" ]] || die "--mode expects 'dotfiles' or 'secrets'"
      ;;
    --exclude)
      [[ -n "${2:-}" ]] || die "--exclude needs a pattern"
      EXCLUDES+=("$2"); shift
      ;;
    --exclude-file)
      EXCLUDE_FILE="${2:-}"; shift
      [[ -f "$EXCLUDE_FILE" ]] || die "exclude-file not found: $EXCLUDE_FILE"
      ;;
    --chmod)
      CHMOD_ARG="${2:-}"; shift
      ;;
    --chown)
      CHOWN_ARG="${2:-}"; shift
      ;;
    *)
      die "Unknown option: $1"
      ;;
  esac
  shift
done

# --- defaults by mode ---
if [[ "$MODE" == "dotfiles" ]]; then
  # Keep configs; avoid private keys and volatile caches
  DEFAULT_EXCLUDES=( ".gnupg" "private-keys-v1.d" "trustdb.gpg" "pubring.kbx" "crls.d" ".cache" ".DS_Store" "node_modules" "__pycache__" )
elif [[ "$MODE" == "secrets" ]]; then
  # Be conservative; exclude obvious junk but generally copy secrets as-is
  DEFAULT_EXCLUDES=( ".DS_Store" )
else
  DEFAULT_EXCLUDES=()
fi

# Build rsync exclude flags
RSYNC_EX=()
for pat in "${DEFAULT_EXCLUDES[@]}"; do RSYNC_EX+=(--exclude "$pat"); done
for pat in "${EXCLUDES[@]}";          do RSYNC_EX+=(--exclude "$pat"); done
[[ -n "$EXCLUDE_FILE" ]] && RSYNC_EX+=(--exclude-from "$EXCLUDE_FILE")

# Dry run
[[ "$DRY" == "1" ]] && RSYNC_FLAGS+=(-n)

# Delete flag (mirror mode)
[[ "$DELETE" == "1" ]] && RSYNC_FLAGS+=(--delete)

# Optional chmod/chown post-copy (rsync-side when possible)
# Prefer rsync --chown/--chmod to avoid a second pass when supported
RSYNC_OWNER_FLAGS=()
[[ -n "$CHOWN_ARG" ]] && RSYNC_OWNER_FLAGS+=(--chown="$CHOWN_ARG")
RSYNC_PERM_FLAGS=()
[[ -n "$CHMOD_ARG" ]] && RSYNC_PERM_FLAGS+=(--chmod="$CHMOD_ARG")

# Validate paths
[[ -d "$SRC" ]] || die "Source not found or not a directory: $SRC"
[[ -e "$DST" ]] || mkdir -p "$DST"
[[ -w "$DST" ]] || die "Destination not writable: $DST"

log "Sync: $SRC/ -> $DST/"
[[ "$DRY" == "1" ]] && log "Mode: DRY-RUN"
[[ "$DELETE" == "1" ]] && log "Mode: DELETE enabled"
[[ -n "$MODE" ]] && log "Profile: $MODE"

# Final rsync call
# Use "$SRC/." to copy dir contents, not the directory itself.
rsync "${RSYNC_FLAGS[@]}" "${RSYNC_EX[@]}" "${RSYNC_OWNER_FLAGS[@]}" "${RSYNC_PERM_FLAGS[@]}" \
  "$SRC/." "$DST/"

log "Done."
