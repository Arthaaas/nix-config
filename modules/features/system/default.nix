{ ... }:
{
  imports = [
    ./host-options.nix
    ./base-packages.nix
    ./boot/grub-efi.nix
    ./boot/systemd-boot.nix
    ./network.nix
    ./locale.nix
    ./user.nix
  ];
}
