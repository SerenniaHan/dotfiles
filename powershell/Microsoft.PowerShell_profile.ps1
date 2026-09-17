#Requires -Version 5.1

# PowerShell profile (Windows)。macOS 的對應設定在 ../zsh/.zshrc，
# 段落順序刻意與 .zshrc 保持一致，兩邊對照著看比較容易。
#
# 本檔必須以 UTF-8 with BOM 儲存：Windows PowerShell 5.1 讀取沒有 BOM 的
# .ps1 時會套用系統 ANSI 碼頁，中文與 emoji 會變成亂碼。

# ------------------------------------------------------------
# 基礎設置
# ------------------------------------------------------------
# 5.1 主控台預設以 ANSI 碼頁輸出，改成 UTF-8 才能正確顯示中文與 Nerd Font 圖示
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

# ------------------------------------------------------------
# 歷史與按鍵 (PSReadLine)
# ------------------------------------------------------------
if (Get-Module PSReadLine) {
    # 上下鍵：按已輸入的前綴搜尋歷史 (等同 .zshrc 的 up-line-or-beginning-search)
    Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

    # Tab 補全選單 (等同 zsh 的 menu select)
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

    # 歷史預測補全，等同 macOS 那邊的 zsh-autosuggestions。
    # -PredictionSource 需要 PSReadLine 2.1+、-PredictionViewStyle 需要 2.2+，
    # 而 Windows PowerShell 5.1 內建的是 2.0.0，所以用版本判斷包起來，
    # 在 5.1 上安靜跳過，在 PowerShell 7 或升級過 PSReadLine 的環境自動啟用。
    # 想在 5.1 啟用: Install-Module PSReadLine -Scope CurrentUser -Force 後重開終端機。
    $psrlVersion = (Get-Module PSReadLine).Version
    if ($psrlVersion -and $psrlVersion -ge [version]'2.2.0') {
        Set-PSReadLineOption -PredictionSource History
        Set-PSReadLineOption -PredictionViewStyle ListView
    }
}

# ------------------------------------------------------------
# 別名
# ------------------------------------------------------------
# gc / gl / gp 是 Get-Content / Get-Location / Get-ItemProperty 的內建別名，
# 而 PowerShell 的命令優先序是「別名 > 函式」，不先移除的話下面的 git 函式不會生效。
# 移除只影響互動工作階段，這些 cmdlet 仍可用完整名稱呼叫。
foreach ($builtin in 'gc', 'gl', 'gp') {
    if (Test-Path "Alias:$builtin") { Remove-Item "Alias:$builtin" -Force }
}

function vim { nvim @args }
function psconfig { nvim $PROFILE }
function vimconfig { nvim "$env:LOCALAPPDATA\nvim\init.lua" }
function .. { Set-Location .. }
function ... { Set-Location ..\.. }

# git (名字與 ../zsh/.zshrc 一致)
function g { git @args }
function gst { git status @args }
function ga { git add @args }
function gc { git commit @args }
function gco { git checkout @args }
function gsw { git switch @args }
function gb { git branch @args }
function gd { git diff @args }
function gl { git pull @args }
function gp { git push @args }
function gtree { git log --oneline @args }
function showstash { git stash list @args }

# ------------------------------------------------------------
# 函式
# ------------------------------------------------------------

# 進入 repos 目錄，或其下的某個倉庫
function gorepo {
    if ($args) {
        Set-Location (Join-Path "$HOME\repos" $args[0])
    } else {
        Set-Location "$HOME\repos"
    }
}

# 清理遠端已刪除的本地分支
# 使用 -d 而不是 -D: 含未合併提交的分支會被拒絕刪除，避免丟失未推送的工作
function gitcleanup {
    git rev-parse --is-inside-work-tree 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ 錯誤：當前目錄不是 Git 倉庫" -ForegroundColor Red
        return
    }
    Write-Host "🚀 正在同步遠端狀態 (fetch -p)..."
    git fetch -p
    $goneBranches = git branch -vv |
        Where-Object { $_ -match ':\s*gone\]' -and $_ -notmatch '^\*' } |
        ForEach-Object { ($_.Trim() -split '\s+')[0] }
    if ($goneBranches) {
        Write-Host "🧹 發現並清理過時分支：$($goneBranches -join ', ')"
        $goneBranches | ForEach-Object { git branch -d $_ }
    } else {
        Write-Host "✨ 本地倉庫很乾淨。"
    }
}

# ------------------------------------------------------------
# 本機專用配置 (放在倉庫外，如工作相關別名、token)
# ------------------------------------------------------------
$localProfile = Join-Path (Split-Path -Parent $PROFILE) 'profile.local.ps1'
if (Test-Path $localProfile) { . $localProfile }

# ------------------------------------------------------------
# 提示符
# ------------------------------------------------------------
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}
