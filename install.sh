#!/usr/bin/env sh
# Install the shop skill into a Claude Code project.
#
#   ./install.sh                      # skill -> ./.claude/skills/shop
#   ./install.sh /path/to/project     # skill -> that project
#   ./install.sh --user               # skill -> ~/.claude/skills/shop (all projects)
#   ./install.sh [path] --browser     # also write .mcp.json + local permission rules
#                                     # (Playwright MCP servers; see setup/SETUP.md)
set -eu
here="$(cd "$(dirname "$0")" && pwd)"
target="."
user=0
browser=0
for a in "$@"; do
  case "$a" in
    --user) user=1 ;;
    --browser) browser=1 ;;
    -h|--help) sed -n '2,9p' "$0"; exit 0 ;;
    *) target="$a" ;;
  esac
done

if [ "$user" = 1 ]; then
  dest="$HOME/.claude/skills/shop"
else
  dest="$target/.claude/skills/shop"
fi
mkdir -p "$dest"
cp -R "$here/skills/shop/." "$dest/"
echo "skill      -> $dest"

if [ "$browser" = 1 ]; then
  mkdir -p "$HOME/.shop-skill/browser-profile" "$HOME/.shop-skill/output"
  mcp="$target/.mcp.json"
  if [ -f "$mcp" ]; then
    echo ".mcp.json  -> already exists; merge the two servers from $here/setup/mcp.json by hand"
  else
    cp "$here/setup/mcp.json" "$mcp"
    echo ".mcp.json  -> $mcp (browser, browser-headless)"
  fi
  mkdir -p "$target/.claude"
  local_settings="$target/.claude/settings.local.json"
  if [ -f "$local_settings" ]; then
    echo "settings   -> $local_settings already exists; add the rules from $here/setup/settings.json by hand"
  else
    cp "$here/setup/settings.json" "$local_settings"
    echo "settings   -> $local_settings (permission rules)"
  fi
  echo "profile    -> $HOME/.shop-skill/browser-profile (sign in once there; see setup/SETUP.md, L2)"
fi

echo
if [ "$user" = 1 ]; then where="any project"; else where="$target"; fi
echo "Open Claude Code in $where and type: /shop <what you want to buy>"
