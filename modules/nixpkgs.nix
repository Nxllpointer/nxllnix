{
  configuration.nixos = {
    nixpkgs.config.allowUnfree = true;
    environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  };
}
