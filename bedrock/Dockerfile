FROM --platform=$TARGETOS/$TARGETARCH debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    HOME=/home/container

WORKDIR /home/container

RUN apt update && apt upgrade -y && \
    apt install -y --no-install-recommends \
        ca-certificates curl unzip tar jq wget iproute2 && \
    if [ "$(uname -m)" = "x86_64" ]; then \
        dpkg --add-architecture i386 && \
        apt update && \
        apt install -y lib32gcc-s1 libsdl2-2.0-0:i386; \
    fi && \
    apt clean && rm -rf /var/lib/apt/lists/*

COPY scripts/entrypoint.sh /entrypoint.sh
COPY scripts/get.sh /get.sh

CMD [ "/bin/bash", "/entrypoint.sh", "/get.sh" ]
