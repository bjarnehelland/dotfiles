# Sourced by every zsh, interactive or not. PATH belongs here rather than in
# .zshrc so anything spawned without an interactive shell — Herdr popups and
# custom commands, $EDITOR subprocesses, launchd jobs — still finds
# ~/.config/bin. .zprofile keeps the full `brew shellenv` for login shells;
# the two bin dirs below are what non-login shells need from it.
typeset -U path PATH
path=("$HOME/.local/bin" "$HOME/.config/bin" /opt/homebrew/bin /opt/homebrew/sbin "$HOME/.dotnet/tools" $path)

# pnpm: globally installed packages (`pnpm add -g`) land in $PNPM_HOME/bin.
export PNPM_HOME="$HOME/Library/pnpm"
path=("$PNPM_HOME/bin" $path)

# .NET: global tools (`dotnet tool install -g`) land in ~/.dotnet/tools above.
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_NOLOGO=1

# Here for the same reason: the `s` launcher runs in a Herdr popup, outside
# any interactive shell, and should look like the pickers at the prompt.
export FZF_DEFAULT_OPTS='--ansi --border rounded --color="16,bg+:-1,gutter:-1,prompt:5,pointer:5,marker:6,border:4,label:4,header:italic" --marker=" " --no-info --no-separator --pointer="👉" --reverse'

# Vite+ bin (https://viteplus.dev), when installed.
[ -f "$HOME/.config/vite-plus/env" ] && . "$HOME/.config/vite-plus/env"
