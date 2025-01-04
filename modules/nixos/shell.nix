{ pkgs, ... }:

{
  programs = {
    fish = {
      enable = true;
      promptInit = /* fish */ ''
        set -g fish_greeting ""
        set -x SHELL ${pkgs.fish}/bin/fish

        if test "$TERM" = "xterm-256color"
          set -x STARSHIP_CONFIG ${pkgs.starship}/share/starship/presets/pastel-powerline.toml
          eval (${pkgs.starship}/bin/starship init fish)
        end

        ${pkgs.nix-your-shell}/bin/nix-your-shell fish | source

        set --erase SSH_ASKPASS # Otherwise git uses ksshaskpass *sigh*
      '';
    };
  };

  users.defaultUserShell = pkgs.fish;
}
