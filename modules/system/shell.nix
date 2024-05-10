{ pkgs, ... }:

{
  programs = {
    fish = {
      enable = true;
      promptInit = ''
        set -g fish_greeting ""

        if test "$TERM" = "xterm-256color"
          set -x STARSHIP_CONFIG ${pkgs.starship}/share/starship/presets/pastel-powerline.toml
          eval (${pkgs.starship}/bin/starship init fish)
        end

        ${pkgs.nix-your-shell}/bin/nix-your-shell fish | source
      '';
    };
  };

  users.defaultUserShell = pkgs.fish;
}
