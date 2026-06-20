{ self, ... }: {
  flake.nixosModules.gaming = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      heroic
    ];
    programs = {
      steam = {
        enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
        protontricks.enable = true;
      };

      gamemode.enable = true;
    };
  };
}
