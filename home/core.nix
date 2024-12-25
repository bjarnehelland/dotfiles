{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    nmap # A utility for network discovery and security auditing
    glow # markdown previewer in terminal
    azure-cli
  ];

  programs = {
  
    # json processor
    jq = {
      enable = true;
    };

    # fast file finder
    fd = {
      enable = true;
    };

    # git ui
    lazygit = {
      enable = true;
    };

    # syntax highlighting for the terminal
    bat = {
      enable = true;
    };

    # modern vim
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = [
        pkgs.vimPlugins.nvim-treesitter.withAllGrammars
      ];
    };

    # A modern replacement for ‘ls’
    # useful in bash/zsh prompt, not in nushell.
    eza = {
      enable = true;
      git = true;
      icons = "auto";
      enableZshIntegration = true;
    };

    # terminal file manager
    yazi = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        manager = {
          show_hidden = true;
          sort_dir_first = true;
        };
      };
    };
    zoxide = {
      enable = true;
    };
    direnv = {
      enable = true;
      config = {
        whitelist = {
          prefix = [ "~/Code/stacc" ];
        };
      };
    };
    fzf = {
      enable = true;
      defaultOptions = [
        "--ansi"
        "--border rounded"
        "--color='16,bg+:-1,gutter:-1,prompt:5,pointer:5,marker:6,border:4,label:4,header:italic'"
        "--marker=' '"
        "--no-info"
        "--no-separator"
        "--pointer='👉'"
        "--reverse"
      ];
    };
    k9s = {
      enable = true;
    };
  };
}
