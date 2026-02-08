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

exec "$HOST_HOME/.local/bin/claude" "$@"
