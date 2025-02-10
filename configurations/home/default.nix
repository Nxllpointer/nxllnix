{ config, lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ./nvidia.nix ];

  boot.tmp.useTmpfs = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hardware.opentabletdriver = {
    enable = true;
  };
}
