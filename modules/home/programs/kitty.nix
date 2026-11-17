{ ... }:
{
  flake.homeModules.kitty =
    { pkgs, ... }:
    {
      home.file.".config/kitty/tmux-main.session".source = ../../dotfiles/kitty/tmux-main.session;
      home.file.".config/kitty/tmux-session.sh" = {
        source = ../../dotfiles/kitty/tmux-session.sh;
        executable = true;
      };

      # Handle both folder links clicked in Kitty and `kitty +open <folder>`.
      xdg.configFile."kitty/open-actions.conf".text = ''
        protocol file
        mime inode/directory
        action launch --type=background ${pkgs.kdePackages.dolphin}/bin/dolphin -- ''${FILE_PATH}
      '';
      xdg.configFile."kitty/launch-actions.conf".text = ''
        protocol file
        mime inode/directory
        action launch --type=background ${pkgs.kdePackages.dolphin}/bin/dolphin -- ''${FILE_PATH}
      '';

      programs.kitty = {
        enable = true;
        extraConfig = builtins.readFile ../../dotfiles/kitty/kitty.conf;
      };
    };
}
