{ self, inputs, ... }: {
  flake.nixosConfigurations."notebook-kot" = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      self.nixosModules.notebookKotConfiguration
      inputs.home-manager.nixosModules.home-manager
      ({ pkgs, ... }: {
        programs.niri.package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiriNotebookKot;
      })
    ];
  };
}
