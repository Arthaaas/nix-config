{ self, inputs, ... }:
{
  flake.nixosModules.niriWorkstationProfile =
    { ... }:
    {
      imports = [
        self.nixosModules.baseProfile
        self.nixosModules.niri
        self.nixosModules.dms
        self.nixosModules.home
        self.nixosModules.desktopBasePackages
        self.nixosModules.desktopBase
        self.nixosModules.pipewireAudio
        self.nixosModules.fuxiH3AudioFix
      ];
    };
}
