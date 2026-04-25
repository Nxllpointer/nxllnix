{
  flake.modules.nixos.base = {config, ...}: {
    virtualisation.vmVariant = {
      virtualisation = {
        useBootLoader = false;
        useEFIBoot = true;
        cores = 6;
        resolution = {
          x = 1920;
          y = 1080;
        };

        qemu.options = [
          "-m 16G"
        ];
      };
    };

    virtualisation.docker.enable = true;
    users.users.${config.nxllnix.username}.extraGroups = ["docker"];
  };

  flake.modules.nixos.impermanence = {
    persisted.directories = [
      "/var/lib/docker"
    ];
  };
}
