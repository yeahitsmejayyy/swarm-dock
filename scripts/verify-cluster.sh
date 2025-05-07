#!/bin/bash

set -e

echo "🔎 Verifying Docker Swarm cluster s..."

echo "🧠 Nodes:"
docker exec manager docker node ls

echo ""
echo "📦 Services:"
docker exec manager docker service ls

echo ""
echo "🐳 Running containers on each node:"
for NODE in manager worker1 worker2; do
  echo "--- $NODE ---"
  docker exec $NODE docker ps --formatable {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
  echo ""
done
