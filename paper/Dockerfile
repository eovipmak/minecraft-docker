FROM        debian:bullseye-slim

RUN         apt update && apt -y install curl tar jq iproute2

ENV         HOME=/home/container

WORKDIR     /home/container

COPY        ./scripts/entrypoint.sh /entrypoint.sh
COPY        ./scripts/get.sh /get.sh
CMD         [ "/bin/bash", "/entrypoint.sh" "/get.sh" ]