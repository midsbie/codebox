#!/bin/bash
set -e

if [ "$(id -u)" != "$EXPECTED_UID" ] || [ "$(id -g)" != "$EXPECTED_GID" ]; then
    echo "Error: Image was built for UID:GID $EXPECTED_UID:$EXPECTED_GID but running as $(id -u):$(id -g)" >&2
    echo "Rebuild the image: cbox build --no-cache" >&2
    exit 1
fi

# Warn if EDITOR points to a non-existent command
if [[ -n "$EDITOR" ]]; then
    editor_cmd="${EDITOR%% *}"
    if ! command -v "$editor_cmd" >/dev/null 2>&1; then
        echo "Warning: EDITOR='$EDITOR' not found in container" >&2
    fi
fi

# Source repo-specific init hook if present (e.g. background package restore)
repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || true
if [[ -n "$repo_root" && -f "$repo_root/.claude/codebox-init.sh" ]]; then
    source "$repo_root/.claude/codebox-init.sh"
fi

claude_bin="$HOST_HOME/.local/bin/claude"
if ! [ -x "$claude_bin" ]; then
    echo "Error: claude not found at $claude_bin" >&2
    echo "Install it: https://code.claude.com/docs" >&2
    exit 1
fi

exec "$claude_bin" "$@"
