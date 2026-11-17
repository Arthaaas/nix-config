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
      imports = [ inputs.openlogi.nixosModules.default ];

      options.my.packages.desktopApps.enable = lib.mkEnableOption "desktop application packages";

      config = lib.mkIf config.my.packages.desktopApps.enable {
        programs.appimage = {
          enable = true;
          binfmt = true;
        };

        programs.openlogi.enable = true;
        services.ratbagd.enable = true;

        # Keep folder opening consistent across xdg-open and desktop applications.
        # User defaults for unrelated file types remain untouched.
        xdg.mime = {
          enable = true;
          defaultApplications = {
            "inode/directory" = "org.kde.dolphin.desktop";
            "application/zip" = "org.kde.ark.desktop";
            "application/x-7z-compressed" = "org.kde.ark.desktop";
            "application/vnd.rar" = "org.kde.ark.desktop";
            "application/x-rar" = "org.kde.ark.desktop";
            "application/x-tar" = "org.kde.ark.desktop";
            "application/x-compressed-tar" = "org.kde.ark.desktop";
            "application/x-bzip-compressed-tar" = "org.kde.ark.desktop";
            "application/x-xz-compressed-tar" = "org.kde.ark.desktop";
            "application/x-zstd-compressed-tar" = "org.kde.ark.desktop";
            "application/gzip" = "org.kde.ark.desktop";
            "application/x-bzip2" = "org.kde.ark.desktop";
            "application/x-xz" = "org.kde.ark.desktop";
            "application/zstd" = "org.kde.ark.desktop";
          };
          removedAssociations."inode/directory" = [ "kitty-open.desktop" ];
        };

        environment.systemPackages = with pkgs; [
          papirus-icon-theme
          brave
          inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
          kitty
          kdePackages.dolphin
          kdePackages.ark
          kdePackages.kio-extras
          networkmanagerapplet
          pwvucontrol
          evince
          wl-clipboard
          grim
          slurp
          polkit_gnome
          wdisplays
          winboat
          localsend
          piper
          libratbag
        ];
      };
    };
}
