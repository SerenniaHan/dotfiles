# dotfiles

Personal configuration for macOS and Windows. Each tool lives in its own
directory and is linked into place with a symlink.

## What's Inside

| Directory | Tool | Platform |
| --- | --- | --- |
| [zsh/](zsh/) | Zsh, no framework (plugins from Homebrew) | macOS |
| [starship/](starship/) | [starship](https://starship.rs/) prompt, shared by all shells | macOS, Windows |
| [nvim/](nvim/) | Neovim, plugins managed by lazy.nvim | macOS, Windows |
| [lazygit/](lazygit/) | Lazygit with Catppuccin Macchiato theme | macOS, Windows |
| [ghostty/](ghostty/) | [Ghostty](https://ghostty.org/) terminal, FiraCode Nerd Font | macOS |

## Setup

### 1. Clone

```bash
git clone https://github.com/SerenniaHan/dotfiles.git ~/repos/dotfiles
```

### 2. Install requirements

- A [Nerd Font](https://www.nerdfonts.com/) set as the terminal font
  (e.g. FiraCode Nerd Font)
- [starship](https://starship.rs/), [Neovim](https://neovim.io/) >= 0.9,
  [Lazygit](https://github.com/jesseduffield/lazygit),
  [ripgrep](https://github.com/BurntSushi/ripgrep)

```bash
# macOS
brew install starship neovim lazygit ripgrep
brew install --cask ghostty font-fira-code-nerd-font
```

```powershell
# Windows
winget install Starship.Starship Neovim.Neovim JesseDuffield.lazygit BurntSushi.ripgrep.MSVC
```

On macOS, also install the zsh plugins: `brew install zsh-autosuggestions zsh-syntax-highlighting`.

### 3. Create symlinks

If a target already exists, back it up first.

| Source | macOS target | Windows target |
| --- | --- | --- |
| `zsh/.zshrc` | `~/.zshrc` | — |
| `starship/starship.toml` | `~/.config/starship.toml` | `%USERPROFILE%\.config\starship.toml` |
| `nvim/` | `~/.config/nvim` | `%LOCALAPPDATA%\nvim` |
| `lazygit/config.yml` | `~/Library/Application Support/lazygit/config.yml` | `%APPDATA%\lazygit\config.yml` |
| `ghostty/config.ghostty` | `~/.config/ghostty/config.ghostty` | — |

#### macOS

```bash
DOTFILES=~/repos/dotfiles
mkdir -p ~/.config/ghostty ~/Library/Application\ Support/lazygit
ln -s $DOTFILES/zsh/.zshrc ~/.zshrc
ln -s $DOTFILES/starship/starship.toml ~/.config/starship.toml
ln -s $DOTFILES/nvim ~/.config/nvim
ln -s $DOTFILES/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml
ln -s $DOTFILES/ghostty/config.ghostty ~/.config/ghostty/config.ghostty
```

#### Windows (PowerShell)

Creating symlinks requires Developer Mode (Settings → System → For developers)
or an Administrator shell.

```powershell
$Dotfiles = "$HOME\repos\dotfiles"
New-Item -ItemType Directory -Force "$HOME\.config", "$env:APPDATA\lazygit" | Out-Null
New-Item -ItemType SymbolicLink -Path "$HOME\.config\starship.toml" -Target "$Dotfiles\starship\starship.toml"
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim" -Target "$Dotfiles\nvim"
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\lazygit\config.yml" -Target "$Dotfiles\lazygit\config.yml"
```

## Machine-Specific Config

Settings that belong to one machine only, such as work aliases, tokens or
local paths, go in files outside this repository so they are never committed.
On macOS that is `~/.zshrc.local`; see [zsh/](zsh/).
