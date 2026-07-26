return {
	"nvim-treesitter/nvim-treesitter",
    branch = "main",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		-- "hiphish/rainbow-delimiters.nvim",
	},
	opts = {
		highlight = {
			enable = true, -- enable treesitter-based highlighting
			additional_vim_regex_highlighting = false, -- disable legacy regex highlighting for speed & accuracy
		},
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
		ensure_installed = {
			"c",
			"cpp",
			"rust",

			"lua",
			"luau",
			"python",

			"make",
			"just",

			"bash",

			"kdl",
			"toml",
			"yaml",

			"html",
			"css",
			"javascript",
			"typescript",
			"typst",
			"json",

			"astro",
			"tsx",

			"latex",
			"markdown",
			"markdown_inline",
		},
	},
	config = function(_, opts)
		require("nvim-treesitter").setup(opts)

		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				vim.api.nvim_set_hl(0, "@variable", { link = "Identifier" })
			end,
		})
	end,
}
