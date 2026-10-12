-- The theme of our editor

return {
	{ "ellisonleao/gruvbox.nvim", priority = 1000, opts = {} },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		config = function()
			require("catppuccin").setup({
				flavour = "frappe",
				background = {
					light = "latte",
					dark = "mocha",
				},
                custom_highlights = {
                    LineNr = {
                        fg = "#888888",
                        bg = "NONE",
                    },
                    CursorLineNr = {
                        fg = "#ff0000",
                        bold = true,
                    },
                },
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
