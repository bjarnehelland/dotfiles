{ pkgs, lib, ... }:
let
  mapScriptsToPackages = lib.attrsets.mapAttrsToList (pkgs.writeShellScriptBin);
in
{

  home.packages = mapScriptsToPackages {
    git-tmux =
      # sh
      ''
        if [ -d .git ]; then
        	git fetch
        	branch=$(git rev-parse --abbrev-ref HEAD)
        	ahead=$(git rev-list --count origin/"$branch".."$branch")
        	behind=$(git rev-list --count "$branch"..origin/"$branch")
        	echo "$branch $ahead $behind"
        else
        	echo "N/A"
        fi
      '';
  };

  programs.tmux = {
    enable = true;
    disableConfirmationPrompt = true;
    clock24 = true;
    keyMode = "vi";
    sensibleOnTop = true;
    baseIndex = 1;
    mouse = true;
    escapeTime = 0;
    historyLimit = 5000;
    terminal = "xterm-256color";
    aggressiveResize = true;
    focusEvents = true;
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_status_modules_right "gitmux"
          set -g @catppuccin_status_modules_left "session"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_text "#W"

          ### Git
          set -g @catppuccin_gitmux_icon ""
          set -g @catppuccin_gitmux_color "#89dceb" # sky
          set -g @catppuccin_gitmux_text "#(git-tmux)"
        '';
      }
      vim-tmux-navigator
      better-mouse-mode
      yank

    ];
    extraConfig = ''
      set -sa terminal-overrides ",xterm*:Tc"
      set -g default-command "$SHELL"

      set -g detach-on-destroy off        
      set -g renumber-windows on 
      set -g set-clipboard on
      set -g status-position top

      bind '%' split-window -c '#{pane_current_path}' -h
      bind '"' split-window -c '#{pane_current_path}'
      bind c new-window -c '#{pane_current_path}'

      bind -N "⌘+g lazygit " g new-window -c "#{pane_current_path}" -n "🌳" "lazygit 2> /dev/null"
      bind -N "⌘+G gh-dash " G new-window -c "#{pane_current_path}" -n "😺" "gh dash 2> /dev/null"
      bind -N "⌘+b build" B split-window -v -l 10 b
      bind -N "⌘+d dev" D split-window -v -l 10 d

      bind-key "K" run-shell "sesh connect \"$(
        sesh list -ictz | fzf-tmux -p 55%,60% \
          --no-sort --border-label ' sesh ' --prompt '⚡  ' \
          --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
      )\""

      bind-key "Z" display-popup -E "sesh connect \$(sesh list | zf --height 24)"

    '';
  };
}
