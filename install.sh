#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DOTFILES_DIR="$REPO_DIR/dotfiles"
DRY_RUN=false

case "${1:-}" in
  --dry-run) DRY_RUN=true ;;
  "") ;;
  *) echo "Usage: $0 [--dry-run]" >&2; exit 1 ;;
esac
if [ "$#" -gt 1 ]; then
  echo "Usage: $0 [--dry-run]" >&2
  exit 1
fi

if [ "$(uname -s)" != Darwin ]; then
  echo "This installer is for macOS." >&2
  exit 1
fi

run() {
  if "$DRY_RUN"; then
    printf 'Would run:'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

if [ -x /opt/homebrew/bin/brew ]; then
  BREW=/opt/homebrew/bin/brew
elif [ -x /usr/local/bin/brew ]; then
  BREW=/usr/local/bin/brew
elif command -v brew >/dev/null 2>&1; then
  BREW="$(command -v brew)"
else
  echo "Install Homebrew first: https://brew.sh" >&2
  exit 1
fi
BREW_PREFIX="$("$BREW" --prefix)"
export PATH="$BREW_PREFIX/bin:$BREW_PREFIX/sbin:$PATH"

# These are the tools used by the current shell and prompt.
if ! command -v oh-my-posh >/dev/null 2>&1; then
  run "$BREW" install jandedobbeleer/oh-my-posh/oh-my-posh
fi
if ! command -v rbenv >/dev/null 2>&1; then
  run "$BREW" install rbenv
fi

missing_formulae=()
for formula in fzf zoxide ripgrep fd bat zsh-autosuggestions zsh-syntax-highlighting; do
  if ! "$BREW" list --versions "$formula" >/dev/null 2>&1; then
    missing_formulae+=("$formula")
  fi
done
if [ "${#missing_formulae[@]}" -gt 0 ]; then
  run "$BREW" install "${missing_formulae[@]}"
fi

if [ ! -f "$HOME/Library/Fonts/HackNerdFont-Regular.ttf" ] && \
   [ ! -f /Library/Fonts/HackNerdFont-Regular.ttf ]; then
  run "$BREW" install --cask font-hack-nerd-font
fi

BACKUP_DIR=""
backup_file() {
  local destination="$1"
  if [ -z "$BACKUP_DIR" ]; then
    mkdir -p "$HOME/.dotfiles-backup"
    BACKUP_DIR="$(mktemp -d "$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S).XXXXXX")"
  fi
  mv "$destination" "$BACKUP_DIR/$(basename "$destination")"
}

link_file() {
  local source="$1" destination="$2"
  if [ -L "$destination" ] && [ "$destination" -ef "$source" ]; then
    printf 'Already linked: %s\n' "$destination"
    return
  fi
  if "$DRY_RUN"; then
    if [ -e "$destination" ] || [ -L "$destination" ]; then
      printf 'Would back up: %s\n' "$destination"
    fi
    printf 'Would link: %s -> %s\n' "$destination" "$source"
    return
  fi
  if [ -e "$destination" ] || [ -L "$destination" ]; then
    backup_file "$destination"
  fi
  mkdir -p "$(dirname "$destination")"
  ln -s "$source" "$destination"
  printf 'Linked: %s\n' "$destination"
}

# Retire only links created by this checkout's old installer.
for name in .zshenv .irbrc .gemrc; do
  case "$name" in
    .zshenv) old_source="$DOTFILES_DIR/zsh/env" ;;
    .irbrc) old_source="$DOTFILES_DIR/irbrc" ;;
    .gemrc) old_source="$DOTFILES_DIR/gemrc" ;;
  esac
  destination="$HOME/$name"
  if [ -L "$destination" ] && [ "$destination" -ef "$old_source" ]; then
    if "$DRY_RUN"; then
      printf 'Would back up and retire: %s\n' "$destination"
    else
      backup_file "$destination"
      printf 'Retired: %s\n' "$destination"
    fi
  fi
done

link_file "$DOTFILES_DIR/zprofile" "$HOME/.zprofile"
link_file "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/zsh/aliases" "$HOME/.zsh_aliases"
link_file "$DOTFILES_DIR/oh-my-posh/marcduiker.omp.json" "$HOME/.config/oh-my-posh/marcduiker.omp.json"
link_file "$DOTFILES_DIR/dotvim/.vim" "$HOME/.vim"
link_file "$DOTFILES_DIR/dotvim/.vimrc" "$HOME/.vimrc"
link_file "$DOTFILES_DIR/vimrc.local" "$HOME/.vimrc.local"
link_file "$DOTFILES_DIR/gvimrc" "$HOME/.gvimrc"
run mkdir -p "$HOME/.vim-tmp"

GLOBAL_RUBY_VERSION=4.0.7
if ! rbenv prefix "$GLOBAL_RUBY_VERSION" >/dev/null 2>&1; then
  # ruby-build only knows Ruby versions released before its own release.
  if ! ruby-build --definitions 2>/dev/null | grep -qx "$GLOBAL_RUBY_VERSION"; then
    run "$BREW" upgrade ruby-build
  fi
  run rbenv install "$GLOBAL_RUBY_VERSION"
fi
run rbenv global "$GLOBAL_RUBY_VERSION"
# A .ruby-version in the current directory would otherwise override the global version.
run env RBENV_VERSION="$GLOBAL_RUBY_VERSION" rbenv exec gem update bundler

# Check a clean login shell so an rbenv PATH inherited from this terminal can't hide a broken zshrc.
if ! "$DRY_RUN"; then
  login_ruby="$(env -i HOME="$HOME" USER="$USER" TERM="${TERM:-xterm-256color}" \
    /bin/zsh -lic 'command -v ruby' 2>/dev/null </dev/null | tail -n 1)"
  if [ "$login_ruby" != "$(rbenv root)/shims/ruby" ]; then
    printf 'New zsh shells use %s instead of rbenv'\''s Ruby. Check PATH in ~/.zshrc.\n' "${login_ruby:-no ruby}" >&2
    exit 1
  fi
  printf 'Global Ruby: %s via %s\n' "$(rbenv global)" "$login_ruby"
fi

# Match the font in this Mac's default Terminal profile.
run osascript \
  -e 'tell application "Terminal"' \
  -e 'set font name of settings set "Basic" to "Hack Nerd Font"' \
  -e 'set font size of settings set "Basic" to 13' \
  -e 'set default settings to settings set "Basic"' \
  -e 'set startup settings to settings set "Basic"' \
  -e 'end tell'

if [ -n "$BACKUP_DIR" ]; then
  printf 'Previous files saved in: %s\n' "$BACKUP_DIR"
fi
if [ ! -s "$HOME/.nvm/nvm.sh" ]; then
  echo "NVM is not installed. Follow https://github.com/nvm-sh/nvm#installing-and-updating, then install your Node version."
fi
echo "Node runtimes, global packages, and AI CLIs are not copied by this installer."
echo "Open a new terminal window to load the shell and prompt."
echo "Restart Warp, then select Hack Nerd Font at 13 pt in Settings > Appearance > Text."
echo "To use the saved Oh My Posh prompt in Warp, select the Shell (PS1) input/prompt option."
printf 'Post-install steps and shortcuts: %s/README.md\n' "$REPO_DIR"
