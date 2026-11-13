{ self, ... }:
{
  flake.homeModules.default =
    {
      config,
      lib,
      osConfig,
      ...
    }:
    {
      imports = [
        self.homeModules.brave
        self.homeModules.fish
        self.homeModules.kitty
        self.homeModules.noctaliaV5
        self.homeModules.nvim
        self.homeModules.tmux
      ];

      # Arquivos mutaveis: rebuilds nao sobrescrevem os ajustes feitos na GUI.
      home.activation.niriMonitors = lib.mkIf (osConfig.my.desktop.niri.displaySettings == null) (
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p "${config.home.homeDirectory}/.config/niri"
          if [ ! -e "${config.home.homeDirectory}/.config/niri/monitor.kdl" ]; then
            touch "${config.home.homeDirectory}/.config/niri/monitor.kdl"
          fi
          if [ ! -e "${config.home.homeDirectory}/.config/niri/config.kdl" ]; then
            printf '%s\n' 'include "monitor.kdl"' > "${config.home.homeDirectory}/.config/niri/config.kdl"
          fi
        ''
      );
    };
}
