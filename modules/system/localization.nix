{ profile, ... }:

rec {
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "de";
  services.xserver.layout = console.keyMap;
}
