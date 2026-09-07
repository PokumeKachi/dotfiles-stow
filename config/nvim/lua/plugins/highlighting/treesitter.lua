local toolset = require("utils.toolset")

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		-- "hiphish/rainbow-delimiters.nvim",
	},
	opts = {
		incremental_selection = {
			enable = true,
		},
		indent = {
			enable = true, -- enable treesitter indent (can improve indent accuracy)
		},
		-- optional: enable rainbow parentheses for easier nesting visibility
		-- rainbow = {
		--   enable = true,
		--   extended_mode = true, -- highlight non-bracket delimiters too
		--   max_file_lines = nil, -- disable limit on file size
		-- },
		--
		modules = {},
		sync_install = false,
		auto_install = true,

		ignore_install = {},
		ensure_installed = toolset.treesitter_parsers,
	},
	config = function(_, opts)
		require("nvim-treesitter").setup(opts)

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
				if not lang then
					return
				end

				pcall(vim.treesitter.start, args.buf, lang)
			end,
		})

		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				vim.api.nvim_set_hl(0, "@variable", { link = "Identifier" })
			end,
		})
	end,
}
