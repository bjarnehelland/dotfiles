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
alias -- s='sesh connect $(sesh list -i | fzf)'
alias -- sz='source ~/.zshrc'
alias -- take='(){  mkdir -p $1 && cd $_; }'
alias -- vimdiff='nvim -d'

eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"