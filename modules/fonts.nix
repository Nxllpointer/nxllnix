{
  flake.modules.nixos.base = {pkgs, ...}: {
    fonts.packages = [pkgs.nerd-fonts.jetbrains-mono];
  };
}
