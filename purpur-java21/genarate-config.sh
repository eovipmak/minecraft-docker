#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if jq is installed
if ! command_exists jq; then
    echo "jq is not installed. Installing jq..."
    if [ -f /etc/debian_version ]; then
        # Debian-based
        sudo apt update
        sudo apt install -y jq
    elif [ -f /etc/redhat-release ]; then
        # RedHat-based
        sudo yum install -y jq
    fi
fi

# Check if curl is installed
if ! command_exists curl; then
    echo "curl is not installed. Installing curl..."
    if [ -f /etc/debian_version ]; then
        # Debian-based
        sudo apt update
        sudo apt install -y curl
    elif [ -f /etc/redhat-release ]; then
        # RedHat-based
        sudo yum install -y curl
    fi
fi

# Check if Docker is installed
if ! command_exists docker; then
    echo "Docker is not installed. Installing Docker..."
    if [ -f /etc/debian_version ]; then
        # Debian-based
        sudo apt update
        sudo apt install -y docker.io
    elif [ -f /etc/redhat-release ]; then
        # RedHat-based
        sudo yum install -y docker
    fi
    sudo systemctl start docker
    sudo systemctl enable docker
fi

# Check if Docker Compose is installed
if ! command_exists docker-compose; then
    echo "Docker Compose is not installed. Installing Docker Compose..."
    if [ -f /etc/debian_version ]; then
        # Debian-based
        sudo apt update
        sudo apt install -y docker-compose
    elif [ -f /etc/redhat-release ]; then
        # RedHat-based
        sudo yum install -y docker-compose
    fi
fi

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

# Check if the specified build number exists for the chosen version
if build_exists "$MINECRAFT_VERSION" "$BUILD_NUMBER"; then
    echo "Build is valid for version ${MINECRAFT_VERSION}. Using build ${BUILD_NUMBER}"
else
    echo "Using the latest ${PROJECT} build for version ${MINECRAFT_VERSION}"
    BUILD_NUMBER=$(get_latest_build "$MINECRAFT_VERSION")
fi

# Export the determined version and build number
export MINECRAFT_VERSION
export BUILD_NUMBER

# Update the docker-compose.yml file with the determined values
sed -i "s/MINECRAFT_VERSION: \"[^\"]*\"/MINECRAFT_VERSION: \"$MINECRAFT_VERSION\"/" docker-compose.yml
echo "Setup MINECRAFT_VERSION=$MINECRAFT_VERSION in docker-compose.yml"
sed -i "s/BUILD_NUMBER: \"[^\"]*\"/BUILD_NUMBER: \"$BUILD_NUMBER\"/" docker-compose.yml
echo "Setup BUILD_NUMBER=$BUILD_NUMBER in docker-compose.yml"

