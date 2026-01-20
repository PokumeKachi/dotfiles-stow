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
		t(base),
	}),
	s("template_with_flake", {
		t(vim.list_extend(vim.deepcopy(base), {
			"",
			"develop:",
			tab() .. "@sh -c ' \\",
			tab(2) .. "h=$(nix hash path ./flake.nix); \\",
			tab(2) .. 'old="$FLAKE_HASH"; \\',
			tab(2) .. 'if [ "$old" != "$h" ]; then \\',
			tab(3) .. "echo \"Entering flake shell...\"; \\",
			tab(3) .. 'FLAKE_HASH="$h" exec nix develop; \\',
			tab(2) .. "else \\",
			tab(3) .. "echo \"Inside flake shell, skipping nix develop...\"; \\",
			tab(2) .. "fi \\",
			tab() .. "'",
		})),
	}),
}
