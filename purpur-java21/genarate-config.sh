#!/bin/bash

# Fetch the latest version
get_latest_version() {
    curl -s https://api.purpurmc.org/v2/${PROJECT} | jq -r '.versions[-1]'
}

# Check if a version exists
version_exists() {
    curl -s https://api.purpurmc.org/v2/${PROJECT} | jq -r --arg VERSION "$1" '.versions[] | contains($VERSION)' | grep -q true
}

# Fetch the latest build for a version
get_latest_build() {
    curl -s https://api.purpurmc.org/v2/${PROJECT}/${1} | jq -r '.builds.latest'
}

# Check if a build exists for a version
build_exists() {
    curl -s https://api.purpurmc.org/v2/${PROJECT}/${1} | jq -r --arg BUILD "$2" '.builds.all | tostring | contains($BUILD)' | grep -q true
}


MINECRAFT_VERSION="${1:-latest}"
BUILD_NUMBER="${2:-latest}"
PROJECT=purpur

# Check if the specified Minecraft version exists
if version_exists "$MINECRAFT_VERSION"; then
    echo "Version is valid. Using version ${MINECRAFT_VERSION}"
else
    echo "Using the latest ${PROJECT} version"
    MINECRAFT_VERSION=$(get_latest_version)
fi

# Check if the specified build number exists for minecraft version
if build_exists "$MINECRAFT_VERSION" "$BUILD_NUMBER"; then
    echo "Build is valid for version ${MINECRAFT_VERSION}. Using build ${BUILD_NUMBER}"
else
    echo "Using the latest ${PROJECT} build for version ${MINECRAFT_VERSION}"
    BUILD_NUMBER=$(get_latest_build "$MINECRAFT_VERSION")
fi

# Export version and build number
export MINECRAFT_VERSION
export BUILD_NUMBER

# Update the value in docker-compose.yml
sed -i "s/MINECRAFT_VERSION: \"[^\"]*\"/MINECRAFT_VERSION: \"$MINECRAFT_VERSION\"/" docker-compose.yml
echo "Setup MINECRAFT_VERSION=$MINECRAFT_VERSION in docker-compose.yml"
sed -i "s/BUILD_NUMBER: \"[^\"]*\"/BUILD_NUMBER: \"$BUILD_NUMBER\"/" docker-compose.yml
echo "Setup BUILD_NUMBER=$BUILD_NUMBER in docker-compose.yml"

