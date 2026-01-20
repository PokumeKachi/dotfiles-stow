local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

function tab(tab_count, tab_space)
	return string.rep(" ", (tab_count or 1) * (tab_space or 4))
end

local base = {
	"_default:",
	tab() .. "@just --choose",

	"",
	"todo:",
	tab() .. "taskwarrior-tui --taskdata .task",

	"",
	"git:",
	tab() .. "gitui",
}

return {
	s("template", {
		t({ "{", tab() .. 'description = "' }),
		i(1, "description"),
		t({ '";', tab() .. 'inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-' }),
		i(2, "nixpkgs version"),
		t({
			'";',
			tab() .. "outputs =",
			tab(2) .. "{ self, nixpkgs }:",
			tab(2) .. "let",
			tab(3) .. 'system = "x86_64-linux";',
			tab(3) .. "pkgs = nixpkgs.legacyPackages.${system};",
			tab(2) .. "in",
			tab(2) .. "{",
			tab(3) .. "devShells.${system}.default = pkgs.mkShell {",
			tab(4) .. "packages = with pkgs; [",
			tab(5) .. "bashInteractive",
			tab(4) .. "];",
			tab(4) .. "shellHook = ''",
			tab(5) .. "export SHELL=${pkgs.bashInteractive}/bin/bash",
			tab(4) .. "'';",
			tab(3) .. "};",
			tab(2) .. "};",
            '}'
		}),
	}),
}
