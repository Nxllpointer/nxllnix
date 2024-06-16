{
  description = "Nxllpointer's NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # outputs is not allowed to be a thunk so a wrapper function is used to import the outputs
  outputs = inputs: ((import ./flake) inputs);
}
