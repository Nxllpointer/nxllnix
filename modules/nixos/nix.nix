{ inputs, ... }: {
  nix = {
    settings = { experimental-features = [ "flakes" "nix-command" ]; };
    nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
  };
}
