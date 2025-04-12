rec {
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "us";
  services.xserver.xkb.layout = console.keyMap;
}
