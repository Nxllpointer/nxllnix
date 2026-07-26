{
  configuration.nixos = {
    boot.kernel.sysctl."kernel.sysrq" = 1; # Enable all SysRq features
  };
}
