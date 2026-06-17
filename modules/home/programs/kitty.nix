{ ... }:
{
  flake.homeModules.kitty =
    { ... }:
    {
      home.file.".config/kitty/tmux-main.session".source = ../../dotfiles/kitty/tmux-main.session;
      home.file.".config/kitty/tmux-session.sh" = {
        source = ../../dotfiles/kitty/tmux-session.sh;
        executable = true;
      };

      programs.kitty = {
        enable = true;
        extraConfig = builtins.readFile ../../dotfiles/kitty/kitty.conf;
      };
    };
}
