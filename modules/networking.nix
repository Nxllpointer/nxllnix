{
  configuration.nixos = {
    lib,
    config,
    ...
  }: {
    options = {
      hostname = lib.mkOption {
        type = lib.types.str;
      };
    };

    config = {
      networking.hostName = config.hostname;
      networking.networkmanager.enable = true;
    };
  };
}
