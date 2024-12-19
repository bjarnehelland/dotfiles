{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    disableConfirmationPrompt = true;
    customPaneNavigationAndResize = true;
    clock24 = true;
    keyMode = "vi";
    sensibleOnTop = true;
    shell = "\${pkgs.zsh}/bin/zsh";
  };
}
