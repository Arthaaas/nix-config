{ self, inputs, ... }:
{
  flake.nixosModules.notebookCasaConfiguration =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        self.nixosModules.notebookCasaHardware
        self.nixosModules.workLaptopProfile
        self.nixosModules.systemdBoot
      ];

      my.host = {
        name = "nixos-notebook";
        userName = "arthas";
        homeDirectory = "/home/arthas";
        defaultLocale = "pt_BR.UTF-8";
        extraLocale = "pt_BR.UTF-8";
        keyboard = {
          consoleKeyMap = "br-abnt2";
          layout = "br";
          variant = "";
        };
      };

      system.stateVersion = "26.05";
    };
}
