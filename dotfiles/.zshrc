# Ported from Ubuntu 24.04 -> Omarchy (Arch). Machine-specific values live in ~/.zshrc.local (not in git).

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    web-search
    copypath
    copyfile
    copybuffer
    jsontools
    extract
    colored-man-pages
    fzf
)

source $ZSH/oh-my-zsh.sh

# Tmux session creation function
ts() {
  tmux new-session -A -s "${1:-main}"
}

# Pokemon colorscript + fastfetch (pokemon-colorscripts-git from AUR)
if command -v pokemon-colorscripts >/dev/null; then
  pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -
fi

# eza for ls
alias ls='eza'
alias l='eza -l'
alias la='eza -a'
alias lla='eza -la'
alias lt='eza --tree'

alias claude-personal="CLAUDE_CONFIG_DIR=~/.claude-personal $HOME/.local/bin/claude"
alias claude-work="CLAUDE_CONFIG_DIR=~/.claude-work $HOME/.local/bin/claude"

# git
alias gs='git status'
alias gpull='git pull'
alias gpush='git push'
alias ga='git add .'
alias gc='git commit -m'
alias gcheck='git checkout'
alias gb='git branch'
alias gl='git log'
alias gdiff='git diff'

alias update='yay -Syu'
alias zreset='source ~/.zshrc'
alias spp='cd ~/l3-rails-sunrise-partnerportal'
alias bed='cd ~/BED-backend'
alias be='bundle exec'
# Server SSH: set DENDUP_SERVER_IP in ~/.zshrc.local, copy key to ~/.ssh/DendupServer_key.pem
alias dendup_server='ssh -i ~/.ssh/DendupServer_key.pem dendup@$DENDUP_SERVER_IP'

export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.foundry/bin"
export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"
export MOZ_ENABLE_WAYLAND=0

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# mise (ruby etc.)
command -v mise >/dev/null && eval "$(mise activate zsh)"

export GHIDRA_INSTALL_DIR="$HOME/ghidra_12.1_PUBLIC"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Machine-specific / secret stuff
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
