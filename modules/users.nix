{
  flake.modules.nixos.base = {
    lib,
    config,
    ...
  }: {
    options = {
      nxllnix.username = lib.mkOption {
        type = lib.types.str;
        default = "nxll";
      };
    };
    config = {
      users.users.${config.nxllnix.username} = {
        isNormalUser = true;
        initialPassword = "123";
        extraGroups = ["wheel"];
        createHome = true;
      };
    };
  };
}
