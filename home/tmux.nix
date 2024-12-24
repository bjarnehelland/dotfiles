{ pkgs, ... }:
{
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
    catppuccin.enable = true;
    aggressiveResize = true;
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.yank
      {
        plugin = tmuxPlugins.catppuccin;

        extraConfig = ''
          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_window_number_position "left"
          set -g @catppuccin_window_status_enable "yes"
          set -g @catppuccin_window_status_icon_enable "no"
          set -g @catppuccin_directory_text "#{pane_current_path}"
        '';
      }
    ];
    extraConfig = ''
      # set -g default-terminal "tmux-256color"
      # set -ag terminal-overrides ",xterm-256color:RGB"
      set -sa terminal-overrides ",xterm*:Tc"
      set -g default-command "$SHELL"

      set -g detach-on-destroy off        
      set -g renumber-windows on 
      set -g set-clipboard on
      set -g status-position top

      # set -g status-right-length 100
      # set -g status-left-length 100    
      # set -g status-left "#{E:@catppuccin_status_session}"
      # set -g status-right "#{E:@catppuccin_status_application}"

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
