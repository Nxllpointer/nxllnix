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
    ./desktop.nix
    ./printing.nix
    ./video.nix
    ./input.nix
    ./nix.nix
  ];

  system.stateVersion = "23.11";
  nixpkgs.overlays = [ (import ./../../pkgs inputs) ];
  nixpkgs.config.allowUnfree = true;
  environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";

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
    libreoffice
    flameshot
    cameractrls-gtk4
    prismlauncher
  ];

}
