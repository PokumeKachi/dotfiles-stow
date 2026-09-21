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
			enable = true,
		},
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
