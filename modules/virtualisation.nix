{
  configuration = {
    globalconfig,
    lib,
    ...
  }: {
    nixos = {
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
      users.users.${globalconfig.username}.extraGroups = ["docker"];

      persisted.directories = lib.mkIf globalconfig.impermanence.enable [
        "/var/lib/docker"
      ];
    };
  };
}
