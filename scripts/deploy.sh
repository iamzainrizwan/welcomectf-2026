#!/usr/bin/env bash
# deploy.sh board|chals: push the repo to a VM and bring its stack up
set -euo pipefail
cd "$(dirname "$0")/.."
LOC=${LOC:-belgiumcentral}
DOMAIN=${DOMAIN:-kclctf.xyz}
KEY=${KEY:-$HOME/.ssh/id_ed25519_welcomectf}
host="kclwctf26-$1.$LOC.cloudapp.azure.com"
ssh_() { ssh -i "$KEY" -o StrictHostKeyChecking=accept-new "azureuser@$host" "$@"; }
ssh_ 'cloud-init status --wait >/dev/null'
rsync -az --delete -e "ssh -i $KEY" --exclude .git --exclude challenges ./ "azureuser@$host:wctf/"
case $1 in
  board)
    ssh_ "mkdir -p wctf/ctfd/data/uploads && sudo chown 1001:1001 wctf/ctfd/data/uploads"
    ssh_ "cd wctf/ctfd && [ -f .env ] || printf 'SITE=$DOMAIN\nOLD_SITE=$host\nSECRET_KEY=%s\nDB_PASSWORD=%s\nDB_ROOT_PASSWORD=%s\n' \$(openssl rand -hex 32) \$(openssl rand -hex 16) \$(openssl rand -hex 16) > .env; docker compose up -d" ;;
  chals)
    ssh_ "cd wctf && docker compose -f docker-compose.chals.yml up -d --build" ;;
esac
echo "up: $host"
