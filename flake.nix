{
  description = "Nxllpointer's NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager?ref=release-24.05";
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

    opentabletdriver.url = "github:opentabletdriver/opentabletdriver?rev=0313c633b03306c98eedcd75bf22d0599bd6e51d";
  };

  # outputs is not allowed to be a thunk so a wrapper function is used to import the outputs
  outputs = inputs: ((import ./flake) inputs);
}
