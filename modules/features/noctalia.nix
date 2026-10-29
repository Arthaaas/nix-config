{ inputs, ... }:
{
  flake.nixosModules.noctalia =
    { config, ... }:
    {
      imports = [ inputs.noctalia.nixosModules.default ];
      programs.noctalia = {
        enable = true;
        recommendedServices.enable = true;
        systemd.enable = false;
      };

      services.displayManager.noctalia-greeter = {
        enable = true;
        settings = {
          session.default = "Niri + Noctalia v5";
          keyboard = {
            inherit (config.my.host.keyboard) layout variant;
          };
        };
      };

      # Include the custom Niri session in the greeter's session discovery.
      systemd.services.greetd.environment.XDG_DATA_DIRS =
        "${config.services.displayManager.sessionData.desktops}/share:/run/current-system/sw/share";
    };
}
