return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	build = "make install_jsregexp",
	event = "InsertEnter",
	config = function(_, opts)
		local luasnip = require("luasnip")
		luasnip.setup(opts)

		require("luasnip.loaders.from_lua").lazy_load({
			paths = vim.fn.stdpath("config") .. "/snippets",
		})
	end,
}
