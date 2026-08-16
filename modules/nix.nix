{inputs, ...}: {
  configuration = {
    globalconfig,
    lib,
    ...
  }: {
    options = {
      update-command = lib.mkOption {type = lib.types.str;};
      rebuild-command = lib.mkOption {type = lib.types.str;};
    };

    config = {
      nixos = {
        nix = {
          settings = {experimental-features = ["flakes" "nix-command"];};
          nixPath = ["nixpkgs=${inputs.nixpkgs.outPath}"];
        };

        persisted.directories = lib.mkIf globalconfig.impermanence.enable [
          "root/.cache/nix"
          "root/.local/share/nix"
        ];
      };

      home = {pkgs, ...}: {
        home.packages = [
          pkgs.nix-output-monitor
          (pkgs.writeShellScriptBin "nxllnix-update" "set -x; ${globalconfig.update-command}")
          (pkgs.writeShellScriptBin "nxllnix-rebuild" "set -x; ${globalconfig.rebuild-command} $@")
          (pkgs.writeShellScriptBin "nxllnix-rebuild-nom" "nxllnix-rebuild --log-format internal-json -v |& nom --json")
        ];

        persisted.directories = lib.mkIf globalconfig.impermanence.enable [
          ".cache/nix"
          ".local/state/nix"
        ];
      };
    };
  };
}
