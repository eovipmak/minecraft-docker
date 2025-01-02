#!/bin/bash

# Generate a random version number to bypass CDN blocking
RANDVERSION=$(echo $((1 + $RANDOM % 4000)))

# Determine the download URL based on the specified or latest Bedrock version
if [ -z "${BEDROCK_VERSION}" ] || [ "${BEDROCK_VERSION}" == "latest" ]; then
    echo -e "\nDownloading latest Bedrock server"
    curl -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.$RANDVERSION.212 Safari/537.36" -H "Accept-Language: en" -H "Accept-Encoding: gzip, deflate" -o versions.html.gz https://www.minecraft.net/en-us/download/server/bedrock
    DOWNLOAD_URL=$(zgrep -o 'https://www.minecraft.net/bedrockdedicatedserver/bin-linux/[^"]*' versions.html.gz)
else 
    echo -e "\nDownloading ${BEDROCK_VERSION} Bedrock server"
    DOWNLOAD_URL=https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-$BEDROCK_VERSION.zip
fi

# Extract the archive name from the download URL
DOWNLOAD_FILE=$(echo ${DOWNLOAD_URL} | cut -d"/" -f5)

# Backup existing configuration files
echo -e "Backing up config files"
rm *.bak versions.html.gz
cp server.properties server.properties.bak
cp permissions.json permissions.json.bak
cp allowlist.json allowlist.json.bak

# Download the Bedrock server files
echo -e "Downloading files from: $DOWNLOAD_URL"
curl -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.$RANDVERSION.212 Safari/537.36" -H "Accept-Language: en" -o $DOWNLOAD_FILE $DOWNLOAD_URL

# Unpack the downloaded server files
echo -e "Unpacking server files"
unzip $DOWNLOAD_FILE

# Clean up the downloaded archive
echo -e "Cleaning up after installing"
rm $DOWNLOAD_FILE

# Restore the backup configuration files
echo -e "Restoring backup config files - on first install there will be file not found errors which you can ignore."
cp -rf server.properties.bak server.properties
cp -rf permissions.json.bak permissions.json
cp -rf allowlist.json.bak allowlist.json

# Make the Bedrock server executable
chmod +x bedrock_server

echo -e "Install Completed"