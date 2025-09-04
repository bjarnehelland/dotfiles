alias -- ..='cd ..'
alias -- ...='cd ../..'
alias -- ....='cd ../../..'
alias -- .....='cd ../../../..'
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

klog() {
    local namespace=${1:-$(kubectl config view --minify -o jsonpath='{..namespace}')}
    namespace=${namespace:-default}
    
    local pod=$(kubectl get pods -n "$namespace" --no-headers | \
        fzf --height 100% \
            --border \
            --header="Namespace: $namespace | Ctrl-R: refresh | Alt-↑/↓: scroll preview" \
            --prompt="Select pod: " \
            --preview="kubectl describe pod -n $namespace {1}" \
            --preview-window=right:50%:wrap \
            --bind="ctrl-r:reload(kubectl get pods -n $namespace --no-headers)" \
            --bind="alt-up:preview-up" \
            --bind="alt-down:preview-down" \
            --bind="ctrl-/:toggle-preview" | \
        awk '{print $1}')
    
    if [ -n "$pod" ]; then
        echo "Tailing logs for pod: $pod in namespace: $namespace"
        stern "$pod" -n "$namespace"
    fi
}


export PATH="$HOME/.config/bin:$PATH"
export FZF_DEFAULT_OPTS='--ansi --border rounded --color="16,bg+:-1,gutter:-1,prompt:5,pointer:5,marker:6,border:4,label:4,header:italic" --marker=" " --no-info --no-separator --pointer="👉" --reverse'

source <(fzf --zsh)


eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(~/.local/bin/mise activate zsh)"
