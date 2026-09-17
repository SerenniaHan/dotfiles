# powershell

PowerShell profile for Windows. It is the counterpart of [../zsh](../zsh) on
macOS: same section order, same alias names, same
[starship](https://starship.rs/) prompt (see [../starship](../starship)).

## Structure

```text
powershell/
└── Microsoft.PowerShell_profile.ps1   # All configuration
```

Sections, loaded in this order:

1. Basic options (console encoding)
2. History and keybindings (PSReadLine)
3. Aliases
4. Functions
5. `profile.local.ps1` (if it exists)
6. starship

## Which PowerShell

This profile targets **Windows PowerShell 5.1**, the one that ships with
Windows and is the default Windows Terminal profile on this machine. It also
runs unchanged on PowerShell 7, which is a separate program with a separate
profile directory:

| | Windows PowerShell 5.1 | PowerShell 7 |
| --- | --- | --- |
| Profile | `~\Documents\WindowsPowerShell\` | `~\Documents\PowerShell\` |
| Bundled PSReadLine | 2.0.0 | 2.3+ |
| `&&` / `\|\|`, `?:`, `??` | No | Yes |
| Default file encoding | UTF-8 with BOM | UTF-8 without BOM |

## Features

| Feature | How |
| --- | --- |
| History prefix search | `↑` / `↓`, via `HistorySearchBackward` / `HistorySearchForward` |
| Completion menu | `Tab`, via `MenuComplete` |
| Suggestions from history | `Set-PSReadLineOption -PredictionSource History`, **only active on PSReadLine 2.2+** (see below) |
| Prompt | starship, same `starship.toml` as macOS |

### Suggestions from history

This is the equivalent of zsh-autosuggestions. `-PredictionSource` needs
PSReadLine 2.1+ and `-PredictionViewStyle` needs 2.2+, but Windows PowerShell
5.1 bundles 2.0.0, so the profile guards both behind a version check and
silently skips them on 5.1. To turn them on there, upgrade the module:

```powershell
Install-Module PSReadLine -Scope CurrentUser -Force
```

Then restart the terminal. On PowerShell 7 nothing is needed.

## Aliases and Functions

Names match [../zsh/.zshrc](../zsh/.zshrc) so muscle memory carries across
machines.

| Name | Does |
| --- | --- |
| `vim` | `nvim` |
| `psconfig` / `vimconfig` | Open the PowerShell / Neovim config |
| `..` / `...` | Go up one / two directories |
| `gorepo` | `cd ~\repos`, or `gorepo <name>` for a repository under it |
| `g`, `gst`, `ga`, `gc`, `gco`, `gsw`, `gb`, `gd`, `gl`, `gp` | `git`, `status`, `add`, `commit`, `checkout`, `switch`, `branch`, `diff`, `pull`, `push` |
| `gtree` | `git log --oneline` |
| `showstash` | `git stash list` |
| `gitcleanup` | Fetch with prune, then delete local branches whose remote is gone. Uses `git branch -d`, so branches with unmerged commits are kept |

`cls` is not defined here: PowerShell already ships it as an alias for
`Clear-Host`.

### Shadowed built-in aliases

`gc`, `gl` and `gp` are built-in aliases for `Get-Content`, `Get-Location` and
`Get-ItemProperty`. PowerShell resolves aliases **before** functions, so the
profile removes those three aliases before defining the git functions of the
same name. This only affects the interactive session; the cmdlets are still
reachable by their full names. To keep them, delete the `foreach ($builtin …)`
loop and the three functions.

## Encoding

The file must stay **UTF-8 with BOM**. Windows PowerShell 5.1 reads a BOM-less
`.ps1` using the system ANSI code page, which turns the Chinese comments and
the emoji in `gitcleanup` into mojibake. The profile also sets
`[Console]::OutputEncoding` to UTF-8 so that output and Nerd Font glyphs render
correctly.

## Installation

Requires PowerShell 7 with Developer Mode on, or an Administrator shell; see
the [root README](../README.md#windows-powershell) for why 5.1 cannot create
the link unelevated.

```powershell
$Profile51 = "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
Move-Item $Profile51 "$Profile51.backup"   # if one exists
New-Item -ItemType SymbolicLink -Path $Profile51 `
    -Target "$HOME\repos\dotfiles\powershell\Microsoft.PowerShell_profile.ps1"
```

## Machine-Specific Config

Put anything that should not be committed (work aliases, tokens, local paths)
in `profile.local.ps1`, next to the profile in
`~\Documents\WindowsPowerShell\`. It lives outside the repository, so it can
never be committed by accident. The profile dot-sources it if it exists —
the same role `~/.zshrc.local` plays on macOS.

```powershell
'function gowork { Set-Location "$HOME\repos\work" }' |
    Add-Content "$HOME\Documents\WindowsPowerShell\profile.local.ps1"
```
