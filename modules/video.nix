{
  configuration.nixos = {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };
  };
}
