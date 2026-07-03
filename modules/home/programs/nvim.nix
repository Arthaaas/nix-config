{ ... }: {
  flake.homeModules.nvim = { pkgs, ... }: {
    programs.neovim = {
      enable = true;

      plugins = with pkgs.vimPlugins; [
        telescope-nvim
        plenary-nvim
      ];
    };

    home.packages = with pkgs; [
      ripgrep
      fd
    ];

    xdg.configFile."nvim" = {
      source = ../../dotfiles/nvim;
      force = true;
    };
  };
}
