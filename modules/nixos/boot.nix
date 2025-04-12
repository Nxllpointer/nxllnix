{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
    };
  };

  boot.kernel.sysctl."kernel.sysrq" = 1; # Enable all SysRq features
}
