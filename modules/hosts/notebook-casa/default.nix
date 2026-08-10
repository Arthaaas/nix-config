{ self, inputs, ... }:
{
  flake.nixosConfigurations."notebook-casa" = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      self.nixosModules.notebookCasaConfiguration
      inputs.home-manager.nixosModules.home-manager
    ];
  };
}
