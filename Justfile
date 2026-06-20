ARGS := "--dotfiles --no-folding --adopt"

_default:
    @just --choose

link:
    stow -D {{ARGS}} -t ~/.config config
    stow -D {{ARGS}} -t ~ home
    stow {{ARGS}} -t ~/.config config
    stow {{ARGS}} -t  ~ home

link-force:
    cd config && find . -mindepth 1 -maxdepth 1 -printf '%P\n' | while read -r item; do \
        rm -rf "$HOME/.config/$item"; \
    done
    cd home && find . -mindepth 1 -maxdepth 1 -printf '%P\n' | while read -r item; do \
        rm -rf "$HOME/$item"; \
    done
    stow {{ARGS}} -t ~/.config config
    stow {{ARGS}} -t ~ home

todo:
    taskwarrior-tui --taskdata .task

