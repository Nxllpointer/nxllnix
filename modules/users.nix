{
  configuration = {
    globalconfig,
    lib,
    ...
  }: {
    options = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "nxll";
      };
    };

    config = {
      nixos = {
        users.users.${globalconfig.username} = {
          isNormalUser = true;
          initialPassword = "123";
          extraGroups = ["wheel"];
          createHome = true;
        };
      };
    };
  };
}
