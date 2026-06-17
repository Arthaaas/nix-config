{ self, inputs, ... }:
{
  flake.nixosModules.desktopCasaConfiguration =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        self.nixosModules.desktopCasaHardware
        self.nixosModules.personalDesktopProfile
        self.nixosModules.grubEfiBoot
      ];

      my.host = {
        name = "nixos";
        userName = "arthas";
        homeDirectory = "/home/arthas";
        keyboard = {
          consoleKeyMap = "us";
          layout = "us";
          variant = "intl";
        };
      };

      system.stateVersion = "25.11";
    };
}
