{ pkgs, settings, ... }: {
  users.users.nxll = {
    isNormalUser = true;
    initialPassword = "123";
    extraGroups = [ "wheel" ];
    createHome = true;
  };
}
