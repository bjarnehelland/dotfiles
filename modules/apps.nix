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
    git
    nixfmt-rfc-style
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  # TODO To make this work, homebrew need to be installed manually, see https://brew.sh
  #
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;# Fetch the newest stable branch of Homebrew's git repo
      upgrade = true;# Upgrade outdated casks, formulae, and App Store apps
      # 'zap': uninstalls all formulae(and related files) not listed here.
      cleanup = "zap";
    };

    taps = [
      "homebrew/services"
      "oven-sh/bun"
      "stacc/tap"
      "joshmedeski/sesh"
    ];

    # `brew install`
    # TODO Feel free to add your favorite apps here.
    brews = [
      "deno"
      "oven-sh/bun/bun"
      "stacc/tap/blocc"
      "stacc/tap/stacc-next"
      "joshmedeski/sesh/sesh"
    ];

    # `brew install --cask`
    # TODO Feel free to add your favorite apps here.
    casks = [
      "discord"
      "wezterm"
      "docker"
      "google-chrome"
      "arc"
      "slack"
      "microsoft-auto-update"
      "microsoft-teams"
      "microsoft-outlook"
      "microsoft-word"
      "microsoft-excel"
      "microsoft-powerpoint"
      "1password"
      "notion"
      "raycast"
      "bruno"
      "cursor"
      "visual-studio-code"
    ];
  };
}
