alias -- ..='cd ..'
alias -- ...='cd ../..'
alias -- ....='cd ../../..'
alias -- .....='cd ../../../..'
alias -- brewod='brew outdated | fzf --multi | xargs brew upgrade'
alias -- bbs='bs --beta'
alias -- c='clear'
alias -- cl='claude --chrome'
alias -- cld='claude --dangerously-skip-permissions --chrome'
alias -- connect='az account set --subscription $(az account list --query "[].[isDefault, name, id]" -o tsv | awk -F"\t" "{printf \"%s %-40s  %s\n\", (tolower(\$1)==\"true\" ? \"*\" : \" \"), \$2, \$3}" | fzf | awk "{print \$NF}")'
alias -- dive='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v "$(pwd)":"$(pwd)" -w "$(pwd)" -v "$HOME/.dive.yaml":"$HOME/.dive.yaml" wagoodman/dive:latest'
alias -- eza='eza --icons auto --git'
alias -- g='lazygit'
alias -- gp='git pull'
alias -- gpa='git pull --rebase --autostash  --prune'
alias -- gpp='git pull --prune'
alias -- gpush='git push'
alias -- gs='git status'
alias -- k=kubectl
alias -- kc=kubectx
alias -- kn=kubens
alias -- kk='k9s -c pod'
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
alias -- bpmn='files=$(fd -e bpmn); [ -z "$files" ] && echo "🔍 no diagrams found" || { file=$(echo "$files" | awk -F/ '\''{print $NF"\t"$0}'\'' | fzf --with-nth=1 -d$'\''\t'\'' | cut -f2) && [ -n "$file" ] && open "$file"; }'
alias -- dmn='files=$(fd -e dmn); [ -z "$files" ] && echo "🔍 no diagrams found" || { file=$(echo "$files" | awk -F/ '\''{paths[NR]=$0; files[NR]=$NF; count[$NF]++} END{for(i=1;i<=NR;i++){if(count[files[i]]>1){n=split(paths[i],a,"/"); print files[i]"\t"a[n-1]"/"a[n]"\t"paths[i]}else{print files[i]"\t"files[i]"\t"paths[i]}}}'\'' | sort -t$'\''\t'\'' -k1 | cut -f2- | fzf --with-nth=1 -d$'\''\t'\'' | cut -f2) && [ -n "$file" ] && open "$file"; }'

export PATH="$HOME/.config/bin:$PATH"
export FZF_DEFAULT_OPTS='--ansi --border rounded --color="16,bg+:-1,gutter:-1,prompt:5,pointer:5,marker:6,border:4,label:4,header:italic" --marker=" " --no-info --no-separator --pointer="👉" --reverse'
export EDITOR=nvim
source <(fzf --zsh)
source ~/Code/playgrounds/flow-dev/flow-dev/completions/_flow-dev

eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(~/.local/bin/mise activate zsh)"



[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
