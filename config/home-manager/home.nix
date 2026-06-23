{ config, pkgs, ... }:

{
    home.username = builtins.getEnv "USER";
    home.homeDirectory = builtins.getEnv "HOME";

    home.stateVersion = "26.05";

    home.packages = with pkgs; [
        direnv
        just
        neovim
        git
        curl
        wget
        ripgrep
        fd
        fzf
        tree
        htop
        btop
        gitui
    ];

    home.pointerCursor = {
        package = pkgs.gnome-themes-extra;
        name = "Adwaita-dark";
        size = 24;
        gtk.enable = true;
        x11.enable = true;
    };
    programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
    };


    home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
    };

    home.file = { };

    programs.home-manager.enable = true;
}
