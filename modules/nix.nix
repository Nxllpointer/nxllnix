{inputs, ...}: {
  flake.modules.nixos.base = {
    nix = {
      settings = {experimental-features = ["flakes" "nix-command"];};
      nixPath = ["nixpkgs=${inputs.nixpkgs.outPath}"];
    };
  };

  flake.modules.nixos.impermanence = {
    persisted.directories = ["root/.cache/nix"];
  };

  flake.modules.homeManager.impermanence = {
    persisted = {
      directories = [
        ".cache/nix"
        ".local/state/nix"
      ];
    };
  };
}
