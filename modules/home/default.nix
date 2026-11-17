{ self, inputs, ... }: {
  flake.nixosModules.home =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      userName = config.my.host.userName;
    in
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";
        extraSpecialArgs = {
          myHostName = config.my.host.name;
        };
        users.${userName} = { lib, ... }: {
          imports = [
            self.homeModules.default
          ];

          home.stateVersion = "25.11";

          gtk = {
            enable = true;
            theme = {
              name = "Adwaita-dark";
              package = pkgs.gnome-themes-extra;
            };
            gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
            gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
            iconTheme = {
              name = "Papirus-Dark";
              package = pkgs.papirus-icon-theme;
            };
          };
          dconf = {
            enable = true;
            settings."org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
              gtk-theme = "Adwaita-dark";
            };
          };

          # Update the existing KDE palette without replacing unrelated settings.
          home.activation.applyDarkQtTheme = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
            run env QT_QPA_PLATFORM=offscreen \
              XDG_DATA_DIRS="${pkgs.kdePackages.breeze}/share:''${XDG_DATA_DIRS:-}" \
              ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme BreezeDark
          '';
          home.pointerCursor = {
            enable = true;
            name = "breeze_cursors";
            package = pkgs.kdePackages.breeze;
            size = 24;
            gtk.enable = true;
            x11.enable = true;
          };
        };
      };
    };
}
