FROM debian:bookworm-slim

LABEL org.opencontainers.image.title="Manager Server"
LABEL org.opencontainers.image.source="https://github.com/WhiteKnightSTU/manager-server"

ENV ASPNETCORE_URLS=http://+:8080
ENV DOTNET_RUNNING_IN_CONTAINER=true

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        chromium \
        curl \
        libicu72 \
        libssl3 \
        libc6 \
        libglib2.0-0 \
        libgobject-2.0-0 \
        libnspr4 \
        libnss3 \
        libatk1.0-0 \
        libatk-bridge2.0-0 \
        libdbus-1-3 \
        libcups2 \
        libexpat1 \
        libxcb1 \
        libxkbcommon0 \
        libasound2 \
        libgbm1 \
        libx11-6 \
        libxext6 \
        libcairo2 \
        libpango-1.0-0 \
        libxcomposite1 \
        libxdamage1 \
        libxfixes3 \
        libxrandr2 \
        libatspi2.0-0
        zlib1g && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/manager-server

RUN curl -L https://github.com/Manager-io/Manager/releases/latest/download/ManagerServer-linux-x64.tar.gz \
    | tar -xz

RUN chmod +x /opt/manager-server/ManagerServer

VOLUME ["/data"]

EXPOSE 8080

CMD ["/opt/manager-server/ManagerServer","--urls","http://*:8080","--path","/data"]
