{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    disableConfirmationPrompt = true;
    clock24 = true;
    keyMode = "vi";
    sensibleOnTop = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    historyLimit = 100000;
    plugins = with pkgs.tmuxPlugins; [
      # tmuxPlugins.tokyo-night-tmux
      # tmux-thumbs
      # cpu
      vim-tmux-navigator
      better-mouse-mode
      sensible
      yank
    ];
    extraConfig = ''

      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -g default-command "$SHELL"
      set-window-option -g mode-keys vi

      bind '%' split-window -c '#{pane_current_path}' -h
      bind '"' split-window -c '#{pane_current_path}'
      bind c new-window -c '#{pane_current_path}'

      bind -N "⌘+g lazygit " g new-window -c "#{pane_current_path}" -n "🌳" "lazygit 2> /dev/null"
      bind -N "⌘+G gh-dash " G new-window -c "#{pane_current_path}" -n "😺" "gh dash 2> /dev/null"
      bind -N "⌘+y yazi" y new-window -c "#{pane_current_path}" -n "😺" "yazi 2> /dev/null"
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
