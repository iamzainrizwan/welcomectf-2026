#!/usr/bin/env python3
"""theme.py TOKEN: push ctfd/theme.css (as the theme header) and ctfd/index.html (as the home page) to CTFd."""
import json, sys, pathlib, urllib.request
U = "https://kclctf.xyz"
root = pathlib.Path(__file__).resolve().parent.parent / "ctfd"
def api(method, path, body=None):
    req = urllib.request.Request(U + "/api/v1" + path, json.dumps(body).encode() if body is not None else None,
                                 {"Authorization": "Token " + sys.argv[1], "Content-Type": "application/json"}, method=method)
    return json.load(urllib.request.urlopen(req)).get("data")
fonts = ('<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>'
         '<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500;700&family=JetBrains+Mono:wght@800&display=swap" rel="stylesheet">')
# easter egg for anyone who opens the console
CONSOLE = ("<script>console.log('%c welcome ctf ', 'background:#e8322b;color:#0a0a0a;font-weight:700;font-size:16px');"
           "console.log('you opened the console. nice find: KCLCTF{redacted}');</script>")
api("PATCH", "/configs", {"theme_header": fonts + "<style>" + (root / "theme.css").read_text() + "</style>" + CONSOLE,
                          "ctf_name": "welcome ctf 2026"})
index = next(p for p in api("GET", "/pages") if p["route"] == "index")
api("PATCH", f"/pages/{index['id']}", {"content": (root / "index.html").read_text(), "format": "html", "title": "welcome ctf"})
print("theme + index pushed")
