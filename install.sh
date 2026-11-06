#!/usr/bin/env sh
# Install the shop skill into a Claude Code project (default: current directory)
# or into your user-level skills with --user.
#
#   ./install.sh                 # -> ./.claude/skills/shop
#   ./install.sh /path/to/proj   # -> /path/to/proj/.claude/skills/shop
#   ./install.sh --user          # -> ~/.claude/skills/shop
set -eu
here="$(cd "$(dirname "$0")" && pwd)"
if [ "${1:-}" = "--user" ]; then
  dest="$HOME/.claude/skills/shop"
else
  dest="${1:-.}/.claude/skills/shop"
fi
mkdir -p "$dest"
cp -R "$here/skills/shop/." "$dest/"
echo "Installed shop skill to $dest"
echo "Open Claude Code there and type: /shop <what you want to buy>"
