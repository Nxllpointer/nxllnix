{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.rhythia = pkgs.callPackage ./_package.nix {inherit (inputs) rhythia-git;};
  };
}
