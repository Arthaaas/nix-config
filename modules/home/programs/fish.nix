{ ... }:
{
  flake.homeModules.fish =
    { ... }:
    {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set -g fish_greeting

          if type -q fastfetch
            clear
            fastfetch
          end
        '';
      };
    };
}
