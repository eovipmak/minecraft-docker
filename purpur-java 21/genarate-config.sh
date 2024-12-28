#!/bin/bash
MINECRAFT_VERSION="${1:-latest}"
BUILD_NUMBER="${2:-latest}"

PROJECT=purpur

VER_EXISTS=`curl -s https://api.purpurmc.org/v2/${PROJECT} | jq -r --arg VERSION $MINECRAFT_VERSION '.versions[] | contains($VERSION)' | grep true`
LATEST_VERSION=`curl -s https://api.purpurmc.org/v2/${PROJECT} | jq -r '.versions' | jq -r '.[-1]'`

#Check if MINECRAFT_VERSION is valid, otherwise use latest version
if [ "${VER_EXISTS}" == "true" ]; then
		echo -e "Version is valid. Using version ${MINECRAFT_VERSION}"
	else
		echo -e "Using the latest ${PROJECT} version"
		MINECRAFT_VERSION=${LATEST_VERSION}
	fi

BUILD_EXISTS=`curl -s https://api.purpurmc.org/v2/${PROJECT}/${MINECRAFT_VERSION} | jq -r --arg BUILD ${BUILD_NUMBER} '.builds.all | tostring | contains($BUILD)' | grep true`
LATEST_BUILD=`curl -s https://api.purpurmc.org/v2/${PROJECT}/${MINECRAFT_VERSION} | jq -r '.builds.latest'`

#Check if BUILD NUMBER is valid, otherwise use latest build
if [ "${BUILD_EXISTS}" == "true" ]; then
		echo -e "Build is valid for version ${MINECRAFT_VERSION}. Using build ${BUILD_NUMBER}"
	else
		echo -e "Using the latest ${PROJECT} build for version ${MINECRAFT_VERSION}"
		BUILD_NUMBER=${LATEST_BUILD}
	fi

export MINECRAFT_VERSION=$MINECRAFT_VERSION
export BUILD_NUMBER=$BUILD_NUMBER

sed -i "s/MINECRAFT_VERSION: \"1.21.3\"/MINECRAFT_VERSION: \"$MINECRAFT_VERSION\"/" docker-compose.yml
echo -e "Setup MINECRAFT_VERSION=$MINECRAFT_VERSION in docker-compose.yml"
sed -i "s/BUILD_NUMBER: \"2358\"/BUILD_NUMBER: \"$BUILD_NUMBER\"/" docker-compose.yml
echo -e "Setup BUILD_NUMBER=$BUILD_NUMBER in docker-compose.yml"

