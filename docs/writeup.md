# welcome ctf 2026: writeup

KCL CyberSoc's beginner CTF. Wed 21 Oct 2026, 14:00–16:00, Bush House South 6.03.
Player names are left out; flags and challenge sources aren't in this repo.

## at a glance

| | |
|---|---|
| registered on CTFd | 27 players |
| players who scored | 26, every one of them at least one solve |
| in the room | the registered players plus about 5 who came without registering (estimate, no headcount taken) |
| challenges | 19 across web, forensics, misc, git, pwn, rev, docker |
| solves | 146 correct, 109 incorrect submissions |
| challenges with 0 solves | none, all 19 were solved at least once |
| top score | 1623 points, 15 of 19 solved (a challenge author playing for fun, not eligible for the prize) |
| prize winner | 1215 points: £15 amazon gift card |
| run by | Zain and Adelah, the only two organisers in the room |

## format

- 14:00 briefing: what a CTF is, flag formats, the tools (CyberChef, devtools, hexed.it, Aperi'Solve), rules (computer misuse act, play solo).
- 14:30–15:30 hacking hour. CTFd opened and closed itself. Scoreboard on the projector.
- 15:30 walkthroughs, then the prize.
- Hints in CTFd were all free (19 hints, cost 0).
- Dynamic scoring (decay 15): every challenge starts at a value and drops towards a floor as people solve it. "Classic" challenges, whose flags sit in the public 2025 repo, started at half value.

## results

Median score 336. Solves per player ranged from 1 to 15 (median 5).

**The finish:** the 3rd-placed player solved The Shadows at 15:29:59.6, under half a second before the board closed. Its 86 points took them from 5th to 3rd, three points ahead of 4th. It was the last of four solves in the final ninety seconds.

The top score belonged to a challenge author who played for fun, so the prize went to the next player down, who also took four first bloods (including the first solve of the CTF, at 14:31).

### per challenge

Final value after decay.

| challenge | category | value | solves | wrong |
|---|---|---|---|---|
| vibe coded | web | 50 | 18 | 3 |
| bundled | web | 50 | 17 | 7 |
| nextimal | web | 68 | 13 | 4 |
| Injector | web | 68 | 13 | 1 |
| Audio | forensics (classic) | 37 | 12 | 2 |
| The Raid Plan | git | 78 | 11 | 12 |
| Encodings | misc (classic) | 82 | 10 | 0 |
| The Shadows | misc | 86 | 9 | 9 |
| The Spectre | forensics (classic) | 92 | 7 | 2 |
| The Runaway Bride | git | 276 | 7 | 6 |
| Red Shark 1 | forensics (classic) | 48 | 6 | 1 |
| Jail | pwn | 189 | 6 | 1 |
| Something Magical | misc (classic) | 98 | 4 | 41 |
| Selfie | misc (classic) | 98 | 4 | 7 |
| Stringsmith | rev (classic) | 50 | 3 | 6 |
| catastrophic | web | 199 | 3 | 6 |
| The Engineers' Vault | docker | 100 | 1 | 1 |
| Red Shark 2 | forensics (classic) | 100 | 1 | 0 |
| Crack | forensics (classic) | 150 | 1 | 0 |

What the numbers say:

- **Web carried the beginners.** The four easy browser-only web challenges were the most solved (13–18 each). They are the right on-ramp.
- **Something Magical was the wall:** 41 wrong submissions for 4 solves, more than a third of all wrong submissions in the CTF. Worth checking whether the flag format or the challenge text misled people.
- **The Raid Plan and The Shadows** also drew lots of near misses (12 and 9 wrong), which usually means people found something flag-shaped that wasn't the flag.
- **The hard end held up.** The Engineers' Vault, Red Shark 2 and Crack had one solver each, so the top of the board still had something to separate players.
- **Momentum grew through the hour:** 16 solves in the first ten minutes, peaking at 35 in 15:00–15:10, and still 27 in the last ten minutes, the last of them under a second before close. Nobody ran out of things to try.

## infrastructure

- Two Azure VMs (Standard_B2s_v2, belgiumcentral, because the student subscription only allows a few EU regions), set up with `scripts/azure-up.sh` and cloud-init.
- **Board box:** CTFd 3.7.7 + MariaDB + Redis behind Caddy (automatic HTTPS) on `kclctf.xyz`. Themed to match the posters and slides with `scripts/theme.py`. Four hidden easter-egg flags on the site itself (page source, invisible text, console, robots.txt), worth nothing.
- **Challenge box:** `chals.kclctf.xyz` running Docker Compose. Web challenges on 8001–8005, the jail over `nc` on 1337, and a browser terminal for the jail on 7681 so nobody needed a local netcat. Every container is read-only, with tmpfs, no-new-privileges, pid limits and memory and CPU caps.
- Challenges loaded from ctfcli `challenge.yml` files with `scripts/load-challenges.sh`. The 2025 service challenges were re-flagged for 2026.
- **Kit:** a briefing deck, an organiser run sheet, and a solutions pdf with three hints and a walkthrough per challenge.
- **Morning-of check on eduroam:** every port reachable, so the planned fallback (moving everything behind 443) wasn't needed.

### incidents

1. **Injector returned a 500 on almost every login** for roughly the first quarter of an hour of hacking. The app kept one in-memory SQLite connection on the Flask app object. Flask serves each request on its own thread, and SQLite refuses to use a connection created on another thread (`sqlite3.ProgrammingError: SQLite objects created in a thread can only be used in that same thread`). Fixed by building the two-row DB per request, and redeployed only that container.
2. **Injector returned a 500 on malformed SQL.** Players' half-built injections (an unmatched quote, for example) raised `sqlite3.OperationalError`, which went uncaught. To beginners it looked like the challenge was down. Fixed by catching `sqlite3.Error` and showing `database error: …` on the login page, which is also a fair hint for an easy injection challenge. After this fix the challenge held up for the rest of the hour.
3. **Three test accounts** were left on CTFd from setup and deleted on the day.
4. **One solutions pdf walkthrough** started from the wrong page of a challenge site; a hint was given on the day.

None of the other 18 challenges had problems, and the scoreboard stayed up for the whole event.

## organisation

- **Comms:** an Instagram carousel and stories (an announcement, a "today" story with a countdown, a prize story, a "we're live" story) plus Discord announcements the day before and the morning of.
- **People:** Zain and Adelah ran it, just the two of them: briefing, walking the room, walkthroughs, and the fixes during the event.
- **Budget:** about £25, snacks and drinks plus the gift card.
- **Walkthroughs:** every challenge people asked about was walked through afterwards, rather than only the 0-solve ones the run sheet planned for (there weren't any). The briefing ran too fast.

## next year

- **Test concurrently before the event.** Fire several requests at once at every service. The Injector bug only appears once two requests land on different threads, so a single manual test passes.
- **No challenge should 500 on bad input.** Catch exceptions and show an error the player can act on.
- **Check every solutions pdf against the live site.**
- **Delete test accounts** before registration opens.
- **Slow the briefing down:** the tools slide and the live demo are where beginners need the time.
- **Look at Something Magical's** description and flag format before reusing it.
- **Get a headcount and a feedback form** at the door or with the prize, so next year's writeup has real attendance numbers.
- **More people in the room.** Two organisers covered briefing, hints and live fixes, but a third person on hints would have freed someone to watch the logs.
- **Settle the rules for authors and committee playing** in advance (play for fun, can't win the prize), and say so in the briefing.
- **Tear down the Azure resource group** after the event; stopping the VMs from inside keeps billing.
