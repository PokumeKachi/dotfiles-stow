return {
	"lervag/vimtex",
	lazy = false, -- we don't want to lazy load VimTeX
	-- tag = "v2.15", -- uncomment to pin to a specific release
	init = function()
		-- VimTeX configuration goes here, e.g.
		vim.g.vimtex_view_method = "general"
		vim.g.vimtex_view_general_viewer = "zathura"

		vim.g.vimtex_compiler_method = "latexmk"
		vim.g.vimtex_compiler_latexmk = {
			build_dir = "build",
			continuous = 1,
			executable = "latexmk",
			options = {
				"-pdf",
				"-interaction=nonstopmode",
				"-synctex=1",
				"-file-line-error",
				"-halt-on-error",
			},
		}

		-- vim.g.vimtex_compiler_method = "tectonic"
		--
		-- vim.g.vimtex_compiler_tectonic = {
		-- 	build_dir = "build",
		-- 	continuous = 0, -- MUST be 0
		-- 	executable = "tectonic",
		-- 	options = {
		-- 		"--synctex",
		-- 		"--keep-logs",
		-- 		"--keep-intermediates",
		-- 	},
		-- }

		vim.g.vimtex_compiler_silent = 1
		vim.g.vimtex_quickfix_mode = 0
		vim.g.vimtex_syntax_enabled = 0
	end,
}
