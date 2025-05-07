#!/bin/bash

set -e
# Force remove old containers if they exist
for NODE in manager worker1 worker2; do
  if docker ps -a --format '{{.Names}}' | grep -q "$NODE"; then
    echo "🗑 Removing existing container: $NODE"
    docker rm -f "$NODE" >/dev/null
  fi
done

echo "🚀 Starting local Docker Swarm simulation..."

# Create a custom network if it doesn't exist
NETWORK_NAME="swarm-net"
docker network inspect $NETWORK_NAME >/dev/null 2>&1 || \
  docker network create --driver bridge $NETWORK_NAME

# Start manager container
echo "🧠 Starting manager node..."
docker run -d --privileged --name manager --hostname manager \
  --network $NETWORK_NAME \
  --rm \
  swarm-manager

# Wait for manager to be ready
echo "⏳ Waiting for manager to initialize Docker daemon..."
sleep 5

# Init Swarm on manager and grab join token
echo "🔧 Initializing Swarm on manager..."
MANAGER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' manager)
docker exec manager docker swarm init --advertise-addr $MANAGER_IP

JOIN_TOKEN=$(docker exec manager docker swarm join-token -q worker)

# Start worker1
echo "👷 Starting worker1..."
docker run -d --privileged --name worker1 --hostname worker1 \
  --network $NETWORK_NAME \
  --rm \
  swarm-worker1

# Start worker2
echo "👷 Starting worker2..."
docker run -d --privileged --name worker2 --hostname worker2 \
  --network $NETWORK_NAME \
  --rm \
  swarm-worker2

# Wait for Docker daemon inside worker containers
wait_for_docker() {
  local container=$1
  echo "⏳ Waiting for Docker daemon in $container..."
  until docker exec "$container" docker info >/dev/null 2>&1; do
    sleep 1
  done  
  echo "✅ Docker daemon is ready in $container"
}

wait_for_docker worker1
wait_for_docker worker2

# Join workers to swarm
echo "🔗 Adding worker1 to the swarm..."
docker exec worker1 docker swarm join --token $JOIN_TOKEN $MANAGER_IP:2377

echo "🔗 Adding worker2 to the swarm..."
docker exec worker2 docker swarm join --token $JOIN_TOKEN $MANAGER_IP:2377

echo "✅ Local Swarm cluster is up!"
