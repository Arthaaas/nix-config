{ ... }:
{
  flake.homeModules.fish =
    { ... }:
    {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set -g fish_greeting

          if type -q fetch
            clear
            fetch
          end
        '';
      };
    };
}
