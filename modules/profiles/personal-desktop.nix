{ self, inputs, ... }:
{
  flake.nixosModules.personalDesktopProfile =
    { ... }:
    {
      imports = [
        self.nixosModules.niriWorkstationProfile
        self.nixosModules.nvidiaDesktop
        self.nixosModules.gaming
      ];
    };
}
