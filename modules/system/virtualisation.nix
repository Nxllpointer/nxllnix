{
  # Options to set when running as virtual machine
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
        "-m 16G" # * More Memory
      ];
    };

  };
}
