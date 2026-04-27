{ inputs, ... }: {
    imports = [
        inputs.flake-parts.flakeModules.modules
        ./features/audio
        ./features/desktop
        ./features/hardware
        ./features/system
    ];

    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
}
