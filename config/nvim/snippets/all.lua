local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node

return {
	s("type shi", {
		t("quick test"),
	}),
	s(
		"date",
		f(function()
			return os.date("%Y-%m-%d")
		end)
	),
}
