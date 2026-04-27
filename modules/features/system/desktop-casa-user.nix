{ self, inputs, ... }: {
  flake.nixosModules.desktopCasaUser = { ... }: {
    users.users.arthas = {
      isNormalUser = true;
      description = "Arthur Barbosa Azevedo";
      extraGroups = [ "networkmanager" "wheel" ];
    };
  };
}
