local toolset = require("utils.toolset")

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("nvim-treesitter").install(toolset.treesitter_parsers)

		vim.treesitter.language.register("rust", "rune")

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
