# Mac dotfiles

The shell files were refreshed from Adam's current Mac on 2026-10-05. Vim's existing configuration is retained for the new Mac Mini.

## Install

Install [Homebrew](https://brew.sh) first, then run from this checkout:

```sh
./install.sh --dry-run
./install.sh
```

The installer also works when invoked by absolute path from another directory. Keep the checkout in place because the installed files are symlinks. Existing destination files, directories, and symlinks are moved into a unique directory under `~/.dotfiles-backup/`. Repeat runs skip links that already point to this checkout. `dotfiles/install.sh` forwards to the root installer; the old destructive Vim-only installer is retired.

The installer installs missing Oh My Posh, rbenv, Hack Nerd Font, fzf, zoxide, ripgrep, fd, bat, zsh-autosuggestions, and zsh-syntax-highlighting through Homebrew. It sets Apple Terminal's `Basic` profile to Hack Nerd Font at 13 pt and makes it the default/startup profile, matching the current Mac. macOS may request permission to control Terminal. Open a new window after installation. Other terminal apps need their font selected separately; [Oh My Posh documents the font requirement](https://ohmyposh.dev/docs/installation/fonts).

Oh My Posh, rbenv, and the font reproduce the existing setup. [Oh My Posh](https://ohmyposh.dev/docs/installation/macos) is actively maintained and MIT licensed; [rbenv](https://github.com/rbenv/rbenv) is MIT licensed; [Hack Nerd Font](https://formulae.brew.sh/cask/font-hack-nerd-font) is distributed by the maintained Nerd Fonts project under its included font licenses. Installing these through Homebrew avoids a separate download-and-execute prompt installer.

The new tools come from their official maintained projects through Homebrew. Each adds a focused function without a shell framework or a separate plugin updater:

| Tool | Purpose | License |
| --- | --- | --- |
| [fzf](https://github.com/junegunn/fzf) | Interactive selection and history/file search | MIT |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Directory navigation based on prior visits | MIT |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Code/text search respecting ignore files | Unlicense |
| [fd](https://github.com/sharkdp/fd) | Convenient filename searches | MIT or Apache-2.0 |
| [bat](https://github.com/sharkdp/bat) | File viewing with syntax highlighting | MIT or Apache-2.0 |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | History suggestions in other terminals | MIT |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | Command highlighting in other terminals | BSD-3-Clause |

## Warp and other terminals

The shell keeps 100,000 history entries in memory and saves 50,000 to `~/.zsh_history`, with timestamps and duplicate handling. Commands are appended as they are entered. Sessions retain their own live history; use `fc -RI` to import commands saved by another session when needed.

`TERM_PROGRAM=WarpTerminal` controls the integrations:

| Feature | Warp | Terminal, iTerm2, and other terminals |
| --- | --- | --- |
| Oh My Posh | Available through Warp's Shell (PS1) prompt setting | Enabled |
| `z` / `zi` navigation and directory tracking | Enabled, with zoxide's editor widgets skipped | Enabled, including zoxide completions |
| Shell history settings | Enabled | Enabled |
| fzf command-line tool | Available | Available |
| fzf shell bindings and completions | Skipped to preserve Warp search shortcuts | Enabled: Ctrl-R history, Ctrl-T files, Option-C directories |
| zsh completion menus | Warp's native menus | Enabled, with case-insensitive matching |
| Autosuggestions and syntax highlighting | Warp's native features | Shell plugins enabled |
| `rg`, `fd`, `bat` | Available as regular commands | Available as regular commands |

Warp's [Command Search](https://docs.warp.dev/terminal/entry/command-search) searches more than shell history, and shell bindings can take precedence over its shortcuts. Its [compatibility notes](https://docs.warp.dev/support-and-community/troubleshooting-and-support/known-issues) also flag completion plugins as possible conflicts. Zoxide is initialized with its directory-change hook in both environments; inside Warp, ZLE is disabled only within an anonymous function during initialization and restored afterward, so zoxide cannot register its input-editor widgets.

## After running install.sh on the Mini

1. **Quit and reopen Warp.** This loads the linked shell configuration and refreshes its font list. Use zsh as the startup shell; if the account uses another shell, select `/bin/zsh` in Warp's startup-shell settings.
2. **Set Warp's font.** In Settings > Appearance > Text, select **Hack Nerd Font**, regular, **13 pt**. Enable "View all available system fonts" if necessary. The script configures Apple Terminal automatically; Warp's font is a separate UI preference. [Warp font settings](https://docs.warp.dev/terminal/appearance/text-fonts-cursor)
3. **Choose your Warp prompt.** To display the saved Oh My Posh theme, choose **Shell (PS1)** under Settings > Appearance > Input/prompt. Warp lists Oh My Posh as supported. Warp's native prompt can also be used. [Warp prompt settings](https://docs.warp.dev/terminal/appearance/prompt)
4. **Check the tools and native search.** Run `command -v fzf zoxide rg fd bat`, then try Warp's Ctrl-R search and Tab completion. Visit a project with `cd` once, leave it, and run `z` followed by part of its directory name. `zi` opens an interactive directory chooser using fzf.
5. **Check a fallback terminal.** Open a new Apple Terminal window and try Ctrl-R, Ctrl-T, Tab, and accepting a history suggestion with the right arrow. Option-C may require setting the Option key to act as Meta in that terminal's profile settings.

For Node development, install NVM if it is not already present. Use the upstream installer's `PROFILE=/dev/null` option so it preserves the repo-managed lazy initialization:

```sh
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh -o /tmp/install-nvm.sh
PROFILE=/dev/null bash /tmp/install-nvm.sh
source "$HOME/.nvm/nvm.sh"
nvm install --lts
nvm alias default 'lts/*'
```

In a project with `.nvmrc`, run `nvm install` and `nvm use` to select its required version. [NVM installation and usage](https://github.com/nvm-sh/nvm#installing-and-updating)

Xcode, project Ruby versions/gems, global Node packages, AI CLIs, and Warp account/AI connections remain separate setup. Install the runtimes required by each project's version files, reinstall the global tools you use, and sign in/connect accounts in their respective apps. No additional setup is required for the seven tools installed above.

## Installed files

| Repository file | Destination | Source of configuration |
| --- | --- | --- |
| `dotfiles/zshrc` | `~/.zshrc` | Current Mac, with portable paths and guards for missing tools |
| `dotfiles/zprofile` | `~/.zprofile` | Current Mac, with `$HOME` and both Homebrew prefixes |
| `dotfiles/zsh/aliases` | `~/.zsh_aliases` | Exact current aliases |
| `dotfiles/oh-my-posh/marcduiker.omp.json` | `~/.config/oh-my-posh/marcduiker.omp.json` | Exact theme loaded by the current Mac's Oh My Posh 25.18.0 |
| `dotfiles/dotvim/.vim` | `~/.vim` | Retained Vim plugins, colors, and runtime |
| `dotfiles/dotvim/.vimrc` | `~/.vimrc` | Retained settings; `nocompatible` now precedes Pathogen initialization |
| `dotfiles/vimrc.local` | `~/.vimrc.local` | Retained local Vim settings |
| `dotfiles/gvimrc` | `~/.gvimrc` | Retained GUI Vim settings |

The installer creates `~/.vim-tmp` for Vim swap/backup files. The prompt keeps the current colors, path/Git/status segments, and blank line before each prompt. The theme is stored in the repo so a Homebrew theme update cannot replace it. Its original MIT notice is in `dotfiles/oh-my-posh/COPYING`.

## Old files and remaining setup

- The current Mac has no `~/.zshenv`, `~/.irbrc`, or `~/.gemrc`; these are no longer installed. Their repository sources and unused `zsh/config`/`zsh/colors` remain as historical files. Old links to this checkout's `.zshenv`, `.irbrc`, and `.gemrc` are backed up and retired. Independently managed files are preserved; inspect an existing `.zshenv` when upgrading from another checkout because it may still set the obsolete `CC=llvm-gcc` and initialize NVM eagerly.
- NVM and language runtimes are separate setup. Install NVM using its [upstream instructions](https://github.com/nvm-sh/nvm#installing-and-updating), then install the desired Node version. The current Mac has Node 23.6.1 and Ruby 3.2.2; these versions, global npm packages, gems, and AI CLIs are not copied. NVM remains lazy loaded when `~/.nvm/nvm.sh` exists. Homebrew's NVM installation is [unsupported by NVM upstream](https://formulae.brew.sh/formula/nvm).
- The retained Vim configuration starts with native system Vim on Apple Silicon. Command-T requires Ruby-enabled Vim and its committed native extension is Intel-only; ConqueTerm requires Python-enabled Vim. These plugins need separate modernization to work. The `Ack` and tag-generation shortcuts also require `ack` and compatible `ctags`, while Ruby mappings require Ruby/Bundler. Those tools are not installed automatically.
- The copied `cdx` helper still selects `gpt-5-codex` and an experimental config setting; `codex_continue` still uses `experimental_resume`. Review those existing helpers against the CLI version installed on the Mini.
- The copied `yolo` alias runs Claude with `--dangerously-skip-permissions`, bypassing its permission checks.

## Verification

Checked shell syntax, dry-run behavior, fresh installation, backups, broken symlinks, directory replacement, repeat installation, dependency commands, and checkout/home paths containing spaces using temporary homes and mocked package/Terminal commands. The saved theme produces identical ANSI prompt output to the currently installed theme for success and failure status using Oh My Posh 25.18.0. Isolated zsh startup and lazy NVM initialization pass. The retained Vim configuration starts successfully with native system Vim. The Terminal settings AppleScript compiles successfully.

The new shell integrations were exercised in isolated pseudo-terminals using official fzf 0.74.4 and zoxide 0.10.0 releases plus actual plugin sources. Warp-mode initialization preserves Ctrl-R/Ctrl-T/Tab bindings and skips shell editor plugins; directory recording and `z` navigation work, including paths with spaces. Other-terminal mode loads completion menus, fzf widgets, suggestions, and highlighting. Repeated sourcing leaves one zoxide directory hook. Computer Use blocks access to the Warp app, so the Warp GUI and final prompt appearance on the Mini remain unverified; use the post-install checks above.
