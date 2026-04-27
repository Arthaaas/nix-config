{ self, inputs, ... }: {
  flake.nixosModules.desktopCasaBoot = { ... }: {
    boot.loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        copyKernels = true;
      };
    };
  };
}
