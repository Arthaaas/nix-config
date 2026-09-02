{ ... }:
{
  flake.homeModules.noctaliaV5 =
    {
      config,
      lib,
      myHostName,
      ...
    }:
    {
      home.file.".config/noctalia/noctalia.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/dotfiles/noctalia/noctalia.json";

      home.file.".config/noctalia/colors.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/dotfiles/noctalia/colors.json";

      home.file.".config/noctalia/plugins.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/dotfiles/noctalia/plugins.json";

      home.activation.linkMutableNoctaliaColorschemes = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        target="${config.xdg.configHome}/noctalia/colorschemes"
        source="${config.home.homeDirectory}/nix-config/modules/dotfiles/noctalia/colorschemes"

        $DRY_RUN_CMD mkdir -p "$(dirname "$target")"
        if [ -L "$target" ]; then
          $DRY_RUN_CMD rm "$target"
        elif [ -e "$target" ]; then
          $DRY_RUN_CMD mv "$target" "$target.hm-backup"
        fi
        $DRY_RUN_CMD ln -s "$source" "$target"
      '';

      home.activation.linkMutableNoctaliaV5Config = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        target="${config.xdg.configHome}/noctalia-v5-clean/noctalia"
        source="${config.home.homeDirectory}/nix-config/modules/dotfiles/noctalia-v5"

        $DRY_RUN_CMD mkdir -p "$(dirname "$target")"
        if [ -L "$target" ]; then
          $DRY_RUN_CMD rm "$target"
        elif [ -e "$target" ]; then
          $DRY_RUN_CMD mv "$target" "$target.hm-backup"
        fi
        $DRY_RUN_CMD ln -s "$source" "$target"
      '';

      home.activation.linkMutableNoctaliaV5State = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        state_dir="${config.home.homeDirectory}/.local/state/noctalia-v5-clean/noctalia"
        source_dir="${config.home.homeDirectory}/nix-config/modules/dotfiles/noctalia-v5-hosts/${myHostName}/noctalia"
        seed="${config.home.homeDirectory}/nix-config/modules/dotfiles/noctalia-v5-common/noctalia"

        if [ ! -e "$source_dir" ]; then
          $DRY_RUN_CMD mkdir -p "$(dirname "$source_dir")"
          if [ -e "$seed" ]; then
            $DRY_RUN_CMD cp -a "$seed" "$source_dir"
          else
            $DRY_RUN_CMD mkdir -p "$source_dir"
          fi
        fi

        $DRY_RUN_CMD mkdir -p "$state_dir" "$source_dir"
        for file in settings.toml state.toml .setup-complete; do
          target="$state_dir/$file"
          source="$source_dir/$file"

          if [ ! -e "$source" ]; then
            $DRY_RUN_CMD touch "$source"
          fi

          if [ -L "$target" ]; then
            $DRY_RUN_CMD rm "$target"
          elif [ -e "$target" ]; then
            $DRY_RUN_CMD mv "$target" "$target.hm-backup"
          fi
          $DRY_RUN_CMD ln -s "$source" "$target"
        done

        target="$state_dir/community-palettes"
        source="$source_dir/community-palettes"
        $DRY_RUN_CMD mkdir -p "$source"
        if [ -L "$target" ]; then
          $DRY_RUN_CMD rm "$target"
        elif [ -e "$target" ]; then
          $DRY_RUN_CMD mv "$target" "$target.hm-backup"
        fi
        $DRY_RUN_CMD ln -s "$source" "$target"
      '';
    };
}
