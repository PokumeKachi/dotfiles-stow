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
	keys = {
		{
			"<C-l>",
			function()
				local ls = require("luasnip")
				if ls.jumpable(1) then
					local dest = ls.jump_destination(1)
					if dest and dest:get_jump_index() ~= 0 then
						ls.jump(1)
					end
				end
			end,
			mode = { "i", "s" },
			silent = true,
		},
		{
			"<C-h>",
			function()
				local ls = require("luasnip")
				if ls.jumpable(-1) then
					local dest = ls.jump_destination(-1)
					if dest and dest:get_jump_index() ~= 0 then
						ls.jump(-1)
					end
				end
			end,
			mode = { "i", "s" },
			silent = true,
		},
		{
			"<C-e>",
			function()
				local ls = require("luasnip")
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end,
			mode = { "i", "s" },
			silent = true,
		},
	},
}
