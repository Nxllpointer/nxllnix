{
  configuration.nixos = {pkgs, ...}: {
    fonts.packages = [pkgs.nerd-fonts.jetbrains-mono];
  };
}
