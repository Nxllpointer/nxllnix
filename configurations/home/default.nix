{
  profile = "private.nix";

  module = { config, lib, pkgs, ... }: {
    imports = [ ./hardware-configuration.nix ./nvidia.nix ];

    boot.tmp.useTmpfs = true;
  };
}

