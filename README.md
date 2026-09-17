# dotfiles

Personal configuration for macOS and Windows. Each tool lives in its own
directory and is linked into place with a symlink.

## What's Inside

| Directory | Tool | Platform |
| --- | --- | --- |
| [zsh/](zsh/) | Zsh, no framework (plugins from Homebrew) | macOS |
| [powershell/](powershell/) | PowerShell profile, mirrors the zsh aliases | Windows |
| [starship/](starship/) | [starship](https://starship.rs/) prompt, shared by all shells | macOS, Windows |
| [nvim/](nvim/) | Neovim, plugins managed by lazy.nvim | macOS, Windows |
| [lazygit/](lazygit/) | Lazygit with Catppuccin Macchiato theme | macOS, Windows |
| [ghostty/](ghostty/) | [Ghostty](https://ghostty.org/) terminal, FiraCode Nerd Font | macOS |
| [windows-terminal/](windows-terminal/) | [Windows Terminal](https://github.com/microsoft/terminal), JetBrainsMono Nerd Font | Windows |

The shell configs are deliberately parallel: [zsh/.zshrc](zsh/.zshrc) and
[powershell/Microsoft.PowerShell_profile.ps1](powershell/Microsoft.PowerShell_profile.ps1)
use the same section order and the same alias names, so `gst`, `gorepo` and
`gitcleanup` behave identically on both platforms.

## Setup

### 1. Clone

```bash
git clone https://github.com/SerenniaHan/dotfiles.git ~/repos/dotfiles
```

### 2. Install requirements

- A [Nerd Font](https://www.nerdfonts.com/) set as the terminal font
  (FiraCode on macOS, JetBrainsMono on Windows)
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
scoop install starship pwsh
scoop bucket add nerd-fonts; scoop install JetBrainsMono-NF
winget install Neovim.Neovim JesseDuffield.lazygit BurntSushi.ripgrep.MSVC
```

On macOS, also install the zsh plugins: `brew install zsh-autosuggestions zsh-syntax-highlighting`.

PowerShell 7 (`pwsh`) is only needed to create the symlinks, for the reason
explained under [Windows](#windows-powershell); the profile itself targets
Windows PowerShell 5.1.

### 3. Create symlinks

If a target already exists, back it up first.

| Source | macOS target | Windows target |
| --- | --- | --- |
| `zsh/.zshrc` | `~/.zshrc` | — |
| `powershell/Microsoft.PowerShell_profile.ps1` | — | `%USERPROFILE%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` |
| `starship/starship.toml` | `~/.config/starship.toml` | `%USERPROFILE%\.config\starship.toml` |
| `nvim/` | `~/.config/nvim` | `%LOCALAPPDATA%\nvim` |
| `lazygit/config.yml` | `~/Library/Application Support/lazygit/config.yml` | `%APPDATA%\lazygit\config.yml` |
| `ghostty/config.ghostty` | `~/.config/ghostty/config.ghostty` | — |
| `windows-terminal/settings.json` | — | `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json` |

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

Creating symlinks needs either Developer Mode (Settings → System → For
developers) or an Administrator shell.

One catch: with Developer Mode, create the links from **PowerShell 7**, not
Windows PowerShell 5.1. `New-Item -ItemType SymbolicLink` in 5.1 does not pass
`SYMBOLIC_LINK_FLAG_ALLOW_UNPRIVILEGED_CREATE`, so it asks for elevation no
matter how Developer Mode is set.

| Shell | Developer Mode | Elevation |
| --- | --- | --- |
| PowerShell 7 | on | not needed |
| PowerShell 7 | off | required |
| Windows PowerShell 5.1 | either | required |

[setup-windows.ps1](setup-windows.ps1) creates every Windows link in one go. It
probes for the capability first and stops with an explanation rather than doing
half the work, skips targets that already point at this repository, and renames
anything else to `<name>.backup-<timestamp>` before linking, so nothing is
overwritten.

```powershell
cd ~\repos\dotfiles
pwsh -NoProfile -File .\setup-windows.ps1 -WhatIf   # see what it would do
pwsh -NoProfile -File .\setup-windows.ps1
```

Then restart the terminal so the profile is loaded.

To do it by hand instead:

```powershell
$Dotfiles = "$HOME\repos\dotfiles"
New-Item -ItemType Directory -Force "$HOME\.config", "$env:APPDATA\lazygit" | Out-Null
New-Item -ItemType SymbolicLink -Path "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Target "$Dotfiles\powershell\Microsoft.PowerShell_profile.ps1"
New-Item -ItemType SymbolicLink -Path "$HOME\.config\starship.toml" -Target "$Dotfiles\starship\starship.toml"
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim" -Target "$Dotfiles\nvim"
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\lazygit\config.yml" -Target "$Dotfiles\lazygit\config.yml"
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Target "$Dotfiles\windows-terminal\settings.json"
```

## Machine-Specific Config

Anything that should not be committed (work aliases, tokens, local paths) goes
in a file outside the repository, loaded by the shell config if it exists:

| Platform | File |
| --- | --- |
| macOS | `~/.zshrc.local` |
| Windows | `~\Documents\WindowsPowerShell\profile.local.ps1` |
