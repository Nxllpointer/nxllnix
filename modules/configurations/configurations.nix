{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    (lib.mkAliasOptionModule ["configuration"] ["flake" "modules" "nxllnix" "configuration"])
  ];

  options.configurations = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        imports = [
          config.configuration
        ];
      }
    );
  };

  config = {
    configuration = {
      config,
      lib,
      ...
    }: {
      options = {
        system = lib.mkOption {type = lib.types.str;};
        gui.enable = lib.mkEnableOption "GUI (Hyprland, desktop apps)";
        nixos = lib.mkOption {
          type = lib.types.deferredModule;
          default = {};
        };
        home = lib.mkOption {
          type = lib.types.deferredModule;
          default = {};
        };
      };

      config = {
        _module.args = {
          globalconfig = config;
        };
      };
    };

    flake.nixosConfigurations = lib.flip lib.mapAttrs config.configurations (
      name: configuration:
        lib.nixosSystem {
          modules = [configuration.nixos];
        }
    );

    flake.homeConfigurations = lib.flip lib.mapAttrs config.configurations (
      name: configuration:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs {inherit (configuration) system;};
          modules = [
            configuration.home

            # Workaround for impermanence module not existing for home-only configurations
            ({config, ...}: {
              options.home.persistence = lib.mkOption {
                type = lib.types.anything;
                default = {};
              };
              config.assertions = [
                {
                  assertion = config.home.persistence == {};
                  message = "home.persistence does not work in home-only configurations";
                }
              ];
            })
          ];
        }
    );
  };
}
