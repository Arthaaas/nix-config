{ self, inputs, ... }: {
  flake.nixosModules.desktopCasaConfiguration = { config, pkgs, lib, ... }: {
    imports = [
      self.nixosModules.desktopCasaHardware
      self.nixosModules.niri
      self.nixosModules.home
      self.nixosModules.desktopBasePackages
      self.nixosModules.desktopBase
      self.nixosModules.nvidiaDesktop
      self.nixosModules.pipewireAudio
      self.nixosModules.fuxiH3AudioFix
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

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

    networking.hostName = "Arthas";
    networking.networkmanager.enable = true;

    time.timeZone = "America/Sao_Paulo";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };

    console.keyMap = "us";

    users.users.arthas = {
      isNormalUser = true;
      description = "Arthur Barbosa Azevedo";
      extraGroups = [ "networkmanager" "wheel" ];
    };

    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "25.11";
  };
}
