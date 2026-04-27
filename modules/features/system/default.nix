{ ... }: {
  imports = [
    ./base-packages.nix
    ./desktop-casa-boot.nix
    ./desktop-casa-network.nix
    ./desktop-casa-locale.nix
    ./desktop-casa-user.nix
  ];
}
