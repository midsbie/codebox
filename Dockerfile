FROM ubuntu:24.04

ARG HOST_UID=1000
ARG HOST_GID=1000
ARG HOST_USER=user
ARG HOST_HOME=/home/user

RUN apt-get update && apt-get install -y \
    git \
    ripgrep \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Remove any conflicting user/group, then create host user
RUN existing_user=$(getent passwd "$HOST_UID" | cut -d: -f1); \
    existing_group=$(getent group "$HOST_GID" | cut -d: -f1); \
    [ -n "$existing_user" ] && userdel "$existing_user" || true; \
    [ -n "$existing_group" ] && groupdel "$existing_group" || true; \
    groupadd -g "$HOST_GID" "$HOST_USER" && \
    useradd -u "$HOST_UID" -g "$HOST_GID" -d "$HOST_HOME" -s /bin/bash "$HOST_USER" && \
    mkdir -p "$HOST_HOME" && \
    chown "$HOST_UID:$HOST_GID" "$HOST_HOME"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV EXPECTED_UID=$HOST_UID
ENV EXPECTED_GID=$HOST_GID
ENV PATH="$HOST_HOME/.local/bin:$PATH"

USER $HOST_USER

ENTRYPOINT ["/entrypoint.sh"]
