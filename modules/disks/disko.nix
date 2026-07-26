{inputs, ...}: {
  configuration.nixos = {
    imports = [
      inputs.disko.nixosModules.disko
    ];
  };
}
