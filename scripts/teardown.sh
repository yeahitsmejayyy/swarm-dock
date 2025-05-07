#!/bin/bash

set -e

echo "🧹 Tearing down local Docker Swarm simulation..."

# Stop and remove containers
for NODE in manager worker1 worker2; do
  if docker ps -a --format '{{.Names}}' | grep -q "$NODE"; then
    echo "🛑 Stopping $NODE..."
    docker stop $NODE || true
  fi
done

# Remove custom network
if docker network inspect swarm-net >/dev/null 2>&1; then
  echo "🧯 Removing swarm-net network..."
  docker network rm swarm-net || true
fi

# (Optional) Remove images
read -p "🧼 Do you want to delete the swarm images too? [y/N]: " delete_images
if [[ "$delete_images" =~ ^[Yy]$ ]]; then
  for NODE in manager worker1 worker2; do
    docker image rm -f swarm-$NODE || true
  done
fi

echo "✅ Teardown complete."
