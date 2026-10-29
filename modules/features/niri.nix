{ self, inputs, ... }:
{
  flake.nixosModules.niri =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      shellSettings = import ../../lib/niri-shell-settings.nix {
        inherit
          config
          inputs
          lib
          pkgs
          ;
      };

      mkNiriWrapper =
        variantSettings:
        inputs.wrapper-modules.wrappers.niri.wrap {
          inherit pkgs;
          settings = lib.recursiveUpdate variantSettings (
            if config.my.desktop.niri.displaySettings == null then
              { }
            else
              config.my.desktop.niri.displaySettings
          );
        };

      niriNoctaliaWrapper = mkNiriWrapper shellSettings.noctaliaSettings;

      niriNoctaliaSessionScript = pkgs.writeShellScript "niri-noctalia-v5-session" ''
        export NOCTALIA_CONFIG_HOME="$HOME/.config/noctalia-v5-clean"
        export NOCTALIA_STATE_HOME="$HOME/.local/state/noctalia-v5-clean"
        mkdir -p "$NOCTALIA_STATE_HOME"
        if [ ! -e "$NOCTALIA_STATE_HOME/noctalia" ] && [ -e "$XDG_RUNTIME_DIR/noctalia-v5-clean-state/noctalia" ]; then
          cp -a "$XDG_RUNTIME_DIR/noctalia-v5-clean-state/noctalia" "$NOCTALIA_STATE_HOME/noctalia"
        fi
        exec ${niriNoctaliaWrapper}/bin/niri-session
      '';

      niriSessions =
        pkgs.runCommand "niri-sessions"
          {
            passthru.providedSessions = [
              "niri-noctalia-v5"
            ];
          }
          ''
            mkdir -p "$out/bin" "$out/share/wayland-sessions"

            install -m755 ${niriNoctaliaSessionScript} "$out/bin/niri-noctalia-v5-session"

            cat > "$out/share/wayland-sessions/niri-noctalia-v5.desktop" <<EOF
            [Desktop Entry]
            Name=Niri + Noctalia v5
            Comment=Niri compositor with the Noctalia v5 shell
            Exec=$out/bin/niri-noctalia-v5-session
            Type=Application
            EOF
          '';
    in
    {
      options.my.desktop.niri.displaySettings = lib.mkOption {
        type = lib.types.nullOr lib.types.attrs;
        default = null;
        description = "Host-specific declarative Niri display settings.";
      };

      config.environment.systemPackages = [
        shellSettings.niriSidebar
      ];

      config.programs.niri = {
        enable = true;
        package = niriNoctaliaWrapper;
      };

      config.services.displayManager.sessionPackages = [
        niriSessions
      ];
    };

}
