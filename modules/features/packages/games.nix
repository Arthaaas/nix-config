{ self, inputs, ... }:
{
  flake.nixosModules.gamesPackages =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      # PS5Upload 12.4.13: pacote NUR indicado pelo projeto, com revisão fixa.
      ps5upload =
        pkgs.callPackage
          (
            (builtins.fetchTarball {
              url = "https://github.com/GriefNorth/nur-packages/archive/fdf612fca69c2c0c6344bae41ce6044bffc8b2ac.tar.gz";
              sha256 = "186qsdddc71nc81gldzzp8m8rnj2hpx2lxvvwx32ry16bsqhi3h1";
            })
            + "/pkgs/ps5upload"
          )
          {
            appimageTools = pkgs.appimageTools // {
              wrapType2 =
                args:
                pkgs.appimageTools.wrapType2 (
                  args
                  // {
                    # A biblioteca não vem no AppImage nem no ambiente FHS padrão.
                    extraPkgs = p: (args.extraPkgs or (_: [ ])) p ++ [ p.libgpg-error ];
                  }
                );
            };
          };

      bottlesWithNixFixes = pkgs.bottles.override {
        removeWarningPopup = true;
        bottles-unwrapped =
          (pkgs.bottles-unwrapped.override {
            removeWarningPopup = true;
            python3Packages = pkgs.python3Packages.overrideScope (
              _pyFinal: pyPrev: {
                patool = pyPrev.patool.overridePythonAttrs (old: {
                  disabledTests = (old.disabledTests or [ ]) ++ [
                    "test_py_tarfile_bz2"
                    "test_py_tarfile_bz2_file"
                    "test_tar_lzma"
                    "test_tar_xz"
                    "test_tar_bz2"
                    "test_tar_bz2_file"
                    "test_tar_lzip"
                    "test_tar_xz_file"
                    "test_mime_file"
                    "test_mime_file_bzip"
                  ];
                });
              }
            );
          }).overrideAttrs
            (old: {
              nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.perl ];

              postPatch = (old.postPatch or "") + ''
                perl -0pi -e 's#if archive_path\.endswith\("\.tar"\) and os\.path\.isfile\(\s*os\.path\.join\(archive_path, os\.path\.basename\(archive_path\)\)\s*\):\s*tar_path = os\.path\.join\(archive_path, os\.path\.basename\(archive_path\)\)\s*patoolib\.extract_archive\(tar_path, outdir=archive_path\)#if archive_path.endswith(".tar"):\n                tar_candidates = [\n                    os.path.join(archive_path, os.path.basename(archive_path)),\n                    os.path.join(\n                        archive_path,\n                        os.path.splitext(os.path.basename(archive_path))[0],\n                    ),\n                ]\n\n                for tar_path in tar_candidates:\n                    if os.path.isfile(tar_path):\n                        patoolib.extract_archive(tar_path, outdir=archive_path)\n                        break#s' bottles/backend/managers/dependency.py
                grep -q tar_candidates bottles/backend/managers/dependency.py
              '';
            });
      };
    in
    {
      options.my.packages.games.enable = lib.mkEnableOption "game packages";

      config = lib.mkIf config.my.packages.games.enable {
        environment.systemPackages = with pkgs; [
          hydralauncher
          bottlesWithNixFixes
          ps5upload
        ];
      };
    };
}
