{ ... }:
{
  flake.homeModules.noctaliaV5 =
    { ... }:
    {
      home.file.".config/noctalia-v5-clean/noctalia/config.toml".source =
        ../../dotfiles/noctalia-v5/config.toml;
    };
}
