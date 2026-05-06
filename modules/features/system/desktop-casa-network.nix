{ self, inputs, ... }: {
  flake.nixosModules.desktopCasaNetwork = { ... }: {
    networking.hostName = "nixos";
    networking.networkmanager.enable = true;
  };
}
