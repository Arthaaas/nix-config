{ self, inputs, ... }:
{
  flake.nixosModules.workLaptopProfile =
    { ... }:
    {
      imports = [
        self.nixosModules.niriWorkstationProfile
      ];
    };
}
