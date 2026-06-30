{ self, inputs, ... }:
{
  flake.nixosModules.notebookKotConfiguration =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        self.nixosModules.notebookKotHardware
        self.nixosModules.workLaptopProfile
        self.nixosModules.systemdBoot
      ];

      my.host = {
        name = "kot247";
        userName = "arthurb";
        homeDirectory = "/home/arthurb";
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
