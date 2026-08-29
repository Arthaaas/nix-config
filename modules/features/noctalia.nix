{ inputs, ... }:
{
  flake.nixosModules.noctalia =
    { ... }:
    {
      imports = [ inputs.noctalia.nixosModules.default ];
      programs.noctalia = {
        enable = true;
        recommendedServices.enable = true;
        systemd.enable = false;
      };
    };
}
