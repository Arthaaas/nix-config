{ self, ... }: {
  flake.nixosModules.gaming = { pkgs, ... }: {
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
