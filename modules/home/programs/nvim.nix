{ ... }: {
  flake.homeModules.nvim = { config, lib, pkgs, ... }: {
    home.packages = with pkgs; [
      ripgrep
      fd
      tree-sitter
    ];

    home.activation.linkMutableNvim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      target="${config.xdg.configHome}/nvim"
      source="${config.home.homeDirectory}/nix-config/modules/dotfiles/nvim"

      $DRY_RUN_CMD mkdir -p "$(dirname "$target")"
      if [ -L "$target" ]; then
        $DRY_RUN_CMD rm "$target"
      elif [ -e "$target" ]; then
        $DRY_RUN_CMD mv "$target" "$target.hm-backup"
      fi
      $DRY_RUN_CMD ln -s "$source" "$target"
    '';
  };
}
