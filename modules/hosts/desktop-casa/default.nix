{ self, inputs, ... }: {
  flake.nixosConfigurations.desktopCasa = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      self.nixosModules.desktopCasaConfiguration
      inputs.home-manager.nixosModules.home-manager
      ({ pkgs, ... }: {
        programs.niri.package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
      })
    ];
  };
}
