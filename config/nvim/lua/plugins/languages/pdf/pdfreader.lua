return {
	"r-pletnev/pdfreader.nvim",
	lazy = false,
	dependencies = {
		"folke/snacks.nvim", -- image rendering
	},
	config = function()
		require("pdfreader").setup()
	end,
}
