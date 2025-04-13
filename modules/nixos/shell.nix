{ pkgs, ... }: {
    users.defaultUserShell = pkgs.nushell;
    
    # Enable completion scripts
    programs.fish.enable = true;
    programs.zsh.enable = true;
}
