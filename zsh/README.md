# zsh

Zsh configuration for macOS. No framework: a single `.zshrc`, two plugins
from Homebrew, and [starship](https://starship.rs/) for the prompt
(see [../starship](../starship)).

## Structure

```text
zsh/
└── .zshrc      # All configuration
```

`.zshrc` is split into sections, loaded in this order:

1. Basic options and history
2. Completion (including git and Homebrew-installed tools)
3. Vi mode
4. Aliases
5. Functions
6. `~/.zshrc.local` (if it exists)
7. starship
8. Plugins (syntax highlighting must load last)

## Features

| Feature | How |
| --- | --- |
| Suggestions from history | [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions), press `→` to accept |
| Command syntax highlighting | [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) |
| Vi keybindings | Built-in `bindkey -v`; beam cursor in insert mode, block in normal mode |
| History prefix search | `↑` / `↓` in insert mode, `k` / `j` in normal mode |
| Case-insensitive menu completion | Built-in `compinit` |

## Aliases and Functions

| Name | Does |
| --- | --- |
| `vim` | `nvim` |
| `zshconfig` / `vimconfig` | Open the zsh / Neovim config |
| `cls` | `clear` |
| `..` / `...` | Go up one / two directories |
| `gorepo` | `cd ~/repos` |
| `g`, `gst`, `ga`, `gc`, `gco`, `gsw`, `gb`, `gd`, `gl`, `gp` | `git`, `status`, `add`, `commit`, `checkout`, `switch`, `branch`, `diff`, `pull`, `push` |
| `gtree` | `git log --oneline` |
| `showstash` | `git stash list` |
| `gitcleanup` | Fetch with prune, then delete local branches whose remote is gone. Uses `git branch -d`, so branches with unmerged commits are kept |

## Installation

### 1. Install plugins and starship

```bash
brew install zsh-autosuggestions zsh-syntax-highlighting starship
```

### 2. Link `.zshrc`

```bash
mv ~/.zshrc ~/.zshrc.backup   # if one exists
ln -s ~/repos/dotfiles/zsh/.zshrc ~/.zshrc
exec zsh
```

## Machine-Specific Config

Put anything that should not be committed (work aliases, tokens, local paths)
in `~/.zshrc.local`. It lives outside the repository, so it can never be
committed by accident. `.zshrc` loads it if it exists.

```bash
echo 'alias gowork="cd ~/repos/work"' >> ~/.zshrc.local
```
