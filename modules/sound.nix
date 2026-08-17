{
  configuration = {
    nixos = {pkgs, ...}: {
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      environment.systemPackages = [pkgs.qpwgraph];
    };

    home = {pkgs, ...}: {
      programs.mpv = {
        enable = true;
        scripts = with pkgs.mpvScripts; [mpris];
      };
      programs.yt-dlp.enable = true;

      home.packages = with pkgs; [playerctl];
    };
  };
}
