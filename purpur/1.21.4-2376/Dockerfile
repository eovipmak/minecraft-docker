FROM debian:bullseye-slim

ARG MINECRAFT_VERSION="1.21.4"

ARG BUILD_NUMBER="2376"

ENV DOWNLOAD_URL=https://api.purpurmc.org/v2/purpur/${MINECRAFT_VERSION}/${BUILD_NUMBER}/download

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
