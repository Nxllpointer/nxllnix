{inputs, ...}: {
  configuration = {
    globalconfig,
    lib,
    ...
  }: {
    nixos = {
      nix = {
        settings = {experimental-features = ["flakes" "nix-command"];};
        nixPath = ["nixpkgs=${inputs.nixpkgs.outPath}"];
      };

      persisted.directories = lib.mkIf globalconfig.impermanence.enable ["root/.cache/nix"];
    };

    home = {
      persisted.directories = lib.mkIf globalconfig.impermanence.enable [
        ".cache/nix"
        ".local/state/nix"
      ];
    };
  };
}
