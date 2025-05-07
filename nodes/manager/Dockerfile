# nodes/manager/Dockerfile
FROM docker:20.10-dind

# Install basic tools
RUN apk add --no-cache bash curl iputils

# Copy Docker CLI tools (optional enhancement)
RUN curl -L https://github.com/docker/compose/releases/download/v2.24.6/docker-compose-linux-x86_64 \
    -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Set environment variable to allow insecure communication (for DinD use)
ENV DOCKER_TLS_CERTDIR=""

# Expose Docker daemon port (if we want to interact with it externally)
EXPOSE 2375

CMD ["dockerd-entrypoint.sh"]
