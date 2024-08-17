{ inputs, ... }:
let
  username = "nxll";
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users.users.${username} = {
    isNormalUser = true;
    initialPassword = "123";
    extraGroups = [ "wheel" ];
    createHome = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ./../home;
  };
}
