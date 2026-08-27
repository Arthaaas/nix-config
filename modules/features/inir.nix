{ inputs, ... }:
{
  flake.nixosModules.inir =
    { config, ... }:
    {
      imports = [
        inputs.inir.nixosModules.inir
      ];

      programs.inir = {
        enable = true;
        service.compositor = "niri";
        extraPackages = [ config.programs.niri.package ];
      };
    };
}
