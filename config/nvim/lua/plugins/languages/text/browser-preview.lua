local map = require("utils.keymap").map

map("n", "<leader>bp", function()
	local ft = vim.bo.filetype

	if ft == "tex" then
		vim.cmd("VimtexCompile")
	elseif ft == "markdown" then
		vim.cmd("Vivify")
	elseif ft == "typst" then
		vim.cmd("TypstPreview")
	end
end, {
	desc = "Preview Buffer",
})

return {
	{
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		version = "1.*",
		opts = {
			open_cmd = "firefox --new-window %s",
			partial_rendering = true,
			follow_cursor = true,
		},
		config = function(_, opts)
			require("typst-preview").setup(opts)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "typst",
				callback = function()
					vim.opt_local.expandtab = true
					vim.opt_local.shiftwidth = 4
					vim.opt_local.softtabstop = 4
				end,
			})
		end,
	},

	{
		"lervag/vimtex",
		lazy = false,
		init = function()
			vim.g.vimtex_view_method = "zathura"

			vim.g.vimtex_compiler_method = "latexmk"
			vim.g.vimtex_compiler_latexmk = {
				out_dir = ".artifacts",
				continuous = 1,
				options = {
					"-pdf",
					"-interaction=nonstopmode",
					"-synctex=1",
					"-file-line-error",
					"-halt-on-error",
				},
			}

			vim.g.vimtex_compiler_silent = 1
			vim.g.vimtex_quickfix_mode = 0
			vim.g.vimtex_syntax_enabled = 0
		end,
	},

	{
		"jannis-baum/vivify.vim",
	},
}
