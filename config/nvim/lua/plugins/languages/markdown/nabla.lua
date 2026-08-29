-- Latex Preview for Markdown

local map = require("utils.keymap").lazy_map

return {
	"jbyuki/nabla.nvim",
	ft = { "markdown", "tex" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		vim.g.nabla_border = "rounded" -- "single", "double", "none"
	end,
	keys = {
		map({ "n", "v" }, "<leader>mp", function()
			require("nabla").popup()
		end, {
			desc = "Preview Math Expression",
		}),
	},
}
