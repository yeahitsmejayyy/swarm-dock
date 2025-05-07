#!/bin/bash

set -e

STACK_NAME="test-stack"
COMPOSE_FILE="compose/docker-compose.yml"

echo "📦 Deploying stack: $STACK_NAME"

# Check that compose file exists
if [ ! -f "$COMPOSE_FILE" ]; then
  echo "❌ Compose file not found at $COMPOSE_FILE"
  exit 1
fi

# Copy docker-compose.yml into the manager container
echo "📁 Copying docker-compose.yml into manager..."
docker cp $COMPOSE_FILE manager:/$STACK_NAME.yml

# Deploy the stack from inside the manager
echo "🚀 Deploying the stack from manager..."
docker exec manager docker stack deploy -c /$STACK_NAME.yml $STACK_NAME

echo "✅ Stack '$STACK_NAME' deployed successfully!"
