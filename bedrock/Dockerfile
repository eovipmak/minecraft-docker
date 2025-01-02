FROM        --platform=$TARGETOS/$TARGETARCH debian:bookworm-slim

ENV         DEBIAN_FRONTEND=noninteractive

ENV         HOME=/home/container

WORKDIR     /home/container

RUN      apt update && apt upgrade -y \
         && apt -y --no-install-recommends install ca-certificates curl git unzip zip tar jq wget iproute2

RUN         if [ "$(uname -m)" = "x86_64" ]; then \
                dpkg --add-architecture i386 && \
                apt update && \
                apt -y install lib32gcc-s1 libsdl2-2.0-0:i386; \
            fi

COPY        ./scripts/entrypoint.sh /entrypoint.sh
COPY        ./scripts/get.sh /get.sh
CMD         [ "/bin/bash", "/entrypoint.sh", "/get.sh" ]