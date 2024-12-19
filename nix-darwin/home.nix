# home.nix
# home-manager switch 

{ config, pkgs, ... }:

{
  home.username = "bjarnehelland";
  home.homeDirectory = "/Users/bjarnehelland";
  home.stateVersion = "23.05"; # Please read the comment before changing.

# Makes sense for user specific applications that shouldn't be available system-wide
  home.packages = [
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  # home.file = {
  #   ".zshrc".source = ~/dotfiles/zshrc/.zshrc;
  #   ".config/wezterm".source = ~/dotfiles/wezterm;
  #   ".config/skhd".source = ~/dotfiles/skhd;
  #   ".config/starship".source = ~/dotfiles/starship;
  #   ".config/zellij".source = ~/dotfiles/zellij;
  #   ".config/nvim".source = ~/dotfiles/nvim;
  #   ".config/nix".source = ~/dotfiles/nix;
  #   ".config/nix-darwin".source = ~/dotfiles/nix-darwin;
  #   ".config/tmux".source = ~/dotfiles/tmux;
  # };

  home.sessionVariables = {
  };

  # home.sessionPath = [
  #   "/run/current-system/sw/bin"
  #     "$HOME/.nix-profile/bin"
  # ];
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting = {
      enable = true;
    };
    shellAliases = {
      ll = "ls -l";
      s = "sesh connect $(sesh list | fzf)";
      k = "kubectl";
      gs = "git status";
      gpp = "git pull --prune";
      gp = "git pull";
      gpush = "git push";
      
      sz = "source ~/.zshrc";

      ls = "eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --group-directories-first --all --no-permissions";
      brewod = "brew outdated | fzf --multi | xargs brew upgrade";

      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
    };
    initExtra = ''
      # fzf
      export FZF_COMPLETION_OPTS='--border --info=inline'

      # Use fd (https://github.com/sharkdp/fd) for listing path candidates.
      # - The first argument to the function ($1) is the base path to start traversal
      # - see the source code (completion.{bash,zsh}) for the details.
      _fzf_compgen_path() {
        fd --hidden --follow --exclude ".git" . "$1"
      }

      # use fd to generate the list for directory completion
      _fzf_compgen_dir() {
        fd --type d --hidden --follow --exclude ".git" . "$1"
      }

      # advanced customization of fzf options via _fzf_comprun function
      # - the first argument to the function is the name of the command.
      # - you should make sure to pass the rest of the arguments to fzf.
      _fzf_comprun() {
        local command=$1
        shift

        case "$command" in
          cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
          export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
          ssh)          fzf --preview 'dig {}'                   "$@" ;;
          *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
        esac
      }

      export VOLTA_HOME="$HOME/.volta"
      export PATH="$VOLTA_HOME/bin:$PATH"
      export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
    '';
  };
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
    defaultOptions = [ "--reverse --border rounded --no-info --pointer='👉' --marker=' ' --ansi --color='16,bg+:-1,gutter:-1,prompt:5,pointer:5,marker:6,border:4,label:4,header:italic'" ];
    changeDirWidgetCommand = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
    changeDirWidgetOptions = [ "--preview 'eza --tree --color=always {} | head -200'" ];
    historyWidgetOptions = [ "--border-label=' history ' --prompt='  '" ];
    fileWidgetCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
    fileWidgetOptions = [ "--preview 'bat -n --color=always --line-range :500 {}'" ];
    tmux = {
      enableShellIntegration = true;
      shellIntegrationOptions = [ "-p 75%,80%" ];
    };
  };
  programs.starship = {
    enable = true;
    settings = {
      # add_newline = false;

      # character = {
      #   success_symbol = "[\uf054](white)"; 
      #   vicmd_symbol = "[\ue62b](white)";
      #   error_symbol = "[\uf467](red)";
      # };

      # package.disabled = true;
      directory.style = "blue bold";
      package.disabled = true;
      username.disabled = true;
      hostname.disabled = true;
      aws.disabled = true;
      docker_context.disabled = true;
      git_branch.disabled = true;
      git_commit.disabled = true;
      git_state.disabled = true;
      git_metrics.disabled = true;
      git_status.disabled = true;
      kubernetes = {
        disabled = false;
        contexts = [
          {
            context_pattern = "k8s-login-lba-link-stacc-dev-context";
            style = "bold green";
            context_alias = "LBA";
          }
          {
            context_pattern = "k8s-flow-login-test-1-opf-stacc-dev-context";
            style = "bold green";
            context_alias = "OPF";
          } 
          {
            context_pattern = "scc-prod-opf-01-aks-admin";
            style = "bold red";
            context_alias = "OPF";
          }
        ];
      };
    };
  };
  programs.zoxide = {
    enable = true;
  };
  programs.direnv = {
    enable = true;
  };
}
