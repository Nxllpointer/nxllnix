lib: inputs:
let
  defaultModule = { ... }: { imports = [ ./../modules/nixos ]; };

  configurationDir = ./../configurations;

  configurationNames = builtins.attrNames (builtins.readDir configurationDir);

  createConfiguration = name:
    lib.nixosSystem {
      modules = [ (configurationDir + "/${name}") defaultModule ];
      specialArgs = { inherit inputs; };
    };

  configurations = lib.genAttrs configurationNames createConfiguration;
in
configurations
