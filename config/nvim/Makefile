PHONY_TARGETS := git test md-test c-test rs-test nix-test dart-test
.PHONY: $(PHONY_TARGETS)

all:
	@printf '%s\n' $(PHONY_TARGETS) | fzf | xargs -r make

gitui:
	gitui

git: gitui
	ssh kachi@ka.myvnc.com 'cd ~/.config/nvim && git pull'

test:
	@XDG_CONFIG_HOME=.. nvim

dart-test:
	@XDG_CONFIG_HOME=.. nvim .tests/test.dart
	# @XDG_CONFIG_HOME=.. nvim /home/kachi/projects/thinkplan/todo/lib/main.dart

md-test:
	@XDG_CONFIG_HOME=.. nvim .tests/test.md

dir-test:
	@XDG_CONFIG_HOME=.. nvim .tests/

c-test:
	@XDG_CONFIG_HOME=.. nvim .tests/test.c

rs-test:
	@XDG_CONFIG_HOME=.. nvim .tests/test.rs

nix-test:
	@XDG_CONFIG_HOME=.. nvim .tests/test.nix
	
html-test:
	@XDG_CONFIG_HOME=.. nvim .tests/test.html

luau-test:
	@XDG_CONFIG_HOME=.. nvim .tests/luau
