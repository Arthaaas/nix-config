{ self, inputs, ... }:
{
  flake.nixosModules.mediaPackages =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.my.packages.media.enable = lib.mkEnableOption "media packages";

      config = lib.mkIf config.my.packages.media.enable {
        environment.systemPackages = with pkgs; [
          qbittorrent
          ffmpegthumbnailer
        ];
      };
    };
}
