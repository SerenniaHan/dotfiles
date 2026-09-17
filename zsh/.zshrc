#!/usr/bin/env zsh

# Homebrew 安装位置 (Apple Silicon: /opt/homebrew, Intel: /usr/local)
if [[ -z "$HOMEBREW_PREFIX" ]]; then
  for _prefix in /opt/homebrew /usr/local; do
    [[ -x "$_prefix/bin/brew" ]] && HOMEBREW_PREFIX="$_prefix" && break
  done
  unset _prefix
fi

# ------------------------------------------------------------
# 基础设置
# ------------------------------------------------------------
setopt autocd              # 输入目录名直接进入
export CLICOLOR=1          # ls 输出带颜色

# 历史记录
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000
setopt extended_history       # 记录时间戳
setopt hist_expire_dups_first # 超出上限时先删重复项
setopt hist_ignore_dups       # 不记录连续重复的命令
setopt hist_ignore_space      # 空格开头的命令不记录
setopt hist_verify            # !! 等历史展开先显示再执行
setopt share_history          # 多个终端共享历史

# ------------------------------------------------------------
# 补全 (含 git、brew 安装工具的补全)
# ------------------------------------------------------------
[[ -n "$HOMEBREW_PREFIX" ]] && fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
autoload -Uz compinit
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
zstyle ':completion:*' menu select                   # 方向键选择补全项
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # 不区分大小写

# ------------------------------------------------------------
# vi 模式
# ------------------------------------------------------------
bindkey -v
KEYTIMEOUT=1 # Esc 切换到 normal 模式不延迟

# 光标形状: insert 模式竖线，normal 模式方块
function zle-keymap-select zle-line-init {
  if [[ $KEYMAP == vicmd ]]; then
    printf '\e[2 q'
  else
    printf '\e[6 q'
  fi
}
zle -N zle-keymap-select
zle -N zle-line-init

# insert 模式下保留常用快捷键
bindkey -M viins '^?' backward-delete-char # 退格可删除进入 insert 前的字符
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^R' history-incremental-search-backward

# 上下方向键: 按已输入的前缀搜索历史
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey -M viins '^[[A' up-line-or-beginning-search
bindkey -M viins '^[[B' down-line-or-beginning-search
bindkey -M vicmd 'k' up-line-or-beginning-search
bindkey -M vicmd 'j' down-line-or-beginning-search

# ------------------------------------------------------------
# 别名
# ------------------------------------------------------------
alias zshconfig="nvim ~/.zshrc"
alias vimconfig="nvim ~/.config/nvim/init.lua"
alias vim="nvim"
alias cls="clear"
alias ..="cd .."
alias ...="cd ../.."
alias gorepo="cd ~/repos"

# git (名字与 Oh My Zsh 的 git 插件一致)
alias g="git"
alias gst="git status"
alias ga="git add"
alias gc="git commit"
alias gco="git checkout"
alias gsw="git switch"
alias gb="git branch"
alias gd="git diff"
alias gl="git pull"
alias gp="git push"
alias gtree="git log --oneline"
alias showstash="git stash list"

# ------------------------------------------------------------
# 函数
# ------------------------------------------------------------

# 清理远程已删除的本地分支 (upstream 为 gone)
#
# 不用 git branch -d: 它按 commit SHA 判断是否已合并，而 GitHub 的 squash /
# rebase merge 会生成全新的 commit，原分支永远不会成为主分支的祖先，于是被误判为
# "not fully merged" 而拒绝删除。
#
# 改为按内容判断: 把分支的 tree 重新挂到 merge-base 上造一个临时 commit，再用
# git cherry 比对 patch-id。内容已并入当前分支的用 -D 删除，确有未合并内容的保留
# 并提示，避免丢工作。
function gitcleanup() {
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "❌ 错误：当前目录不是 Git 仓库"
    return 1
  fi

  local base
  base=$(git symbolic-ref --quiet --short HEAD)
  if [ -z "$base" ]; then
    echo "❌ 错误：当前处于 detached HEAD，请先切回主分支"
    return 1
  fi

  echo "🚀 正在同步远程状态 (fetch -p)..."
  git fetch -p

  # for-each-ref 直接输出分支名，不受 git branch 的 "*" / "+" 前缀干扰
  local -a gone_branches
  gone_branches=(${(f)"$(git for-each-ref --format='%(refname:short) %(upstream:track)' refs/heads |
    awk '$2 == "[gone]" { print $1 }')"})

  local -a deleted kept
  local branch merge_base tree dangling
  for branch in $gone_branches; do
    [ -z "$branch" ] && continue
    [ "$branch" = "$base" ] && continue

    merge_base=$(git merge-base "$base" "$branch") || continue
    tree=$(git rev-parse "$branch^{tree}")
    dangling=$(git commit-tree "$tree" -p "$merge_base" -m _)

    if git cherry "$base" "$dangling" | grep -q '^+'; then
      kept+=("$branch")
    else
      git branch -D "$branch" > /dev/null && deleted+=("$branch")
    fi
  done

  if (( ${#deleted} )); then
    echo "🧹 已清理 ${#deleted} 个过时分支 (内容已并入 $base)："
    printf '   ✔ %s\n' $deleted
  fi
  if (( ${#kept} )); then
    echo "⚠️  以下分支远端已删除，但仍有未并入 $base 的提交，已保留："
    printf '   • %s\n' $kept
    echo "   确认可丢弃后手动执行：git branch -D <branch>"
  fi
  if (( ${#deleted} == 0 && ${#kept} == 0 )); then
    echo "✨ 本地仓库很干净。"
  fi
}

# ------------------------------------------------------------
# 本机专用配置 (放在仓库外，如工作相关别名、token)
# ------------------------------------------------------------
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ------------------------------------------------------------
# 提示符
# ------------------------------------------------------------
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# ------------------------------------------------------------
# 插件 (brew install zsh-autosuggestions zsh-syntax-highlighting)
# syntax-highlighting 必须最后加载
# ------------------------------------------------------------
if [[ -n "$HOMEBREW_PREFIX" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" 2>/dev/null
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 2>/dev/null
fi
