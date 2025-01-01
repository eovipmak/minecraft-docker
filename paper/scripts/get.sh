# Fetch the latest version
get_latest_version() {
    curl -s https://api.papermc.io/v2/projects/${PROJECT} | jq -r '.versions' | jq -r '.[-1]'
}

# Check if a version exists
version_exists() {
    curl -s https://api.papermc.io/v2/projects/${PROJECT} | jq -r --arg VERSION $MINECRAFT_VERSION '.versions[] | contains($VERSION)' | grep -m1 true
}

# Fetch the latest build for a version
get_latest_build() {
    curl -s https://api.papermc.io/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION} | jq -r '.builds' | jq -r '.[-1]'
}

# Check if a build exists for a version
build_exists() {
    curl -s https://api.papermc.io/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION} | jq -r --arg BUILD ${BUILD_NUMBER} '.builds[] | tostring | contains($BUILD)' | grep -m1 true
}

MINECRAFT_VERSION=$MINECRAFT_VERSION
BUILD_NUMBER=$BUILD_NUMBER
PROJECT=paper

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
export JAR_NAME="paper-${MINECRAFT_VERSION}-${BUILD_NUMBER}.jar"

# Check and download paper jar file if it doesn't exist
if [ ! -f server.jar ]; then
    echo "Downloading Minecraft Paper version ${MINECRAFT_VERSION} build ${BUILD_NUMBER}"
    curl -o server.jar https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/${BUILD_NUMBER}/downloads/${JAR_NAME}
    echo "Done!"
else
    echo "server.jar already exists. Skipping download."
fi

# Check and get server.properties if it doesn't exist
if [ ! -f server.properties ]; then
    echo -e "Downloading MC server.properties"
    curl -o server.properties https://raw.githubusercontent.com/parkervcp/eggs/master/minecraft/java/server.properties
else
    echo "server.properties already exists. Skipping download."
fi

# Accept EULA and disable online-mode
if [ ! -f eula.txt ]; then
    echo "eula=true" > eula.txt
else
    if ! grep -q "eula=true" eula.txt; then
        sed -i 's/^eula=.*/eula=true/' eula.txt
    fi
fi

# Ensure online-mode is set to false
if ! grep -q "online-mode=false" server.properties; then
    if grep -q "online-mode=" server.properties; then
        sed -i 's/^online-mode=.*/online-mode=false/' server.properties
    else
        echo "online-mode=false" >> server.properties
    fi
fi

# Check and get JDK 21 if java command doesn't exist
if ! command -v java &> /dev/null; then
    echo "Getting JDK 21"
    cd /
    export URL="https://files.tntin.id.vn/upload/jdk-temurin/OpenJDK21U.tar.gz"
    curl -L $URL -o java.tar.gz
    tar xzf java.tar.gz
    ln -s /jdk-21.0.5+11/bin/java /usr/bin/java
    echo "JDK 21 is installed"
else
    echo "Java is already installed. Skipping download."
fi
