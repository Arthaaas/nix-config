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
      graphicalDisplays = config.my.desktop.niri.displaySettings == null;
      # O Niri observa monitor.kdl. Evita que a GUI troque a configuracao
      # completa do wrapper pelo config.kdl local ao clicar em Apply.
      nwgDisplays = pkgs.nwg-displays.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          substituteInPlace nwg_displays/tools.py \
            --replace-fail 'def niri_reload_config():' 'def niri_reload_config():
              return  # O wrapper Nix usa o hot reload do include.
          '
        '';
      });
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
            if graphicalDisplays then
              {
                extraConfig = (variantSettings.extraConfig or "") + ''
                  include optional=true "~/.config/niri/monitor.kdl"
                '';
              }
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
        description = "Host-specific declarative Niri display settings; null enables nwg-displays with a writable monitor.kdl.";
      };

      config.environment.systemPackages = [
        shellSettings.niriSidebar
      ]
      ++ lib.optionals graphicalDisplays [ nwgDisplays ];

      config.programs.niri = {
        enable = true;
        package = niriNoctaliaWrapper;
      };

      config.services.displayManager.sessionPackages = [
        niriSessions
      ];
    };

}
