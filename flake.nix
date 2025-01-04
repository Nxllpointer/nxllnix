{
  description = "Nxllpointer's NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rhythia-git = {
      url = "github:David20122/sound-space-plus";
      flake = false;
    };
  };

  # outputs is not allowed to be a thunk so a wrapper function is used to import the outputs
  outputs = inputs: ((import ./flake) inputs);
}
