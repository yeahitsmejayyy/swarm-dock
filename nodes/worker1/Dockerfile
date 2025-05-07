# nodes/worker1/Dockerfile (same as worker2)
FROM docker:28.1-dind

RUN apk add --no-cache bash curl iputils

ENV DOCKER_TLS_CERTDIR=""

CMD ["dockerd-entrypoint.sh"]
