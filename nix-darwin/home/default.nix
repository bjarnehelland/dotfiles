{ username, config, ... }:

{
  # import sub modules
  imports = [
    ./shell.nix
    ./core.nix
    ./git.nix
    ./starship.nix
    ./tmux.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = username;
    homeDirectory = "/Users/${username}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.11";

    file.".local/bin".source = config.lib.file.mkOutOfStoreSymlink "/Users/${username}/dot/bin";
    file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/Users/${username}/dot/nvim";
    file.".config/sesh".source = config.lib.file.mkOutOfStoreSymlink "/Users/${username}/dot/sesh";
    file.".config/wezterm".source =
      config.lib.file.mkOutOfStoreSymlink "/Users/${username}/dot/wezterm";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
