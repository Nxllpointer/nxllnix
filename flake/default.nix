{ nixpkgs, ... }@inputs:
let
  inherit (nixpkgs) lib;

  supportedSystems = [ "x86_64-linux" ];
  forSupportedSystems = f:
    lib.genAttrs supportedSystems (system:
      (f {
        inherit system;
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import ./../pkgs inputs) ];
        };
      }));
in
{
  nixosConfigurations = (import ./nixosConfigurations.nix) lib inputs;
  packages = forSupportedSystems (import ./packages.nix);
  formatter = forSupportedSystems (import ./formatter.nix);
}
