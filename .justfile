ARGS := "--dotfiles --no-folding"

_default:
    @just --choose

link:
  stow -D {{ARGS}} -t ~/.config config
  stow -D {{ARGS}} -t ~ home
  stow {{ARGS}} -t ~/.config config
  stow {{ARGS}} -t  ~ home

git:
    gitui

todo:
    taskwarrior-tui --taskdata .task

