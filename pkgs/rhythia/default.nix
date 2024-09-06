{ lib
, stdenv
, rhythia-git
, godot3-headless
, godot3-export-templates
, autoPatchelfHook
, copyDesktopItems
, makeDesktopItem
, libgcc
, alsa-lib
, libGL
, libpulseaudio
, libX11
, libXcursor
, libXext
, libXi
, libXinerama
, libXrandr
, libXrender
, udev
, SDL2
}:
stdenv.mkDerivation {
  pname = "rhythia";
  version = rhythia-git.rev;

  src = rhythia-git;

  nativeBuildInputs = [
    godot3-headless
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    libgcc
    alsa-lib
    libGL
    libX11
    libXcursor
    libXext
    libXi
    libXinerama
    libXrandr
    libXrender
    udev
    SDL2
  ];

  runtimeDependencies = map lib.getLib [
    alsa-lib
    libpulseaudio
    udev
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "rhythia";
      exec = "rhythia";
      icon = "rhythia";
      desktopName = "Rhythia";
      genericName = "Rhythia";
    })
  ];

  buildPhase = /* bash */ ''
    runHook preBuild

    # Cannot create file '/homeless-shelter/.config/godot/projects/...'
    export HOME=$TMPDIR

    # Link the export-templates to the expected location. The --export commands
    # expects the template-file at .../templates/{godot-version}.stable/linux_x11_64_release
    mkdir -p $HOME/.local/share/godot
    ln -s ${godot3-export-templates}/share/godot/templates $HOME/.local/share/godot

    cp ${./export_presets.cfg} ./export_presets.cfg

    mkdir -p addons/discord_game_sdk/bin/x86_64/
    cp addons/discord_game_sdk/*.so addons/discord_game_sdk/bin/x86_64/

    mkdir -p $out/share/rhythia
    godot3-headless --export "Linux/X11" $out/share/rhythia/rhythia

    runHook postBuild
  '';

  installPhase = /* bash */ ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s $out/share/rhythia/rhythia $out/bin/

    install -Dm644 assets/images/branding/icon.png $out/share/pixmaps/rhythia.png

    runHook postInstall
  '';
}
