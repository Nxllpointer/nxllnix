{...}: {
  perSystem = {pkgs, ...}: {
    packages.rhythia = pkgs.callPackage ./_package.nix {};
  };
}
