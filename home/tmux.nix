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
    plugins = with pkgs.tmuxPlugins; [
      # {
      #   plugin = tokyo-night-tmux;
      #   extraConfig = ''
      #     set -g @tokyo-night-tmux_transparent 1
      #     set -g @tokyo-night-tmux_window_id_style digital
      #     set -g @tokyo-night-tmux_pane_id_style hsquare
      #     set -g @tokyo-night-tmux_zoom_id_style dsquare
      #     set -g @tokyo-night-tmux_show_datetime 0
      #   '';
      # }
      # tmux-thumbs
      # cpu
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_window_status_style "rounded"
          set -agF status-right "#{@catppuccin_status_gitmux}"

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
