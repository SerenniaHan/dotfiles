# Lazygit Configuration

Personal Lazygit configuration with [Catppuccin Macchiato][catppuccin] theme.

## Structure

```text
lazygit/
└── config.yml    # Main configuration (theme, language, author colors)
```

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/SerenniaHan/dotfiles.git ~/repos/dotfiles
```

### 2. Create a symlink

#### macOS

Lazygit loads its configuration from `~/Library/Application Support/lazygit/config.yml`.

```bash
ln -s ~/repos/dotfiles/lazygit/config.yml \
  ~/Library/Application\ Support/lazygit/config.yml
```

To verify:

```bash
ls -la ~/Library/Application\ Support/lazygit/config.yml
# Expected output:
# lrwxr-xr-x  ...  .../lazygit/config.yml -> .../dotfiles/lazygit/config.yml
```

> If the file already exists, back it up first:
>
> ```bash
> mv ~/Library/Application\ Support/lazygit/config.yml \
>   ~/Library/Application\ Support/lazygit/config.yml.bak
> ln -s ~/repos/dotfiles/lazygit/config.yml \
>   ~/Library/Application\ Support/lazygit/config.yml
> ```

#### Windows

Lazygit loads its configuration from `%APPDATA%\lazygit\config.yml`.

Run the following in PowerShell (as Administrator):

```powershell
New-Item -ItemType SymbolicLink `
  -Path "$env:APPDATA\lazygit\config.yml" `
  -Target "$HOME\repos\dotfiles\lazygit\config.yml"
```

To verify:

```powershell
Get-Item "$env:APPDATA\lazygit\config.yml" | Select-Object -ExpandProperty Target
# Expected output: C:\Users\<you>\repos\dotfiles\lazygit\config.yml
```

> If the file already exists, back it up first:
>
> ```powershell
> Rename-Item "$env:APPDATA\lazygit\config.yml" `
>   "$env:APPDATA\lazygit\config.yml.bak"
> New-Item -ItemType SymbolicLink `
>   -Path "$env:APPDATA\lazygit\config.yml" `
>   -Target "$HOME\repos\dotfiles\lazygit\config.yml"
> ```

## Requirements

- [Lazygit](https://github.com/jesseduffield/lazygit)

  ```bash
  brew install lazygit
  ```

[catppuccin]: https://github.com/catppuccin/lazygit
