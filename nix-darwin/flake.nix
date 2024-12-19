{
  description = "Bjarne macOS configuration";

  inputs = {
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.vim
          pkgs.kubectl
          pkgs.sshs
          pkgs.atac
          pkgs.portal
          pkgs.tmux
        ];

      services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";
      programs.zsh.enable = true;  # default shell on catalina
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;
      nixpkgs.hostPlatform = "aarch64-darwin";
      security.pam.enableSudoTouchIdAuth = true;

      users.users.bjarnehelland.home = "/Users/bjarnehelland";
      home-manager.backupFileExtension = "backup";
      nix.configureBuildUsers = true;
      nix.useDaemon = true;

      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "clmv";
        # loginwindow.LoginwindowText = "stacc.com";
        screencapture.location = "~/Pictures/screenshots";
        screensaver.askForPasswordDelay = 0;
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Bjarnes-MacBook-Pro-2
    darwinConfigurations."Bjarnes-MacBook-Pro-2" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ 
        configuration
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.bjarnehelland = import ./home.nix;
        }
      ];
    
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Bjarnes-MacBook-Pro-2".pkgs;
  };
}
