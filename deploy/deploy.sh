#!/bin/bash
# Deploiement de la stack sur les serveurs

SERVERS="192.168.10.11 192.168.10.12"

for s in $SERVERS; do
  scp -o StrictHostKeyChecking=no docker-compose.yml root@$s:/opt/stack/
  ssh -o StrictHostKeyChecking=no root@$s "chmod -R 777 /opt/stack"
  ssh -o StrictHostKeyChecking=no root@$s "cd /opt/stack && docker compose down -v && docker compose pull && docker compose up -d"
done

echo "Deploiement OK"
