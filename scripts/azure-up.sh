#!/usr/bin/env bash
# azure-up.sh: two Ubuntu VMs on the student subscription. board = CTFd, chals = challenge containers.
set -euo pipefail
cd "$(dirname "$0")"
RG=${RG:-wctf26}
LOC=${LOC:-belgiumcentral}
SIZE=${SIZE:-Standard_B2s_v2}
KEY=${KEY:-$HOME/.ssh/id_ed25519_welcomectf}
[ -f "$KEY" ] || ssh-keygen -t ed25519 -N '' -f "$KEY" -C welcomectf-2026

az account set -s "${SUB:-Azure for Students}"
az account show --query name -o tsv
az group create -n "$RG" -l "$LOC" -o none
for vm in board chals; do
  az vm create -g "$RG" -n "wctf-$vm" --image Ubuntu2404 --size "$SIZE" \
    --admin-username azureuser --ssh-key-values "$KEY.pub" \
    --public-ip-sku Standard --public-ip-address-dns-name "kclwctf26-$vm" \
    --custom-data cloud-init.yml --os-disk-size-gb 32 -o none
done
az vm open-port -g "$RG" -n wctf-board --port 80,443 --priority 900 -o none
az vm open-port -g "$RG" -n wctf-chals --port 1337,7681,8001-8005 --priority 900 -o none
for vm in board chals; do
  echo "wctf-$vm: kclwctf26-$vm.$LOC.cloudapp.azure.com"
done
