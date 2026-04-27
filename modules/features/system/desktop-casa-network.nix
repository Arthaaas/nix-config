{ self, inputs, ... }: {
  flake.nixosModules.desktopCasaNetwork = { ... }: {
    networking.hostName = "Arthas";
    networking.networkmanager.enable = true;
  };
}
