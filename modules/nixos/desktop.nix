{ pkgs, ... }: {
  services = {
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
    desktopManager.plasma6.enable = true;
    xserver.enable = true;
  };
  
  environment.systemPackages = [ pkgs.kdePackages.kzones ];
}
