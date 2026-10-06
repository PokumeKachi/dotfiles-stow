return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	config = function()
		local markview = require("markview")
		vim.api.nvim_create_autocmd({ "InsertEnter" }, {
			callback = function()
				vim.cmd("Markview Disable")
			end,
		})

		vim.api.nvim_create_autocmd({ "InsertLeave" }, {
			callback = function()
				vim.cmd("Markview Enable")
			end,
		})

		markview.setup({
			enable_math = false,
            latex = {
                enable = false,
            },
			preview = {
				icon_provider = "mini",
			},
			markdown = {
				-- disable everything except hyperlinks
				block_quotes = { enable = false },
				code_blocks = { enable = false },
				headings = { enable = false },
				horizontal_rules = { enable = false },
				list_items = { enable = false },
				tables = { enable = false },
				metadata_minus = { enable = false },
				metadata_plus = { enable = false },
				reference_definitions = { enable = false },
			},
            typst = {
                enable = false,
            },
		})
	end,
	priority = 49,
}
