FROM debian:bullseye-slim

ARG MINECRAFT_VERSION="1.21.3"

ARG BUILD_NUMBER="82"

ARG JAR_NAME=paper-${MINECRAFT_VERSION}-${BUILD_NUMBER}.jar

ENV DOWNLOAD_URL=https://api.papermc.io/v2/projects/paper/${MINECRAFT_VERSION}/builds/${BUILD_NUMBER}/downloads/${JAR_NAME}

RUN apt update && apt -y install curl tar

RUN mkdir -p /mnt/server

RUN cd /mnt/server && echo "eula=true" > eula.txt

RUN curl -o server.jar ${DOWNLOAD_URL} && mv server.jar /mnt/server

RUN curl -o server.properties https://raw.githubusercontent.com/parkervcp/eggs/master/minecraft/java/server.properties && mv server.properties /mnt/server

RUN echo "online-mode=false" > /mnt/server/server.properties

ENV URL="https://files.tntin.id.vn/upload/jdk-temurin/OpenJDK21U.tar.gz"

RUN curl -L $URL -o java.tar.gz

RUN tar --transform='s|^[^/]*|java|' -xzvf java.tar.gz

RUN ln -s /java/bin/java /usr/bin/java
