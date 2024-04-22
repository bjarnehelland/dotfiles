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
export FZF_TMUX_OPTS="-p 55%,60%"
export FZF_CTRL_R_OPTS="--border-label=' history ' --prompt='  '"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

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
