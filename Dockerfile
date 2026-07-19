FROM cronet/manager.io:latest

USER root

RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

RUN rm -rf /opt/manager-server/* && \
    curl -L https://github.com/Manager-io/Manager/releases/latest/download/ManagerServer-linux-x64.tar.gz \
    | tar -xz -C /opt/manager-server

RUN chmod +x /opt/manager-server/ManagerServer

USER root
