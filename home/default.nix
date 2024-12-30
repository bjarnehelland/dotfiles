{ username, config, ... }:
let
	dotfilesPath = "/Users/${username}/Code/bjarnehelland/dotfiles";
	symlink = config.lib.file.mkOutOfStoreSymlink;
in
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

    file.".local/bin".source = symlink "${dotfilesPath}/config/bin";
    file.".config/nvim".source = symlink "${dotfilesPath}/config/nvim";
    file.".config/sesh".source = symlink "${dotfilesPath}/config/sesh";
    file.".config/wezterm".source = symlink "${dotfilesPath}/config/wezterm";
    file.".config/ghostty/config".source = symlink "${dotfilesPath}/config/ghostty/config";
    file."Library/Application Support/com.elgato.StreamDeck/ProfilesV2".source = symlink "${dotfilesPath}/config/streamdeck/ProfilesV2";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
