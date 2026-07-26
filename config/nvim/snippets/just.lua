local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local function indent(level)
    level = level or 1
    local unit = vim.o.expandtab
        and string.rep(" ", vim.o.shiftwidth)
        or "\t"

    return unit:rep(level)
end

local base = {
	"_default:",
	indent() .. "@just --choose",

	"",
	"todo:",
	indent() .. "taskwarrior-tui --taskdata .task",
}

return {
	s("template", {
		t(base),
	}),
	-- s("template_with_flake", {
	-- 	t(vim.list_extend(vim.deepcopy(base), {
	-- 		"",
	-- 		"develop:",
	-- 		indent() .. "@sh -c ' \\",
	-- 		indent(2) .. "h=$(nix hash path ./flake.nix); \\",
	-- 		indent(2) .. 'old="$FLAKE_HASH"; \\',
	-- 		indent(2) .. 'if [ "$old" != "$h" ]; then \\',
	-- 		indent(3) .. "echo \"Entering flake shell...\"; \\",
	-- 		indent(3) .. 'FLAKE_HASH="$h" exec nix develop; \\',
	-- 		indent(2) .. "else \\",
	-- 		indent(3) .. "echo \"Inside flake shell, skipping nix develop...\"; \\",
	-- 		indent(2) .. "fi \\",
	-- 		indent() .. "'",
	-- 	})),
	-- }),
}
