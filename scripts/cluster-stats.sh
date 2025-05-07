#!/bin/bash

set -e

echo "📊 Gathering Docker container stats for your Swarm nodes..."

NODES=("manager" "worker1" "worker2")

for NODE in "${NODES[@]}"; do
  echo ""
  echo "====================== $NODE ======================"
  
  docker exec "$NODE" sh -c '
    echo "🧠 Host Memory:"
    free -h || top -bn1 | grep "KiB Mem" || echo "Memory info not available"
    
    echo ""
    echo "🐳 Container Stats:"
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"
  '
done
