# windows-terminal

[Windows Terminal](https://github.com/microsoft/terminal) settings. It is the
Windows counterpart of [../ghostty](../ghostty) on macOS: the terminal itself,
not the shell that runs inside it (see [../powershell](../powershell)).

## Structure

```text
windows-terminal/
└── settings.json   # Font, colour scheme, keybindings, profile list
```

## What Is Configured

| Setting | Value | Default |
| --- | --- | --- |
| Font | JetBrainsMonoNL Nerd Font, 14 | Cascadia Mono, 12 |
| Colour scheme | Dark+ | Campbell |
| `Ctrl+C` | Copy, keeping line breaks (`singleLine: false`) | Cancel the running command |
| `Ctrl+V` | Paste | — |
| `Ctrl+Shift+F` | Find | — |
| `Alt+Shift+D` | Split pane | — |
| Default profile | Windows PowerShell 5.1 | Varies by version |

The Nerd Font is what makes starship's git and directory glyphs render instead
of tofu boxes. Install it before linking the settings:

```powershell
scoop bucket add nerd-fonts
scoop install JetBrainsMono-NF
```

## Installation

The settings file lives inside Windows Terminal's MSIX package directory:

```text
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
```

Requires PowerShell 7 with Developer Mode on, or an Administrator shell; see
the [root README](../README.md#windows-powershell) for why 5.1 cannot create
the link unelevated.

```powershell
$WtSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Move-Item $WtSettings "$WtSettings.backup"   # if one exists
New-Item -ItemType SymbolicLink -Path $WtSettings `
    -Target "$HOME\repos\dotfiles\windows-terminal\settings.json"
```

Use `Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe` for the Preview build.

## Caveats

**The symlink can be replaced.** Windows Terminal saves settings by writing a
temporary file and replacing the original, which has been known to turn the
symlink back into a regular file
([microsoft/terminal#7454](https://github.com/microsoft/terminal/issues/7454)).
Recent builds usually preserve it. The symptom is that changes made in the UI
stop showing up in `git status`; check and recreate with:

```powershell
(Get-Item $WtSettings).LinkType   # "SymbolicLink" if still linked
```

**Saving rewrites the whole file.** Editing settings through the UI reformats
`settings.json` and can add keys that were previously left at their defaults,
so a diff after a small change may be noisy.

**Some entries are machine-specific.** The `profiles.list` GUIDs and the
auto-generated entries (Azure Cloud Shell, Developer Command Prompt for
VS 2022) come from what is installed on this machine. On another machine,
treat this file as a starting point rather than something to copy verbatim:
profiles whose program is missing simply will not launch.
