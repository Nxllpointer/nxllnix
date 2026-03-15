{
  flake.modules.nixos.base = {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };
  };
}
