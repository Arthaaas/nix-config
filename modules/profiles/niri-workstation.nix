{ self, inputs, ... }:
{
  flake.nixosModules.niriWorkstationProfile =
    { ... }:
    {
      imports = [
        self.nixosModules.baseProfile
        self.nixosModules.niri
        self.nixosModules.inir
        self.nixosModules.dms
        self.nixosModules.noctalia
        self.nixosModules.home
        self.nixosModules.corePackages
        self.nixosModules.devPackages
        self.nixosModules.erpDevPackages
        self.nixosModules.desktopAppPackages
        self.nixosModules.workPackages
        self.nixosModules.notesPackages
        self.nixosModules.personalPackages
        self.nixosModules.mediaPackages
        self.nixosModules.gamesPackages
        self.nixosModules.virtualboxPackages
        self.nixosModules.desktopBase
        self.nixosModules.pipewireAudio
        self.nixosModules.fuxiH3AudioFix
      ];
    };
}
