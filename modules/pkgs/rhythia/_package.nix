{
  stdenv,
  godot_4_7-mono,
  dotnetCorePackages,
  buildDotnetModule,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  alsa-lib,
  brotli,
  dbus,
  libdecor,
  embree,
  enet,
  fontconfig,
  freetype,
  glib,
  glslang,
  graphite2,
  harfbuzz,
  icu,
  mbedtls,
  miniupnpc,
  libogg,
  openxr-loader,
  pcre2,
  libpng,
  libpulseaudio,
  sdl3,
  speechd-minimal,
  libtheora,
  libjpeg_turbo,
  udev,
  libvorbis,
  wayland,
  libwebp,
  wslay,
  libX11,
  libXcursor,
  libXext,
  libXi,
  libXinerama,
  libxkbcommon,
  libXrandr,
  libXrender,
  zstd,
  vulkan-loader,
}: let
  godot-pkg = godot_4_7-mono;
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  godot = godot-pkg.overrideAttrs {
    inherit dotnet-sdk;
  };
  export-template = godot-pkg.export-template;

  harfbuzz-raster = harfbuzz.override {
    withRaster = true;
    withCairo = true;
  };
  harfbuzz-icu = harfbuzz-raster.override {
    withIcu = true;
    harfbuzz = harfbuzz-raster;
  };
in
  buildDotnetModule {
    pname = "rhythia";
    version = "0.0.1-dev";

    src = builtins.fetchGit {
      url = "https://github.com/Rhythia/Client";
      rev = "cbc8d5567b0164f87b24ae4ccc4f6b986c573109";
      shallow = true;
    };

    projectFile = "Rhythia.csproj";
    nugetDeps = ./deps.json;

    inherit dotnet-sdk dotnet-runtime;

    nativeBuildInputs = [
      godot
      autoPatchelfHook
      copyDesktopItems
    ];

    buildInputs = [
      stdenv.cc.cc.lib
      alsa-lib
      brotli
      dbus
      libdecor
      embree
      enet
      fontconfig
      freetype
      glib
      glslang
      graphite2
      harfbuzz-icu
      icu
      mbedtls
      miniupnpc
      libogg
      openxr-loader
      pcre2
      libpng
      libpulseaudio
      sdl3
      speechd-minimal
      libtheora
      libjpeg_turbo
      udev
      libvorbis
      wayland
      libwebp
      wslay
      libX11
      libXcursor
      libXext
      libXi
      libXinerama
      libxkbcommon
      libXrandr
      libXrender
      zstd
      vulkan-loader
    ];

    # Skip default dotnet build/install. Using Godot export instead
    dontDotnetBuild = true;
    dontDotnetInstall = true;

    buildPhase = ''
      runHook preBuild

      export HOME=$TMPDIR

      mkdir -p $HOME/.local/share/godot/export_templates
      ln -s ${export-template}/share/godot/export_templates/* $HOME/.local/share/godot/export_templates/

      cp ${./export_presets.cfg} ./export_presets.cfg

      godot4-mono --headless --build-solutions --quit 2>&1 || true

      mkdir -p $out/share/rhythia
      godot4-mono --headless --export-release "Linux" $out/share/rhythia/Rhythia.x86_64

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      ln -s $out/share/rhythia/Rhythia.x86_64 $out/bin/rhythia

      install -Dm644 textures/icon.svg $out/share/pixmaps/rhythia.svg

      runHook postInstall
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "rhythia";
        exec = "rhythia";
        icon = "rhythia";
        desktopName = "Rhythia";
        genericName = "Rhythm Game";
      })
    ];
  }
