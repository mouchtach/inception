FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    procps \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN curl -fsSL "https://github.com/portainer/portainer/releases/download/2.39.1/portainer-2.39.1-linux-amd64.tar.gz" -o /tmp/portainer.tar.gz \
    && tar -xzf /tmp/portainer.tar.gz -C /app --strip-components=1 \
    && rm -f /tmp/portainer.tar.gz \
    && chmod +x /app/portainer

ENTRYPOINT ["./portainer"]