{ ... }:
{
  flake.homeModules.fish =
    { ... }:
    {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set -g fish_greeting

          if isatty stdout; and type -q fetch; and not set -q DEVENV_ROOT
            clear
            fetch
          end
        '';
      };
    };
}
