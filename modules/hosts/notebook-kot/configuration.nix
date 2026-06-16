{ self, inputs, ... }: {
  flake.nixosModules.notebookKotConfiguration = { config, pkgs, lib, ... }: {
    imports = [
      self.nixosModules.hostOptions
      self.nixosModules.notebookKotHardware
      self.nixosModules.niri
      self.nixosModules.dms
      self.nixosModules.home
      self.nixosModules.desktopBasePackages
      self.nixosModules.desktopBase
      self.nixosModules.pipewireAudio
      self.nixosModules.desktopCasaUser
    ];

    my.host = {
      userName = "arthurb";
      homeDirectory = "/home/arthurb";
    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "kot247";
    networking.networkmanager.enable = true;
    networking.firewall.enable = true;

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

    console.keyMap = "br-abnt2";
    services.xserver.xkb = {
      layout = "br";
      variant = "nodeadkeys";
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "26.05";
  };
}
