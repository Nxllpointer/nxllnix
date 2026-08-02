{
  configuration = {
    lib,
    globalconfig,
    ...
  }: {
    nixos = {pkgs, ...}: {
      services.ratbagd.enable = true;
      environment.systemPackages = with pkgs; [piper];

      hardware.opentabletdriver.enable = true;
    };

    home = {
      persisted.directories = lib.mkIf globalconfig.impermanence.enable [
        ".config/OpenTabletDriver"
      ];
    };
  };
}
