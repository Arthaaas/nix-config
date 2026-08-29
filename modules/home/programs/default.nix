{ self, ... }:
{
  flake.homeModules.default =
    { ... }:
    {
      imports = [
        self.homeModules.brave
        self.homeModules.fish
        self.homeModules.kitty
        self.homeModules.noctaliaV5
        self.homeModules.nvim
        self.homeModules.tmux
      ];
    };
}
