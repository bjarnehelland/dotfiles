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
    aggressiveResize = true;
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_status_modules_right "session gitmux"
          set -g @catppuccin_status_modules_left "application"
          set -g @catppuccin_pane_status_enabled "yes"
        '';
      }
      vim-tmux-navigator
      better-mouse-mode
      yank
  
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
