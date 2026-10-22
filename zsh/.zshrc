# Keep PATH and fpath free of duplicates so re-sourcing doesn't rebuild the completion cache
typeset -U path fpath

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
DISABLE_MAGIC_FUNCTIONS="true"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Platform-specific locations (Homebrew on macOS, apt on Debian/Ubuntu)
if [[ $OSTYPE == darwin* ]]; then
  ZSH_SHARE="${HOMEBREW_PREFIX:-/opt/homebrew}/share"
  BAT_CMD="bat"
else
  ZSH_SHARE="/usr/share"
  BAT_CMD="batcat"
fi

# Paths
export PATH="$HOME/.local/bin:$HOME/.local/bin/nvim/bin:$HOME/bin:$PATH"

# Secrets
[ -f ~/.secrets ] && chmod 600 ~/.secrets && source ~/.secrets

# Aliases
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias duh="du -h -d 1 | sort -h"
alias dfh="df -h"
alias k="kubectl"
alias kx="kubectx"
alias kn="kubens"
alias kg="kubectl get"
alias kd="kubectl describe"
alias ka="kubectl apply -f"

# Oh My Posh
eval "$(oh-my-posh init zsh --config ~/dotfiles/oh-my-posh/purist.omp.json)"

# Crtl+R: pick a command in history
export FZF_CTRL_R_OPTS="--preview 'echo {} | $BAT_CMD --color=always --language=zsh --style=plain' --preview-window down:3:wrap"
if [[ $OSTYPE == darwin* ]]; then
  source <(fzf --zsh)
else
  source /usr/share/doc/fzf/examples/key-bindings.zsh
  source /usr/share/doc/fzf/examples/completion.zsh
fi

# Ctrl+T: pick a file and open it in nvim
fzf-nvim-widget() {
  local file
  file=$(rg --files --hidden --glob '!.git' | fzf --preview "$BAT_CMD --color=always --style=numbers --line-range=:500 {}") || { zle reset-prompt; return }
  BUFFER="nvim ${(q)file}"
  zle accept-line
}
zle -N fzf-nvim-widget
bindkey '^T' fzf-nvim-widget

# nvm
export NVM_DIR="$HOME/.nvm"
_node_versions=("$NVM_DIR"/versions/node/*(Nn))
(( $#_node_versions )) && path=("$_node_versions[-1]/bin" $path)
unset _node_versions
nvm() {
  unfunction nvm
  source "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# Must be sourced last
source $ZSH_SHARE/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH_SHARE/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
