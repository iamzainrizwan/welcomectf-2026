# welcomectf-2026

Infrastructure for KCL CyberSoc's WelcomeCTF 2026, a beginner CTF run on Wed 21 Oct 2026: 27 players, 19 challenges, 146 solves in one hour. What happened on the day, incidents included, is in [`docs/writeup.md`](docs/writeup.md).

Challenge sources and flags aren't in this repo, so the challenges can be reused.

## layout

- `ctfd/`: scoreboard box. CTFd + MariaDB + Redis, with Caddy in front for HTTPS. Theme and home page in `theme.css` and `index.html`.
- `docker-compose.chals.yml`: challenge box. One container per service challenge, all read-only with tmpfs, no-new-privileges, pid limits and CPU/memory caps. Expects the challenge sources under `services/`.
- `scripts/`: Azure provisioning, deploy, challenge loading (ctfcli) and theming.

## run it

```
scripts/azure-up.sh                 # 2 x B2s_v2 VMs (board + chals) on an Azure for Students subscription
scripts/deploy.sh board             # CTFd on https://$DOMAIN (point an A record at the board VM)
scripts/deploy.sh chals             # challenges on chals.$DOMAIN
# finish CTFd setup in the browser, then admin > settings > access tokens
scripts/load-challenges.sh <token>  # syncs challenges/*/*/challenge.yml
scripts/theme.py <token>            # pushes the theme and home page
```

`deploy.sh` generates CTFd's secret key and database passwords on the VM; none are stored here. Tear down with `az group delete -n wctf26`, since stopping the VMs from inside still bills.

## credits

Organised and run by Zain and Adelah for KCL CyberSoc.

Challenge authors:

- Matt: vibe coded, The Spectre, Jail, Something Magical, Selfie ([2025 challenges](https://github.com/mattadome/KCL-Welcome-CTF-2025-Challenges))
- mkutay: nextimal
- Krish: Injector, Audio, Encodings, Crack
- Muzamil: Red Shark 1, Red Shark 2
- KCL CyberSoc: bundled, catastrophic, The Shadows, Stringsmith, The Raid Plan, The Runaway Bride, The Engineers' Vault
