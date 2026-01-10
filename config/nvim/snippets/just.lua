local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

function tab(tab_space)
	return string.rep(" ", tab_space or 4)
end

return {
	s("template", {
		t({
			"_default:",
			tab() .. "@just --choose",
			"",
			"todo:",
			tab() .. "taskwarrior-tui --taskdata .task",
			"",
			"git:",
			tab() .. "gitui",
		}),
	}),
}
