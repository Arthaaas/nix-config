{ self, inputs, ... }:
{
  flake.nixosModules.memoryManagement =
    { ... }:
    {
      boot.zswap = {
        enable = true;
        compressor = "zstd";
        maxPoolPercent = 20;
      };
    };
}
