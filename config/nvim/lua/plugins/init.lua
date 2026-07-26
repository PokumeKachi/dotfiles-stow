local LazyList = {
	-- require('plugins.which-key'),
	-- replaced by mini.clue ^^
}

local NonTerm = {
	require("plugins.winmove"),

	require("plugins.oil"),
	require("plugins.oil-git-status"),

	require("plugins.mini"),
	require("plugins.snacks"),

	require("plugins.blink"),
	require("plugins.bullets"),
	require("plugins.colorscheme"),
	require("plugins.conform"),
	require("plugins.dropbar"),
	require("plugins.flutter-tools"),
	-- require("plugins.focus"),
	require("plugins.indent-blankline"),
	require("plugins.gitsigns"),
	require("plugins.hardtime"),
	require("plugins.lspconfig"),
	require("plugins.luasnip"),
	require("plugins.luau-lsp"),
	require("plugins.luau-tree"),
	require("plugins.neoscroll"),
	require("plugins.noice"),
	require("plugins.none-ls"),
	require("plugins.nvim-colorizer"),
	require("plugins.nvim-dap"),
	require("plugins.nvim-lint"),
	require("plugins.nvim-lsp-notify"),
	require("plugins.nvim-lsp-file-operations"),
	require("plugins.nvim-mapper"),
	require("plugins.nvim-notify"),
	require("plugins.nvim-ts-autotag"),
	require("plugins.nvim-ufo"),
	require("plugins.outline"),
	require("plugins.template"),
	require("plugins.tex2uni"),
	require("plugins.treesitter"),
	require("plugins.treesitter-astro"),
	-- require("plugins.treesitter-context"),
	require("plugins.unicode"),
	require("plugins.vimtex"),
	require("plugins.vim-fugitive"),
	require("plugins.vim-visual-multi"),
	require("plugins.rainbow-delimiters"),

	require("plugins.typst-preview"),

	require("plugins.markdown-toc"),
	require("plugins.markdown-preview"),
	require("plugins.render-markdown"),
	require("plugins.vivify"),
	require("plugins.zk"),
	-- require("plugins.mdmath"), --markdown preview works so much better
}

function setup_lazy(List)
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

	if not vim.loop.fs_stat(lazypath) then
		print("Installing lazy.nvim from git...")

		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable",
			lazypath,
		})
	end

	vim.opt.rtp:prepend(lazypath)

	require("lazy").setup(List, {
		git = {
			depth = 1,
		},
		lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
	})
end

if vim.fn.argc() == 1 and vim.fn.argv()[1] == "+term" then
else
	for _, v in ipairs(NonTerm) do
		table.insert(LazyList, v)
	end
end

setup_lazy(LazyList)

-- local hues = require('mini.hues')
-- local palette = hues.make_palette(hues._palette)
--
-- vim.api.nvim_set_hl(0, 'StatusLine', { fg = palette.fg, bg = palette.bg })
-- vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = palette.fg, bg = palette.bg })
