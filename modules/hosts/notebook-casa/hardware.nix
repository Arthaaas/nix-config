{ self, inputs, ... }: {
  flake.nixosModules.notebookCasaHardware = { config, lib, pkgs, modulesPath, ... }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "usb_storage"
      "sd_mod"
      "sdhci_pci"
    ];

    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/9fc33cdf-02a9-416a-8fa0-3e0f59efc40a";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/FE7B-569F";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    swapDevices = [
      {
        device = "/dev/disk/by-uuid/8b080966-ee3b-49cf-8541-08bd12e4a2f9";
      }
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    hardware.cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services.blueman.enable = true;

    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };
}
