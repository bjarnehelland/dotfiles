alias -- ..='cd ..'
alias -- ...='cd ../..'
alias -- ....='cd ../../..'
alias -- .....='cd ../../../..'
alias -- bl='echo "Logging into blocc registry..." && \
az acr login -n blocc --subscription 5b37ef96-b4b4-483f-9955-92f7a3e74ee1 && \
echo "Logging into bloccephe registry..." && \
az acr login -n bloccephe --subscription 5b37ef96-b4b4-483f-9955-92f7a3e74ee1 && \
echo "Logging into bloccdev registry..." && \
az acr login -n bloccdev --subscription 5b37ef96-b4b4-483f-9955-92f7a3e74ee1
'
alias -- brewod='brew outdated | fzf --multi | xargs brew upgrade'
alias -- dive='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v "$(pwd)":"$(pwd)" -w "$(pwd)" -v "$HOME/.dive.yaml":"$HOME/.dive.yaml" wagoodman/dive:latest'
alias -- eza='eza --icons auto --git'
alias -- gp='git pull'
alias -- gpa='git pull --rebase --autostash  --prune'
alias -- gpp='git pull --prune'
alias -- gpush='git push'
alias -- gs='git status'
alias -- k=kubectl
alias -- kc=kubectx
alias -- kn=kubens
alias -- la='eza -a'
alias -- ll='ls -l'
alias -- lla='eza -la'
alias -- ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --group-directories-first --all --no-permissions'
alias -- lt='eza --tree'
alias -- lt2='eza --tree --level=2'
alias -- lt3='eza --tree --level=3'
alias -- lt4='eza --tree --level=4'
alias -- lt5='eza --tree --level=5'
alias -- s='cd "$(zoxide query --list | sed "s|$HOME|~|g" | fzf | sed "s|~|$HOME|g")"'
alias -- sz='source ~/.zshrc'
alias -- take='(){  mkdir -p $1 && cd $_; }'
alias -- vimdiff='nvim -d'
alias -- paths="echo $PATH | tr ':' '\n' | nl"

export PATH="$HOME/.config/bin:$PATH"
export FZF_DEFAULT_OPTS='--ansi --border rounded --color="16,bg+:-1,gutter:-1,prompt:5,pointer:5,marker:6,border:4,label:4,header:italic" --marker=" " --no-info --no-separator --pointer="👉" --reverse'

source <(fzf --zsh)


eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(~/.local/bin/mise activate zsh)"
