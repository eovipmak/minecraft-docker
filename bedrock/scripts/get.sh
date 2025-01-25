#!/bin/bash

RANDVERSION=$((1 + RANDOM % 4000))
BASE_URL="https://www.minecraft.net/bedrockdedicatedserver/bin-linux"


DOWNLOAD_URL=${BASE_URL}/bedrock-server-${BEDROCK_VERSION:-latest}.zip

echo -e "\nDownloading ${BEDROCK_VERSION:-latest} Bedrock server from: $DOWNLOAD_URL"
curl -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" -o server.zip "$DOWNLOAD_URL"


echo -e "Backing up config files"
for file in server.properties permissions.json allowlist.json; do
    [ -f $file ] && cp $file $file.bak
done


echo -e "Unpacking server files"
unzip -o server.zip && rm server.zip


echo -e "Restoring config files"
for file in server.properties permissions.json allowlist.json; do
    [ -f $file.bak ] && cp -f $file.bak $file
done

chmod +x bedrock_server
echo -e "Installation complete"
