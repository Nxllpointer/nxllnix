{inputs, ...}: {
  flake.modules.nixos.base = {
    nix = {
      settings = {experimental-features = ["flakes" "nix-command"];};
      nixPath = ["nixpkgs=${inputs.nixpkgs.outPath}"];
    };
  };
}
