{
  flake.modules.nixos.base = {
    lib,
    config,
    ...
  }: {
    options = {
      nxllnix.hostname = lib.mkOption {
        type = lib.types.str;
      };
    };

    config = {
      networking.hostName = config.nxllnix.hostname;
      networking.networkmanager.enable = true;
    };
  };
}
