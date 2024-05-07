{
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  # Useable FPS for games. Kwin is weird
  environment.sessionVariables = {
    KWIN_X11_REFRESH_RATE = "144000";
    KWIN_X11_NO_SYNC_TO_VBLANK = "1";
    KWIN_X11_FORCE_SOFTWARE_VSYNC = "1";
  };
}
