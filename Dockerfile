FROM mcr.microsoft.com/dotnet/aspnet:8.0

ARG TARGETARCH
ARG MANAGER_VERSION=latest

ENV ASPNETCORE_URLS=http://+:8080 \
    DOTNET_RUNNING_IN_CONTAINER=true

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        chromium \
        fonts-liberation \
        libfontconfig1 \
        libgtk-3-0 \
        libnss3 \
        libgbm1 \
        xdg-utils && \
    rm -rf /var/lib/apt/lists/*

# Older Manager releases sometimes need this
RUN sed -i 's/DEFAULT@SECLEVEL=2/DEFAULT@SECLEVEL=1/g' \
    /etc/ssl/openssl.cnf || true

WORKDIR /opt/manager

RUN if [ "$TARGETARCH" = "arm64" ]; then \
        ARCH=arm64; \
    else \
        ARCH=x64; \
    fi && \
    if [ "$MANAGER_VERSION" = "latest" ]; then \
        URL="https://github.com/Manager-io/Manager/releases/latest/download/ManagerServer-linux-${ARCH}.tar.gz"; \
    else \
        URL="https://github.com/Manager-io/Manager/releases/download/${MANAGER_VERSION}/ManagerServer-linux-${ARCH}.tar.gz"; \
    fi && \
    curl -L "$URL" | tar -xz

RUN chmod +x /opt/manager/ManagerServer

RUN useradd -r -u 1000 manager && \
    mkdir -p /data && \
    chown -R manager:manager /opt/manager /data

USER manager

VOLUME ["/data"]

EXPOSE 8080

HEALTHCHECK CMD curl -fs http://localhost:8080/ || exit 1

CMD ["/opt/manager/ManagerServer","-port","8080","-path","/data"]
