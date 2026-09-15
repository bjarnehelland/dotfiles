# Sourced by every zsh, interactive or not. PATH belongs here rather than in
# .zshrc so anything spawned without an interactive shell — Herdr popups and
# custom commands, $EDITOR subprocesses, launchd jobs — still finds
# ~/.config/bin. .zprofile keeps the full `brew shellenv` for login shells;
# the two bin dirs below are what non-login shells need from it.
typeset -U path PATH
path=("$HOME/.local/bin" "$HOME/.config/bin" /opt/homebrew/bin /opt/homebrew/sbin $path)

# Here for the same reason: the `s` launcher runs in a Herdr popup, outside
# any interactive shell, and should look like the pickers at the prompt.
export FZF_DEFAULT_OPTS='--ansi --border rounded --color="16,bg+:-1,gutter:-1,prompt:5,pointer:5,marker:6,border:4,label:4,header:italic" --marker=" " --no-info --no-separator --pointer="👉" --reverse'
