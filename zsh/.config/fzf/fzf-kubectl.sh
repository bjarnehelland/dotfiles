pods() {
  kubectl get pods |  fzf --layout=reverse -m --header-lines=1 --info=inline \
    --prompt "[ $RS_TYPE ] CL: $(kubectl config current-context | sed 's/-context$//') NS: $(kubectl config get-contexts | grep "*" | awk '{print $5}')> " \
    --preview-window=right:60% \
    --bind 'ctrl-/:change-preview-window(99%|70%|40%|0|50%)' \
    --bind 'enter:accept' \
    --preview "kubectl describe pod {1} | bat -l yaml --color always"
}

logs() {
  kubectl get pods |  fzf --layout=reverse -m --header-lines=1 --info=inline \
    --prompt "[ $RS_TYPE ] CL: $(kubectl config current-context | sed 's/-context$//') NS: $(kubectl config get-contexts | grep "*" | awk '{print $5}')> " \
    --preview-window=up:follow \
    --bind 'ctrl-/:change-preview-window(99%|70%|40%|0|50%)' \
    --bind 'enter:accept' --preview "kubectl logs --follow {1} "
}
