#!/bin/zsh
# Links Claude Code and Codex instruction files and skills to this repo.
# Safe to re-run. Existing symlinks are replaced; real files or folders are
# moved to ~/.dotfiles-backup/<timestamp>/ first.
set -euo pipefail

REPO="${0:A:h}"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
BACKED_UP=0

link() {
  local source="$REPO/$1" target="$2"
  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    return
  fi
  if [[ -L "$target" ]]; then
    rm "$target"
  elif [[ -e "$target" ]]; then
    local backup_path="$BACKUP/${target#$HOME/}"
    mkdir -p "$(dirname "$backup_path")"
    mv "$target" "$backup_path"
    echo "backed up $target"
    BACKED_UP=1
  fi
  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"
  echo "linked $target -> $source"
}

link AGENTS.md            "$HOME/.codex/AGENTS.md"
link CLAUDE.md            "$HOME/.claude/CLAUDE.md"
link workspace/AGENTS.md  "$HOME/workspace/AGENTS.md"
link workspace/CLAUDE.md  "$HOME/workspace/CLAUDE.md"
link skills               "$HOME/.agents/skills"
link skills               "$HOME/.claude/skills"

for codex_home in "$HOME"/.openclaw/agents/*/agent/codex-home(N/); do
  link AGENTS.md "$codex_home/AGENTS.md"
done

# RocketSim ships its skill inside the app bundle.
ROCKETSIM_SKILL="/Applications/RocketSim.app/Contents/Resources/Agent-Skill/rocketsim"
if [[ -d "$ROCKETSIM_SKILL" ]]; then
  ln -sfn "$ROCKETSIM_SKILL" "$REPO/skills/rocketsim"
fi

(( BACKED_UP )) && echo "backups in $BACKUP"
exit 0
