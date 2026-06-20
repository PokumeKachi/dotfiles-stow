{ config, pkgs, ... }:

{
    home.username = builtins.getEnv "USER";
    home.homeDirectory = builtins.getEnv "HOME";

    home.stateVersion = "26.05";

    # Packages Home Manager will install
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

    # direnv with nix-direnv integration
    programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
    };

    # Optional: shell configuration (HM can manage your shell)
    # programs.zsh = {
    #     enable = true;
    #     shellAliases = {
    #         ll = "ls -l";
    #         la = "ls -a";
    #         update = "home-manager switch";
    #     };
    # };

    # Environment variables
    home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
    };

    # IMPORTANT: Let Stow manage your dotfiles, not HM
    home.file = { };

    # Let home-manager manage itself
    programs.home-manager.enable = true;
}
