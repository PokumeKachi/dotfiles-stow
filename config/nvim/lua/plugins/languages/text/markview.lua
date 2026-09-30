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
			preview = {
				icon_provider = "mini",
			},
			markdown = {
				-- disable everything except hyperlinks
				headings = { enable = false },
				block_quotes = { enable = false },
				code_blocks = { enable = false },
				horizontal_rules = { enable = false },
				list_items = { enable = false },
				tables = { enable = false },
				footnotes = { enable = false },
				inline_codes = { enable = false },
				images = { enable = false },
				email_links = { enable = false },
				entities = { enable = false },
				escaped_characters = { enable = false },
				reference_links = { enable = false },
				hyperlinks = { enable = true },
			},
		})
	end,
	priority = 49,
}
