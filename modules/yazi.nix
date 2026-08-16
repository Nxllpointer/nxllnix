{inputs, ...}: {
  configuration.home = {pkgs, ...}: {
    programs.yazi = {
      enable = true;
      package = inputs.yazi.packages.${pkgs.stdenv.system}.default;
    };
  };
}
