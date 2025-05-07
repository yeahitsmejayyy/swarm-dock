#!/bin/bash

# Ensure script exits on first error
set -e

echo "🔨 Building Swarm node images..."

# Define paths
NODES_DIR="./nodes"

# Loop through each node directory and build image
for NODE in manager worker1 worker2; do
  echo "📦 Building image for $NODE..."
  docker build -t swarm-$NODE $NODES_DIR/$NODE
done

echo "✅ All node images built successfully!"
