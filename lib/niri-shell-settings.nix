{
  config,
  inputs,
  lib,
  pkgs,
}:
let
  system = pkgs.stdenv.hostPlatform.system;

  inirPackage = inputs.inir.packages.${system}.default;
  inirExe = lib.getExe inirPackage;
  inirCommand = args: lib.escapeShellArgs ([ inirExe ] ++ args);

  noctaliaPackage = inputs.noctalia.packages.${system}.default;
  noctaliaExe = lib.getExe noctaliaPackage;
  networkManagerAppletExe = lib.getExe pkgs.networkmanagerapplet;

  dmsPackage = inputs.dms.packages.${system}.default;
  dmsExe = lib.getExe dmsPackage;

  niriSidebar = pkgs.rustPlatform.buildRustPackage {
    pname = "niri-sidebar";
    version = "unstable-2026-05-16";

    src = pkgs.fetchFromGitHub {
      owner = "Vigintillionn";
      repo = "niri-sidebar";
      rev = "954f62e7e395ae14f01af582296e25a548133dc0";
      hash = "sha256-MYP1ZiwV9+yJhl0zpuri6NQkQHlaYZjGBhXpZEaPZyI=";
    };

    cargoHash = "sha256-zZlfwAxWE1ZZy6k7QoBOamCGigGShd89sD27vfvgR00=";

    meta.mainProgram = "niri-sidebar";
  };
  niriSidebarExe = lib.getExe niriSidebar;

  commonBinds = {
    "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
    "Mod+Q".close-window = { };
    "Mod+E".spawn-sh = lib.getExe pkgs.nautilus;
    "Mod+P".screenshot = { };
    "Mod+Shift+P".screenshot-screen = { };
    "Mod+Ctrl+P".screenshot-window = { };

    "Mod+Left".focus-column-left = { };
    "Mod+Right".focus-column-right = { };
    "Mod+WheelScrollLeft".focus-column-left = { };
    "Mod+WheelScrollRight".focus-column-right = { };
    "Mod+Up".focus-window-up = { };
    "Mod+Down".focus-window-down = { };
    "Mod+WheelScrollUp".focus-window-up = { };
    "Mod+WheelScrollDown".focus-window-down = { };

    "Mod+Alt+Left".focus-monitor-left = { };
    "Mod+Alt+Right".focus-monitor-right = { };
    "Mod+Alt+WheelScrollLeft".focus-monitor-left = { };
    "Mod+Alt+WheelScrollRight".focus-monitor-right = { };
    "Mod+Alt+Shift+Left".move-window-to-monitor-left = { };
    "Mod+Alt+Shift+Right".move-window-to-monitor-right = { };
    "Mod+Alt+Shift+WheelScrollLeft".move-window-to-monitor-left = { };
    "Mod+Alt+Shift+WheelScrollRight".move-window-to-monitor-right = { };

    "Mod+Shift+Left".move-column-left = { };
    "Mod+Shift+Right".move-column-right = { };
    "Mod+Shift+WheelScrollLeft".move-column-left = { };
    "Mod+Shift+WheelScrollRight".move-column-right = { };
    "Mod+Shift+Up".move-window-up = { };
    "Mod+Shift+Down".move-window-down = { };
    "Mod+Shift+WheelScrollUp".move-window-up = { };
    "Mod+Shift+WheelScrollDown".move-window-down = { };

    "Mod+W".toggle-column-tabbed-display = { };
    "Mod+A".consume-window-into-column = { };
    "Mod+Shift+A".expel-window-from-column = { };
    "Mod+R".switch-preset-column-width = { };
    "Mod+Shift+R".switch-preset-column-width-back = { };
    "Mod+V".switch-preset-window-height = { };
    "Mod+Shift+V".switch-preset-window-height-back = { };
    "Mod+Ctrl+V".reset-window-height = { };

    "Mod+1".focus-workspace = 1;
    "Mod+2".focus-workspace = 2;
    "Mod+3".focus-workspace = 3;
    "Mod+4".focus-workspace = 4;
    "Mod+5".focus-workspace = 5;
    "Mod+Page_Down".focus-workspace-down = { };
    "Mod+Page_Up".focus-workspace-up = { };
    "Mod+Tab".focus-workspace-previous = { };

    "Mod+Shift+1".move-column-to-workspace = 1;
    "Mod+Shift+2".move-column-to-workspace = 2;
    "Mod+Shift+3".move-column-to-workspace = 3;
    "Mod+Shift+4".move-column-to-workspace = 4;
    "Mod+Shift+5".move-column-to-workspace = 5;
    "Mod+Shift+Page_Down".move-window-to-workspace-down = { };
    "Mod+Shift+Page_Up".move-window-to-workspace-up = { };

    "Mod+F".maximize-column = { };
    "Mod+Shift+F".fullscreen-window = { };
    "Mod+Ctrl+F".maximize-window-to-edges = { };

    "Mod+Space".toggle-overview = { };
    "Mod+Shift+Space".toggle-window-floating = { };

    "Mod+B".spawn-sh = "${niriSidebarExe} toggle-window";
    "Mod+Shift+B".spawn-sh = "${niriSidebarExe} toggle-visibility";
    "Mod+Ctrl+B".spawn-sh = "${niriSidebarExe} flip";
    "Mod+Alt+B".spawn-sh = "${niriSidebarExe} reorder";

    "Mod+L".spawn-sh = "loginctl lock-session";
    "Mod+Alt+L".spawn-sh = "loginctl lock-session";

    "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
    "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
    "XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
  };

  baseSettings = {
    spawn-at-startup = [
      [
        niriSidebarExe
        "listen"
      ]
    ];
    xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
    input.keyboard.xkb = {
      layout = config.my.host.keyboard.layout;
      variant = config.my.host.keyboard.variant;
    };
    input.touchpad = {
      tap = _: { };
      natural-scroll = _: { };
    };
    layout = {
      gaps = 18;
      focus-ring = {
        width = 2;
        active-color = "#ffffff";
      };
      border.off = _: { };
    };
    prefer-no-csd = true;
    blur = {
      passes = 2;
      offset = 1.5;
      noise = 0.01;
      saturation = 1.0;
    };
    window-rules = [
      {
        matches = [ { app-id = ".*"; } ];
        opacity = 0.90;
        geometry-corner-radius = 1;
        clip-to-geometry = true;
        draw-border-with-background = false;
        background-effect.blur = true;
        popups = {
          opacity = 0.95;
          geometry-corner-radius = 1;
          background-effect = {
            xray = true;
            blur = true;
          };
        };
      }
      {
        matches = [
          { app-id = "brave-browser"; }
          { app-id = "Brave-browser"; }
          { app-id = "firefox"; }
          { app-id = "chromium-browser"; }
          { app-id = "chromium"; }
          { app-id = "google-chrome"; }
          { app-id = "zen"; }
        ];
        opacity = 1.0;
      }
      {
        matches = [
          { app-id = "discord"; }
          { app-id = "Discord"; }
        ];
        opacity = 1.0;
        background-effect.blur = false;
        popups.background-effect.blur = false;
      }
      {
        matches = [ { is-floating = true; } ];
        min-width = 100;
        min-height = 100;
      }
    ];
    binds = commonBinds;
  };

  inirBinds = {
    "Mod+S".spawn-sh = inirCommand [
      "overview"
      "toggle"
    ];
    "Mod+Shift+S".spawn-sh = inirCommand [
      "region"
      "screenshot"
    ];
    "Mod+Shift+X".spawn-sh = inirCommand [
      "region"
      "ocr"
    ];
    "Mod+Alt+A".spawn-sh = inirCommand [
      "region"
      "search"
    ];
    "Mod+G".spawn-sh = inirCommand [
      "overlay"
      "toggle"
    ];
    "Mod+Alt+V".spawn-sh = inirCommand [
      "clipboard"
      "toggle"
    ];
    "Mod+Comma".spawn-sh = inirCommand [ "settings" ];
    "Mod+Slash".spawn-sh = inirCommand [
      "cheatsheet"
      "toggle"
    ];
    "Ctrl+Alt+T".spawn-sh = inirCommand [
      "wallpaperSelector"
      "toggle"
    ];
    "Mod+Shift+W".spawn-sh = inirCommand [
      "panelFamily"
      "cycle"
    ];
    "Mod+Shift+Q".spawn-sh = inirCommand [
      "session"
      "toggle"
    ];
    "Alt+Tab".spawn-sh = inirCommand [
      "altSwitcher"
      "next"
    ];
    "Alt+Shift+Tab".spawn-sh = inirCommand [
      "altSwitcher"
      "previous"
    ];
  };

  noctaliaBinds = {
    "Mod+S".spawn-sh = "${noctaliaExe} msg panel-toggle launcher";
  };

  dmsBinds = {
    "Mod+S".spawn-sh = "${dmsExe} ipc call spotlight toggle";
  };
in
rec {
  inherit
    baseSettings
    commonBinds
    dmsBinds
    dmsExe
    dmsPackage
    inirBinds
    inirExe
    inirPackage
    niriSidebar
    noctaliaBinds
    noctaliaExe
    noctaliaPackage
    ;

  dmsOutputsPath = "${config.my.host.homeDirectory}/.config/niri/dms/outputs.kdl";

  inirSettings = lib.recursiveUpdate baseSettings {
    spawn-at-startup = baseSettings.spawn-at-startup ++ [
      [
        inirExe
        "run"
        "--session"
      ]
    ];
    binds = inirBinds;
  };

  noctaliaSettings = lib.recursiveUpdate baseSettings {
    spawn-at-startup = baseSettings.spawn-at-startup ++ [
      [ networkManagerAppletExe "--indicator" ]
      [ noctaliaExe ]
    ];
    binds = noctaliaBinds;
  };

  dmsSettings = lib.recursiveUpdate baseSettings {
    spawn-at-startup = baseSettings.spawn-at-startup ++ [
      [
        dmsExe
        "run"
        "--session"
      ]
    ];
    binds = dmsBinds;
  };
}
