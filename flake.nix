{
  description = "Nxllpointer's NixOS flake";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "";
      inputs.home-manager.follows = "";
    };

    noctalia.url = "github:noctalia-dev/noctalia";

    yazi.url = "github:sxyazi/yazi";

    rhythia-git = {
      url = "github:Rhythia/sound-space-plus";
      flake = false;
    };

    corecycler.url = "github:Daaboulex/linux-corecycler";

    extra-modules = {
      url = "git+https://gitlab.com/empty-repo/empty.git?rev=e84d7b81f0033399e325b8037ed2b801a5c994e0";
      flake = false;
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://yazi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
    ];
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree [./modules inputs.extra-modules]);
}
