# Setup — three levels

The skill works at every level. Each level makes more of the market readable, and the
run's `source_coverage` table shows you which channels were actually reached.

| Level | You install | The census can read directly | Still out of reach |
|---|---|---|---|
| **L0** | the skill only | search results, pages WebFetch can open, manufacturer pages that allow it | Reddit thread bodies, Amazon review text, many bot-protected storefronts → tagged `[UNVERIFIED]`, listed under blind spots |
| **L1** | + `setup/mcp.json` (two Playwright MCP servers) | manufacturer product listings, public Reddit threads via `old.reddit.com`, YouTube pages, most review sites | Amazon verified-purchase review text (login-walled) |
| **L2** | + sign in once in the headed browser | everything above plus Amazon reviews and logged-in Reddit; `community` and `verified_purchase` can be marked COVERED | sites that block automation outright |

## L0 — skill only

```bash
git clone https://github.com/doriru89/shop-skill.git
./shop-skill/install.sh            # into the current project
./shop-skill/install.sh --user     # or into ~/.claude/skills for every project
```

Open Claude Code in the project and type `/shop <what you want to buy>`. Claude Code will
ask permission for WebSearch and WebFetch calls as they happen; answer "don't ask again"
or add the rules from `setup/settings.json` to your `.claude/settings.local.json`.

## L1 — Playwright MCP

```bash
./shop-skill/install.sh --browser
```

That writes two files into the project, only if they do not already exist (otherwise it
prints what to merge):

| File | Contents |
|---|---|
| `.mcp.json` | two MCP servers from `setup/mcp.json`: `browser` (headed, persistent profile in `~/.shop-skill/browser-profile`) and `browser-headless` (isolated, throwaway profile) |
| `.claude/settings.local.json` | the permission rules from `setup/settings.json` so browser, search and `curl -I` calls do not prompt every time |

Requirements: Node.js 18+ and `npx` on your PATH. The first start downloads
`@playwright/mcp` and a Chromium build; allow a minute.

Verify: start Claude Code in the project. It asks once to approve the project's MCP
servers (`.mcp.json` is project-scoped, so Claude Code confirms it on first use). Then
type `/mcp` and check that `browser` and `browser-headless` show as connected.

Why two servers: the census reads most pages in the headless one (fast, no window, nothing
persists). The headed one exists for sites where your own login matters, and so you can
watch what the skill is doing on a page when you want to.

## L2 — sign in once

Ask Claude Code to open `reddit.com` and `amazon.com` in the `browser` server
("open amazon.com in the headed browser and wait"). A Chrome window appears. Sign in
yourself, in that window. Close nothing; tell Claude Code you are done.

The profile under `~/.shop-skill/browser-profile` keeps the session, so later runs read
review text and threads as you. The skill never types credentials and never asks for them.

That folder contains your cookies. It lives in your home directory, outside any
repository, and nothing in this repo reads it except the browser process.

## Optional: a stealth browser

Some storefronts and review sites detect Playwright and serve a block page. A drop-in
alternative is `patchright-mcp`, a fork of Microsoft's Playwright MCP server that uses the
Patchright patched Chromium to avoid common automation fingerprints
(https://github.com/Kaliiiiiiiiii-Vinyzu/patchright-mcp, Apache-2.0, not affiliated with
this project). To use it, add a third server to `.mcp.json`:

```json
"browser-stealth": {
  "command": "npx",
  "args": ["-y", "patchright-mcp@latest", "--browser", "chrome",
           "--user-data-dir", "${HOME}/.shop-skill/browser-profile-stealth"]
}
```

and allow `mcp__browser-stealth__*` in settings. Two things to know before you do:
automated access may be against a site's terms of service, and anti-detection does not
cover IP reputation or behavioural models, so a block can still happen. The skill treats a
block as a coverage gap and reports it; it does not escalate.

## Pinning versions

`@latest` keeps you current. If you want reproducible behaviour, pin:
`@playwright/mcp@0.0.76` is the version this skill was developed against.

## Uninstall

Delete `.claude/skills/shop` (or `~/.claude/skills/shop`), the two `browser*` entries in
`.mcp.json`, the rules you added to settings, and `~/.shop-skill/` if you want the browser
profile gone.
