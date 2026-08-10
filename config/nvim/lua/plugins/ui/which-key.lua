return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	lazy = false,
	opts = {
		-- preset = "helix",
		delay = 0,
		win = {
			-- don't allow the popup to overlap with the cursor
			no_overlap = true,
			-- width = { min = 4, max = 50 },
			height = { min = 4, max = 20 },
			-- col = math.huge,
			row = math.huge,
			-- border = "rounded", -- rounded, none, single, double
			border = "rounded",
			-- {
			--   "╭", "═", "╮",
			--   "║", "╯", "═", "╰", "║"
			-- },
			padding = { 0, 0 }, -- extra window padding [top/bottom, right/left]
			title = true,
			title_pos = "left",
			zindex = 1000,
			bo = {},
			wo = {
				winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
			},
		},
		layout = {
			align = "center",
			spacing = 2,
		},
		sort = { "local", "order", "group", "alphanum", "mod" },
		icons = {
			breadcrumb = "»",
			separator = "➜",
			group = "+",
			ellipsis = "…",
		},
		triggers = {
			{ "<leader>", mode = { "n", "v" } },
			{ "g", mode = "n" },
			{ "z", mode = { "n", "v" } },
			{ "<C-w>", mode = "n" },
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		-- ✅ ONLY groups go here. No action mappings with missing rhs!
		wk.add({
			{ "<leader>l", group = "LSP" },
			{ "<leader>f", group = "Find" },
			{ "<leader>s", group = "Search" },
			{ "<leader>g", group = "Git" },
			{ "<leader>u", group = "UI" },
			{ "<leader>t", group = "Terminal" },
			{ "<leader>w", group = "Windows" },
			{ "<leader>b", group = "Buffers" },
			{ "<leader>z", group = "Zen/Zoom" },
			{ "<leader>h", group = "Help" },
		})

		-- ✅ This special mapping IS valid (it has a function)
		wk.add({
			{
				"<leader>?",
				function()
					wk.show({ global = false })
				end,
				desc = "Buffer Local Keymaps",
			},
		})
	end,
}
