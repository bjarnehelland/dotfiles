{ pkgs, ... }:

###################################################################################
#
#  macOS's System configuration
#
#  All the configuration options are documented here:
#    https://daiderd.com/nix-darwin/manual/index.html#sec-options
#
###################################################################################
{
  system = {
    stateVersion = 5;
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    startup.chime = false;

    defaults = {
      menuExtraClock.Show24Hour = true;
      loginwindow.LoginwindowText = "Yo";
      # screencapture.target = "clipboard";
      screensaver.askForPasswordDelay = 10;
      finder = {
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "clmv";
      };
      dock = {
        autohide = true;
        mru-spaces = false;
        tilesize = 32;
        persistent-apps = [
          "/System/Applications/Launchpad.app"
          "/Applications/Arc.app"
          "/System/Cryptexes/App/System/Applications/Safari.app"
          "/Applications/Bruno.app"
          "/Applications/Ghostty.app"
          "/Applications/Warp.app"
          "/Applications/Cursor.app"
          "/Applications/Slack.app"
          "/Applications/Notion.app"
          "/Applications/1Password.app"
          "/Applications/ChatGPT.app"
          "/Applications/Microsoft Teams.app"
          "/Applications/Microsoft Outlook.app"
          "/Applications/Discord.app"
          "/Applications/Spotify.app"
          "/System/Applications/Messages.app"
          "/System/Applications/System Settings.app"
        ];
      };
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
      NSGlobalDomain = {
        _HIHideMenuBar = true;
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };
  security.pam.services.sudo_local.touchIdAuth = true;
  # Add ability to used TouchID for sudo authentication
  # security.pam.enableSudoTouchIdAuth = true;
  # Hack to make pam-reattach work
  environment.etc."pam.d/sudo_local".text = ''
    # Written by nix-darwin
    auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
    auth       sufficient     pam_tid.so
  '';

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh.enable = true;

}
