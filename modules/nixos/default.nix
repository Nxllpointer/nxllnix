{ pkgs, inputs, ... }:

{
  imports = [
    ./boot.nix
    ./virtualisation.nix
    ./localization.nix
    ./users.nix
    ./networking.nix
    ./sound.nix
    ./index.nix
    ./shell.nix
    ./fonts.nix
    ./desktop
    ./printing.nix
  ];

  system.stateVersion = "23.11";

  nixpkgs.overlays = [ (import ./../../pkgs inputs) ];

  nixpkgs.config.allowUnfree = true;
  environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";

  nix = {
    settings = { experimental-features = [ "flakes" "nix-command" ]; };
    nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
  };

  environment.systemPackages = with pkgs; [
    file
    firefox
    vscode
    libsForQt5.kate
    vesktop
    btop
    trash-cli
    bat
    rhythia
  ];

}
