{ ... }:
{
  imports = [
    ./nvidia-desktop.nix
  ];

  flake.nixosModules.nordicTrackball =
    { ... }:
    {
      services.udev.extraRules = ''
        ACTION!="remove", SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_VENDOR_ID}=="25a7", ENV{ID_MODEL_ID}=="fa11", ENV{ID_INPUT_MOUSE}=="1", ENV{ID_INPUT_MOUSE}="", ENV{ID_INPUT_TRACKBALL}="1"
      '';
    };
}
