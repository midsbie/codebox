#!/bin/bash
set -e

if [ "$(id -u)" != "$EXPECTED_UID" ] || [ "$(id -g)" != "$EXPECTED_GID" ]; then
    echo "Error: Image was built for UID:GID $EXPECTED_UID:$EXPECTED_GID but running as $(id -u):$(id -g)" >&2
    echo "Rebuild the image: docker compose build --no-cache" >&2
    exit 1
fi

exec "$HOST_HOME/.local/bin/claude" "$@"
