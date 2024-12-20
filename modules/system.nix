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
      loginwindow.LoginwindowText = "Mr Helland";
      screencapture.location = "~/Pictures/screenshots";
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
          "/Applications/Safari.app"
          "/Applications/Arc.app"
          "/Applications/WezTerm.app"
          "/Applications/Cursor.app"
          "/Applications/Visual Studio Code.app"
          "/Applications/Microsoft Outlook.app"
          "/Applications/Slack.app"
          "/Applications/Notion.app"
          "/Applications/Discord.app"
          "/Applications/ChatGPT.app"
          "/System/Applications/Messages.app"
          "/Applications/1Password.app"
          "/System/Applications/System Settings.app"
        ];
      };
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh.enable = true;

}
