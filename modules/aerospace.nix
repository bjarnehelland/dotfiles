{ ... }:
{
  services.aerospace = {
    enable = true;

    settings = {
      accordion-padding = 30;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      #on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
      # on-focus-changed = [ "move-mouse window-lazy-center" ];
      after-startup-command = [
        "exec-and-forget sketchybar"
        "exec-and-forget borders"
      ];

      on-focus-changed = [
        "exec-and-forget osascript -e 'tell application id \"tracesOf.Uebersicht\" to refresh widget id \"simple-bar-index-jsx\"'"
      ];

      exec-on-workspace-change = [
        "/bin/zsh"
        "-c"
        "/usr/bin/osascript -e 'tell application id \"tracesOf.Uebersicht\" to refresh widget id \"simple-bar-index-jsx\"'"
      ];

      gaps = {
        outer.top = 24;
        outer.right = 24;
        outer.bottom = 24;
        outer.left = 24;
        inner.horizontal = 24;
        inner.vertical = 24;
      };
      workspace-to-monitor-force-assignment = {
        "7" = "secondary";
        "8" = "secondary";
        "9" = "secondary";
      };

      mode.main.binding = {
        # See: https://nikitabobko.github.io/AeroSpace/commands#layout
        alt-slash = "layout tiles horizontal vertical";
        alt-comma = "layout accordion horizontal vertical";

        # See: https://nikitabobko.github.io/AeroSpace/commands#focus
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";

        alt-shift-minus = "resize smart -50";
        alt-shift-equal = "resize smart +50";

        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";

        alt-shift-1 = [
          "move-node-to-workspace 1"
          "workspace 1"
        ];
        alt-shift-2 = [
          "move-node-to-workspace 2"
          "workspace 2"
        ];
        alt-shift-3 = [
          "move-node-to-workspace 3"
          "workspace 3"
        ];
        alt-shift-4 = [
          "move-node-to-workspace 4"
          "workspace 4"
        ];
        alt-shift-5 = [
          "move-node-to-workspace 5"
          "workspace 5"
        ];
        alt-shift-6 = [
          "move-node-to-workspace 6"
          "workspace 6"
        ];
        alt-shift-7 = [
          "move-node-to-workspace 7"
          "workspace 7"
        ];
        alt-shift-8 = [
          "move-node-to-workspace 8"
          "workspace 8"
        ];
        alt-shift-9 = [
          "move-node-to-workspace 9"
          "workspace 9"
        ];

        alt-tab = "workspace-back-and-forth";
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        alt-shift-semicolon = [ "mode service" ];
      };
      mode.service.binding = {
        esc = [ "mode main" ];
        r = [
          "flatten-workspace-tree"
          "mode main"
        ];
        f = [
          "layout floating tiling"
          "mode main"
        ];
        alt-h = "join-with left";
        alt-j = "join-with down";
        alt-k = "join-with up";
        alt-l = "join-with right";
      };
    };
  };
  services.jankyborders = {
    enable = true;
    hidpi = true;
    style = "round";
    width = 6.0;
    active_color = "0xfff7768e";
    inactive_color = "0xff7aa2f7";
  };
}
