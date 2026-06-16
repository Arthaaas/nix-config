{ self, inputs, ... }: {
  flake.nixosModules.hostOptions = { lib, ... }: {
    options.my.host = {
      userName = lib.mkOption {
        type = lib.types.str;
        default = "arthas";
        description = "Primary local user for host-specific paths and Home Manager config.";
      };

      userDescription = lib.mkOption {
        type = lib.types.str;
        default = "Arthur Barbosa Azevedo";
        description = "Full name for the primary local user.";
      };

      homeDirectory = lib.mkOption {
        type = lib.types.str;
        default = "/home/arthas";
        description = "Home directory for the primary local user.";
      };
    };
  };
}
