{ self, inputs, ... }:
{
  flake.nixosModules.devPackages =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.my.packages.dev.enable = lib.mkEnableOption "development packages";

      config = lib.mkIf config.my.packages.dev.enable {
        virtualisation.docker.enable = true;

        environment.systemPackages = with pkgs; [
          gcc
          gnumake
          python3
          nodejs
          (with dotnetCorePackages; combinePackages [
            sdk_8_0
            sdk_10_0
          ])
          powershell
          stylua
          lua-language-server
          nil
          nixfmt
          vscode
          antigravity-cli
          codex
          claude-code
          devenv
          docker
          jetbrains.rider
          opencode
          ripgrep
          fd
        ];
      };
    };
}
