#Requires -Version 5.1
<#
.SYNOPSIS
    在 Windows 上建立本倉庫所有設定檔的符號連結。

.DESCRIPTION
    每個目標若已經是指向本倉庫的連結就跳過；若是實體檔案或目錄，會先改名為
    <名稱>.backup-<時間戳> 再建立連結，不會直接覆蓋。

    需要建立符號連結的權限。注意 Windows PowerShell 5.1 的 New-Item 不會帶上
    SYMBOLIC_LINK_FLAG_ALLOW_UNPRIVILEGED_CREATE，所以即使開了開發人員模式，
    在 5.1 下仍然需要提權；PowerShell 7 則可以免提權建立。三種可行組合：

      1. 開發人員模式 + PowerShell 7  ->  pwsh -File .\setup-windows.ps1  (最省事)
      2. 系統管理員身分的 Windows PowerShell 5.1
      3. 系統管理員身分的 PowerShell 7

    腳本會實際探測能否建立連結，不行就停下並說明原因，不會做半套。

.EXAMPLE
    pwsh -NoProfile -File .\setup-windows.ps1 -WhatIf
    先看會做哪些動作，不實際執行。

.EXAMPLE
    pwsh -NoProfile -File .\setup-windows.ps1
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param()

$ErrorActionPreference = 'Stop'
$Dotfiles = $PSScriptRoot

# ------------------------------------------------------------
# 連結對照表
# ------------------------------------------------------------
$links = @(
    @{ Name = 'powershell profile'
       Source = "$Dotfiles\powershell\Microsoft.PowerShell_profile.ps1"
       Target = "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" }

    @{ Name = 'starship'
       Source = "$Dotfiles\starship\starship.toml"
       Target = "$HOME\.config\starship.toml" }

    @{ Name = 'nvim'
       Source = "$Dotfiles\nvim"
       Target = "$env:LOCALAPPDATA\nvim" }

    @{ Name = 'lazygit'
       Source = "$Dotfiles\lazygit\config.yml"
       Target = "$env:APPDATA\lazygit\config.yml" }

    @{ Name = 'windows terminal'
       Source = "$Dotfiles\windows-terminal\settings.json"
       Target = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" }
)

# ------------------------------------------------------------
# 前置檢查：是否具備建立符號連結的權限
# ------------------------------------------------------------
function Test-SymlinkCapability {
    # 探測本身必須真的執行，否則 -WhatIf 會讓它永遠回報失敗
    $probe = Join-Path $env:TEMP "dotfiles-symlink-probe-$(Get-Random)"
    try {
        New-Item -ItemType File -Path "$probe.target" -Force -WhatIf:$false | Out-Null
        New-Item -ItemType SymbolicLink -Path "$probe.link" -Target "$probe.target" -ErrorAction Stop -WhatIf:$false | Out-Null
        return $true
    } catch {
        return $false
    } finally {
        Remove-Item "$probe.link", "$probe.target" -Force -ErrorAction SilentlyContinue -WhatIf:$false
    }
}

function Test-DeveloperMode {
    $key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock'
    return (Get-ItemProperty $key -ErrorAction SilentlyContinue).AllowDevelopmentWithoutDevLicense -eq 1
}

if (-not (Test-SymlinkCapability)) {
    $devMode = Test-DeveloperMode
    $isCore = $PSVersionTable.PSEdition -eq 'Core'

    Write-Host ""
    Write-Host "無法建立符號連結。" -ForegroundColor Red
    Write-Host ""

    if ($devMode -and -not $isCore) {
        # 最常見的情況：開發人員模式開了，但在 5.1 下跑
        Write-Host "開發人員模式已開啟，但目前是 Windows PowerShell $($PSVersionTable.PSVersion)。"
        Write-Host "5.1 的 New-Item 不會帶上免提權建立連結的旗標，開發人員模式對它無效。"
        Write-Host ""
        $pwshPath = (Get-Command pwsh -ErrorAction SilentlyContinue).Source
        if ($pwshPath) {
            Write-Host "改用已安裝的 PowerShell 7 重跑即可，不需提權：" -ForegroundColor Yellow
            Write-Host "  pwsh -NoProfile -File `"$PSCommandPath`""
        } else {
            Write-Host "請改以系統管理員身分執行，或先安裝 PowerShell 7 (scoop install pwsh)。" -ForegroundColor Yellow
        }
    } elseif (-not $devMode) {
        Write-Host "請擇一處理後重跑："
        Write-Host "  1. 開啟開發人員模式 (設定 → 系統 → 開發人員專用)，並以 PowerShell 7 執行"
        Write-Host "  2. 以系統管理員身分執行本腳本"
    } else {
        Write-Host "請以系統管理員身分執行本腳本。"
    }
    Write-Host ""
    exit 1
}

# ------------------------------------------------------------
# 建立連結
# ------------------------------------------------------------
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

foreach ($link in $links) {
    $name = $link.Name
    $source = $link.Source
    $target = $link.Target

    if (-not (Test-Path $source)) {
        Write-Host "[跳過] $name : 倉庫中找不到 $source" -ForegroundColor Yellow
        continue
    }

    # 目標的上層目錄可能不存在 (例如尚未用過 lazygit)
    $parent = Split-Path -Parent $target
    if (-not (Test-Path $parent)) {
        if ($PSCmdlet.ShouldProcess($parent, '建立目錄')) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }
    }

    if (Test-Path $target) {
        $item = Get-Item $target -Force
        if ($item.LinkType -eq 'SymbolicLink') {
            $current = $item.Target | Select-Object -First 1
            if ($current -eq $source) {
                Write-Host "[已連結] $name" -ForegroundColor DarkGray
                continue
            }
            Write-Host "[取代] $name : 原連結指向 $current" -ForegroundColor Yellow
            if ($PSCmdlet.ShouldProcess($target, '移除舊連結')) {
                Remove-Item $target -Force -Recurse
            }
        } else {
            $backup = "$target.backup-$stamp"
            Write-Host "[備份] $name : $target -> $backup" -ForegroundColor Yellow
            if ($PSCmdlet.ShouldProcess($target, "備份為 $backup")) {
                Move-Item $target $backup
            }
        }
    }

    if ($PSCmdlet.ShouldProcess($target, "連結到 $source")) {
        New-Item -ItemType SymbolicLink -Path $target -Target $source | Out-Null
        Write-Host "[連結] $name : $target" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "完成。重新開啟終端機讓 profile 生效。" -ForegroundColor Green
