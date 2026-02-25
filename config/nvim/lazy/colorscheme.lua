return {
	{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
			})
			vim.cmd.colorscheme("catppuccin")

			vim.api.nvim_set_hl(0, "LineNr", { fg = "#fff5f5", bg = "#1e1e1e" }) -- normal line numbers
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffafa0", bold = true }) -- current line number
		end,
	},
}
