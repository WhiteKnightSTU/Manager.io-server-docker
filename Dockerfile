FROM debian:bullseye-slim

ENV ASPNETCORE_URLS=http://+:8080
ENV DOTNET_RUNNING_IN_CONTAINER=true

RUN apt-get update && \
    apt-get install -y ca-certificates curl unzip && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/manager-server

RUN curl -L https://github.com/Manager-io/Manager/releases/latest/download/ManagerServer-linux-x64.tar.gz \
    | tar -xz -C /opt/manager-server

RUN chmod +x /opt/manager-server/ManagerServer

VOLUME ["/data"]

EXPOSE 8080

CMD ["/opt/manager-server/ManagerServer","-port","8080","-path","/data"]
