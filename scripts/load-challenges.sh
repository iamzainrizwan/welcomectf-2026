#!/usr/bin/env bash
# load-challenges.sh TOKEN: install/sync every challenges/*/*/challenge.yml into CTFd.
# TOKEN: CTFd admin > settings > access tokens.
set -euo pipefail
cd "$(dirname "$0")/.."
LOC=${LOC:-belgiumcentral}
DOMAIN=${DOMAIN:-kclctf.xyz}
URL="https://$DOMAIN"
CHALS="chals.$DOMAIN"
work=$(mktemp -d); cp -r challenges "$work/"; cd "$work"
grep -rl CHALS_HOST challenges | xargs -r sed -i "s/CHALS_HOST/$CHALS/g"
mkdir -p .ctf; printf '[config]\nurl = %s\naccess_token = %s\n\n[challenges]\n' "$URL" "$1" > .ctf/config
find challenges -name challenge.yml | while read -r y; do
  d=$(dirname "$y")
  ctf challenge install "$d" >/dev/null || { echo "FAIL $d"; continue; }
  echo "ok  $d"
done
