#!/bin/bash

set -e

REDIS_PASSWORD=$(cat /run/secrets/redis_password)

echo "Starting Redis with secret..."

exec redis-server /etc/redis/redis.conf --requirepass "$REDIS_PASSWORD"