{
  imports = [ ./hardware-configuration.nix ./nvidia.nix ];

  boot.tmp.useTmpfs = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hardware.cpu.amd.updateMicrocode = true;

  hardware.opentabletdriver = {
    enable = true;
  };
}
