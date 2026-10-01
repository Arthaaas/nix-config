{ self, inputs, ... }:
{
  flake.nixosModules.virtualboxPackages =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.my.packages.virtualbox.enable = lib.mkEnableOption "VirtualBox virtualization";

      config = lib.mkIf config.my.packages.virtualbox.enable {
        virtualisation.virtualbox.host.enable = true;
        virtualisation.virtualbox.host.enableExtensionPack = true;

        users.extraGroups.vboxusers.members = [ config.my.host.userName ];
      };
    };
}
