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
          extraSettings = lib.optionals (config.my.desktop.niri.displaySettings == null) [
            {
              include = [
                { optional = true; }
                shellSettings.dmsOutputsPath
              ];
            }
          ];
        };

      niriInirWrapper = mkNiriWrapper shellSettings.inirSettings;
      niriNoctaliaWrapper = mkNiriWrapper shellSettings.noctaliaSettings;
      niriDmsWrapper = mkNiriWrapper shellSettings.dmsSettings;

      niriInirSessionScript = pkgs.writeShellScript "niri-inir-session" ''
        exec ${niriInirWrapper}/bin/niri --session
      '';
      niriNoctaliaSessionScript = pkgs.writeShellScript "niri-noctalia-v5-session" ''
        export NOCTALIA_CONFIG_HOME="$HOME/.config/noctalia-v5-clean"
        export NOCTALIA_STATE_HOME="$XDG_RUNTIME_DIR/noctalia-v5-clean-state"
        mkdir -p "$NOCTALIA_STATE_HOME"
        exec ${niriNoctaliaWrapper}/bin/niri --session
      '';
      niriDmsSessionScript = pkgs.writeShellScript "niri-dms-session" ''
        exec ${niriDmsWrapper}/bin/niri --session
      '';

      niriSessions =
        pkgs.runCommand "niri-sessions"
          {
            passthru.providedSessions = [
              "niri-inir"
              "niri-noctalia-v5"
              "niri-dms"
            ];
          }
          ''
            mkdir -p "$out/bin" "$out/share/wayland-sessions"

            install -m755 ${niriInirSessionScript} "$out/bin/niri-inir-session"
            install -m755 ${niriNoctaliaSessionScript} "$out/bin/niri-noctalia-v5-session"
            install -m755 ${niriDmsSessionScript} "$out/bin/niri-dms-session"

            cat > "$out/share/wayland-sessions/niri-inir.desktop" <<EOF
            [Desktop Entry]
            Name=Niri + iNiR
            Comment=Niri compositor with the iNiR shell
            Exec=$out/bin/niri-inir-session
            Type=Application
            EOF

            cat > "$out/share/wayland-sessions/niri-noctalia-v5.desktop" <<EOF
            [Desktop Entry]
            Name=Niri + Noctalia v5
            Comment=Niri compositor with the Noctalia v5 shell
            Exec=$out/bin/niri-noctalia-v5-session
            Type=Application
            EOF

            cat > "$out/share/wayland-sessions/niri-dms.desktop" <<EOF
            [Desktop Entry]
            Name=Niri + DMS
            Comment=Niri compositor with the DMS shell
            Exec=$out/bin/niri-dms-session
            Type=Application
            EOF
          '';
    in
    {
      options.my.desktop.niri.displaySettings = lib.mkOption {
        type = lib.types.nullOr lib.types.attrs;
        default = null;
        description = "Host-specific declarative Niri display settings. When null, DMS may manage outputs.";
      };

      config.environment.systemPackages = [
        shellSettings.niriSidebar
      ];

      config.programs.niri = {
        enable = true;
        package = niriInirWrapper;
      };

      config.services.displayManager.sessionPackages = [
        niriSessions
      ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.myDms = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
}
