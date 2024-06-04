alias s='sesh connect $(sesh list | fzf)'

alias k=kubectl
alias c=clear

alias gs='git status'
alias gpp='git pull --prune'
alias gp='git pull'
alias gpush='git push'

alias ni='npm install'
alias ns='npm start'
alias nb='npm run build'
alias nd='npm run dev'

alias tk='tmux kill-server'

alias v="nvim +GoToFile"
alias vim="nvim"
alias :GoToFile="nvim +GoToFile"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

alias sz="source ~/.zshrc"

alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --group-directories-first --all --no-permissions" 
alias brewod="brew outdated | fzf --multi | xargs brew upgrade"

function take {
    mkdir -p $1
    cd $1
}

autoload -Uz compinit && compinit

export EDITOR=nvim

# kubectl
source <(kubectl completion zsh)

# fzf
eval "$(fzf --zsh)"

export FZF_DEFAULT_OPTS="--reverse --border rounded --no-info --pointer='👉' --marker=' ' --ansi --color='16,bg+:-1,gutter:-1,prompt:5,pointer:5,marker:6,border:4,label:4,header:italic'"
export FZF_TMUX_OPTS="-p 75%,80%"
export FZF_CTRL_R_OPTS="--border-label=' history ' --prompt='  '"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
export FZF_COMPLETION_OPTS='--border --info=inline'

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

source ~/.config/fzf/fzf-kubectl.sh
source ~/.config/fzf/fzf-git.sh

# direnv
eval "$(direnv hook zsh)"

# pnpm
export PNPM_HOME="~/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

export PATH=~/.local/bin:$PATH
export PATH=~/.config/bin:$PATH

# bun completions
[ -s "~/.bun/_bun" ] && source "~/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

eval "$(zoxide init zsh)"

# starship
eval "$(starship init zsh)"

# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
