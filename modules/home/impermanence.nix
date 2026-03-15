let
  persistedDirs = [
    "Documents"
    "Downloads"
    "Pictures"
    "Videos"
    "Music"
    ".ssh"
  ];
in
{
  home.persistence."/persisted" = {
    directories = persistedDirs;
  };

  home.file = builtins.listToAttrs (
    map
      (dir: {
        name = "${dir}/.directory";
        value = {
          text = ''
            [Desktop Entry]
            Icon=folder-orange
          '';
        };
      })
      persistedDirs
  );
}
