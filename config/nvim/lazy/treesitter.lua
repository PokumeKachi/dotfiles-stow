return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		-- "hiphish/rainbow-delimiters.nvim",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
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
				"json",

				"latex",
                "markdown",
                "markdown_inline",
			},
		})

		vim.api.nvim_set_hl(0, "@variable", { link = "Identifier" })
	end,
}
