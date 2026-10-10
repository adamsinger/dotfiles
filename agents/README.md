# Agent config

Shared instructions and skills for Claude Code and Codex. `install.sh` symlinks these files into place, so edits made from either tool land in this repo.

| Repo path | Linked from |
|---|---|
| `AGENTS.md` | `~/.codex/AGENTS.md` and existing `~/.openclaw/agents/*/agent/codex-home/AGENTS.md` |
| `CLAUDE.md` (imports `~/.codex/AGENTS.md`) | `~/.claude/CLAUDE.md` |
| `workspace/AGENTS.md` | `~/workspace/AGENTS.md` |
| `workspace/CLAUDE.md` (imports `AGENTS.md`) | `~/workspace/CLAUDE.md` |
| `skills/` | `~/.agents/skills` (Codex) and `~/.claude/skills` (Claude Code) |

## New machine

```sh
git clone <remote> ~/workspace/dotfiles
~/workspace/dotfiles/agents/install.sh
```

This script is separate from the top-level `install.sh`. The repo can live anywhere; the links point to wherever the script runs from.

Plugins are not stored here. Install them from each tool's marketplace.

OpenClaw's isolated Codex homes use their own global `AGENTS.md`. The installer links it into existing homes; skills are already discovered through `~/.agents/skills`.

## Skills

Each skill lives directly under `skills/<name>/SKILL.md`. Claude Code does not find skills nested one level deeper.

| Skill | Source |
|---|---|
| adopt-c-bounds-safety, app-intents-specialist, app-intents-whats-new-27, audit-xcode-security-settings, building-document-based-swiftui-applications, device-interaction, modernize-tests, swiftui-specialist, swiftui-whats-new-27, uikit-app-modernization | Xcode: `xcrun agent skills export --output-dir ~/.agents/skills --replace-existing` |
| rocketsim | Symlink into RocketSim.app, created by `install.sh` (not committed) |
| watch | github.com/bradautomates/claude-video |
| aside-browser, sentry-workflow, swift, swift-concurrency, swiftui-expert-skill, workers-best-practices, wrangler | Copied in; source not recorded |

The Xcode export replaces each exported skill folder and leaves other skills alone. It does not remove a skill Apple stops shipping.
