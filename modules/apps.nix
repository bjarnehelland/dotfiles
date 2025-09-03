{ pkgs, fonts, ... }:
{

  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  # TODO Fell free to modify this file to fit your needs.
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    wget
    git
    nixfmt-rfc-style
    pam-reattach
    kubectx
    kubelogin
    go
    rustup
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # TODO To make this work, homebrew need to be installed manually, see https://brew.sh
  #
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true; # Fetch the newest stable branch of Homebrew's git repo
      upgrade = true; # Upgrade outdated casks, formulae, and App Store apps
      # 'zap': uninstalls all formulae(and related files) not listed here.
      cleanup = "zap";
    };

    taps = [
      "oven-sh/bun"
      "stacc/tap"
      "joshmedeski/sesh"
    ];

    # `brew install`
    # TODO Feel free to add your favorite apps here.
    brews = [
      "node"
      "fnm"
      "deno"
      "oven-sh/bun/bun"
      "stacc/tap/blocc"
      "stacc/tap/stacc-next"
      "joshmedeski/sesh/sesh"
      "helm"
      "helmfile"
      "cue"
      "pnpm"
      "yarn"
      "stern"
      "killport"
      "gum"
      "lazydocker"
      "gettext"
      "kind"
      "dnsmasq"
    ];

    # `brew install --cask`
    # TODO Feel free to add your favorite apps here.
    casks = [
      "runjs"
      "figma"
      "discord"
      "ghostty"
      "warp"
      "google-chrome"
      "arc"
      "slack"
      "1password"
      "1password-cli"
      "notion"
      "raycast"
      "bruno"
      "postman"
      "notchnook"
      "cursor"
      "visual-studio-code"
      "chatgpt"
      "claude"
      "ollama"
      "tableplus"
      "raindropio"
      "vibetunnel"
      "spotify"
      "elgato-stream-deck"
      "pgadmin4"
      "camunda-modeler"
      "font-sf-pro"
      "blender"
      "bettertouchtool"
      "orbstack"
      "microsoft-teams"
      "microsoft-outlook"
      "microsoft-word"
      "microsoft-excel"
      "microsoft-powerpoint"
      "microsoft-auto-update"
    ];

    masApps = {
      "amphetamine" = 937984704;
      "boop" = 1518425043;
    };
  };
}
