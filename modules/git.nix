{
  configuration = {
    globalconfig,
    lib,
    ...
  }: {
    home = {
      programs.git = {
        enable = true;
        lfs.enable = true;
        settings = {
          user = {
            email = "54677650+Nxllpointer@users.noreply.github.com";
            name = "Nxllpointer";
          };
          credential.helper = "store";
        };
      };
      programs.delta = {
        enable = true;
        enableGitIntegration = true;
      };

      persisted.files = lib.mkIf globalconfig.impermanence.enable [".git-credentials"];
    };
  };
}
