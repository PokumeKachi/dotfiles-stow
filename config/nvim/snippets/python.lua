local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s("py_main", {
		t("if __name__ == '__main__':"),
		t({ "", string.rep(" ", 4) }),
		i(1, "code"),
		t({ "", string.rep(" ", 4) }),
		i(3, "code"),
		t({ "", string.rep(" ", 4) }),
		i(2, "code"),
	}),
}
