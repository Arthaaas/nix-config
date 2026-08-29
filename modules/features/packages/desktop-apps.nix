{ self, inputs, ... }:
{
  flake.nixosModules.desktopAppPackages =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.my.packages.desktopApps.enable = lib.mkEnableOption "desktop application packages";

      config = lib.mkIf config.my.packages.desktopApps.enable {
        services.ratbagd.enable = true;

        environment.systemPackages = with pkgs; [
          papirus-icon-theme
          brave
          inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
          kitty
          nemo
          nautilus
          networkmanagerapplet
          pwvucontrol
          evince
          file-roller
          wl-clipboard
          grim
          slurp
          polkit_gnome
          wdisplays
          winboat
          localsend
          piper
          solaar
          libratbag
        ];
      };
    };
}
