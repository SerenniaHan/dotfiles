# Neovim Configuration

A personal Neovim setup managed with [lazy.nvim][lazy].

## Requirements

- Neovim >= 0.10
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- Node.js (for LSP servers installed via Mason)
- [ripgrep][ripgrep] — required for Telescope live grep

> **Note:** Telescope's live grep and grep string features depend on
> `ripgrep`. Without it, those features will silently fail.
> Install it before launching Neovim:
>
> ```bash
> # macOS
> brew install ripgrep
>
> # Ubuntu / Debian
> sudo apt install ripgrep
>
> # Windows (winget)
> winget install BurntSushi.ripgrep.MSVC
> ```

## Structure

```text
nvim/
├── init.lua                       # Entry point — options, diagnostics, colorscheme
├── filetype.lua                   # Custom filetype detection
├── lazy-lock.json                 # Plugin version lockfile
├── spell/                         # Custom spell-check word list
└── lua/
    ├── config/
    │   ├── keymaps.lua            # Global keymaps
    │   └── lazy.lua               # lazy.nvim bootstrap & setup
    └── plugins/
        ├── theme.lua              # tokyonight colorscheme
        ├── lsp.lua                # LSP (nvim-lspconfig + Mason)
        ├── blink-cmp.lua          # Autocompletion (blink.cmp)
        ├── formatter.lua          # Auto-format on save (conform.nvim)
        ├── linter.lua             # Linting (nvim-lint)
        ├── treesitter.lua         # Syntax highlighting
        ├── rainbow-delimiters.lua # Rainbow bracket / block highlighting
        ├── telescope.lua          # Fuzzy finder
        ├── nvim-tree.lua          # File explorer
        ├── bufferline.lua         # Buffer tab bar
        ├── lualine.lua            # Status line
        ├── gitsigns.lua           # Git hunk signs
        ├── flash.lua              # Fast motion / jump
        ├── mini-surround.lua      # Surround text objects
        └── venv-selector.lua      # Python venv picker (macOS only)
```

## Plugins

| Plugin | Purpose |
| --- | --- |
| [tokyonight.nvim][tokyonight] | Colorscheme |
| [nvim-lspconfig][lspconfig] + [mason.nvim][mason] | LSP & server installer |
| [blink.cmp][blink-cmp] | Autocompletion |
| [conform.nvim][conform] | Format on save |
| [nvim-lint][nvim-lint] | Linting |
| [nvim-treesitter][treesitter] | Syntax highlighting & parsing |
| [rainbow-delimiters.nvim][rainbow-delimiters] | Rainbow bracket / block highlighting |
| [telescope.nvim][telescope] | Fuzzy finder |
| [nvim-tree.lua][nvim-tree] | File explorer |
| [bufferline.nvim][bufferline] | Buffer tab bar |
| [lualine.nvim][lualine] | Status line |
| [gitsigns.nvim][gitsigns] | Git hunk signs in the gutter |
| [flash.nvim][flash] | Fast jump / motion |
| [mini.surround][mini-surround] | Surround text objects |
| [venv-selector.nvim][venv-selector] | Python venv picker (macOS only) |

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/SerenniaHan/dotfiles.git ~/repos/dotfiles
```

### 2. Create a symlink

Neovim loads its configuration from a platform-specific path.
Create a symlink pointing to this directory:

**macOS / Linux** — config lives at `~/.config/nvim`:

```bash
ln -s ~/repos/dotfiles/nvim ~/.config/nvim
```

**Windows (PowerShell)** — config lives at `$env:LOCALAPPDATA\nvim`:

```powershell
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim" -Target "$HOME\repos\dotfiles\nvim"
```

> **Note (Windows):** Creating symbolic links requires either **Administrator** privileges
> or **Developer Mode** enabled (Settings → System → For developers → Developer Mode).

To verify the symlink was created correctly:

**macOS / Linux:**

```bash
ls -la ~/.config/nvim
# Expected output:
# lrwxr-xr-x  ...  /Users/<you>/.config/nvim -> /Users/<you>/repos/dotfiles/nvim
```

**Windows (PowerShell):**

```powershell
Get-Item "$env:LOCALAPPDATA\nvim" | Select-Object FullName, LinkType, Target
```

> If the target path already exists, remove or back it up first:
>
> **macOS / Linux:**
>
> ```bash
> mv ~/.config/nvim ~/.config/nvim.bak
> ln -s ~/repos/dotfiles/nvim ~/.config/nvim
> ```
>
> **Windows (PowerShell):**
>
> ```powershell
> Rename-Item "$env:LOCALAPPDATA\nvim" "$env:LOCALAPPDATA\nvim.bak"
> New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim" -Target "$HOME\repos\dotfiles\nvim"
> ```

lazy.nvim will automatically install all plugins on the first launch.

[lazy]: https://github.com/folke/lazy.nvim
[ripgrep]: https://github.com/BurntSushi/ripgrep
[tokyonight]: https://github.com/folke/tokyonight.nvim
[lspconfig]: https://github.com/neovim/nvim-lspconfig
[mason]: https://github.com/williamboman/mason.nvim
[blink-cmp]: https://github.com/saghen/blink.cmp
[conform]: https://github.com/stevearc/conform.nvim
[nvim-lint]: https://github.com/mfussenegger/nvim-lint
[treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[rainbow-delimiters]: https://github.com/HiPhish/rainbow-delimiters.nvim
[telescope]: https://github.com/nvim-telescope/telescope.nvim
[nvim-tree]: https://github.com/nvim-tree/nvim-tree.lua
[bufferline]: https://github.com/akinsho/bufferline.nvim
[lualine]: https://github.com/nvim-lualine/lualine.nvim
[gitsigns]: https://github.com/lewis6991/gitsigns.nvim
[flash]: https://github.com/folke/flash.nvim
[mini-surround]: https://github.com/echasnovski/mini.surround
[venv-selector]: https://github.com/linux-cultist/venv-selector.nvim
