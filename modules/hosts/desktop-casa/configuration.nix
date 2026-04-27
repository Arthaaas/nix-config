{ self, inputs, ... }: {
  flake.nixosModules.desktopCasaConfiguration = { config, pkgs, lib, ... }: {
    imports = [
      self.nixosModules.desktopCasaHardware
      self.nixosModules.niri
      self.nixosModules.home
    ];

    environment.systemPackages = with pkgs; [
      papirus-icon-theme
      git
      neovim
      wget
      brave
      kitty
      vscode
      obsidian
      qbittorrent
      discord
      teams-for-linux
      spotify
      nemo
      ffmpegthumbnailer
      evince
      wl-clipboard
      grim
      slurp
      polkit_gnome
      gemini-cli
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = false;
      settings = {
        Autologin = {
          Session = "niri";
          User = "arthas";
        };
        General = {
          DefaultSession = "niri";
        };
      };
    };

    services.desktopManager.plasma6.enable = true;

    qt = {
      enable = true;
      platformTheme = "gtk2";
      style = "gtk2";
    };

    gtk.iconCache.enable = true;

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    boot.kernelPackages = pkgs.linuxPackages_6_12;

    boot.blacklistedKernelModules = [ "nouveau" ];
    boot.kernelModules = [ "nvidia" "nvidia_drm" "nvidia_modeset" "nvidia_uvm" ];
    boot.kernelParams = [ "nvidia-drm.modeset=1" ];

    services.xserver.videoDrivers = [ "nvidia" ];

    environment.variables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NIXOS_OZONE_WL = "1";
      XDG_SESSION_TYPE = "wayland";
    };

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

    services.xserver.enable = true;
    services.xserver.xkb = {
      layout = "us";
      variant = "intl";
    };

    console.keyMap = "us";

    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    };

    services.printing.enable = true;

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    users.users.arthas = {
      isNormalUser = true;
      description = "Arthur Barbosa Azevedo";
      extraGroups = [ "networkmanager" "wheel" ];
    };

    programs.firefox.enable = true;
    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "25.11";
  };
}