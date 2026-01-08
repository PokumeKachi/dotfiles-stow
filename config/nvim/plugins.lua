local LazyList = {
	-- require('lazy.which-key'),
	-- replaced by mini.clue ^^
}

local NonTerm = {
	require("lazy.blink"),
	require("lazy.bufdelete"),
	require("lazy.bullets"),
	require("lazy.colorscheme"),
	require("lazy.conform"),
	require("lazy.dropbar"),
	require("lazy.flutter-tools"),
	require("lazy.focus"),
	require("lazy.indent-blankline"),
	require("lazy.gitsigns"),
	require("lazy.lspconfig"),
	require("lazy.luau-lsp"),
	require("lazy.luau-tree"),
	require("lazy.markdown-toc"),
	require("lazy.mdmath"),
	require("lazy.mini"),
	require("lazy.nabla"),
	require("lazy.neoscroll"),
	require("lazy.noice"),
	require("lazy.none-ls"),
	require("lazy.nvim-colorizer"),
    require("lazy.nvim-lsp-notify"),
	require("lazy.nvim-mapper"),
	require("lazy.nvim-notify"),
	require("lazy.nvim-ufo"),
	require("lazy.oil"),
	require("lazy.outline"),
	require("lazy.telescope"),
	require("lazy.template"),
	require("lazy.tex2uni"),
	require("lazy.tgpt"),
	require("lazy.treesitter"),
	-- require("lazy.treesitter-context"),
	require("lazy.unicode"),
	require("lazy.vimtex"),
	require("lazy.vim-fugitive"),
	require("lazy.rainbow-delimiters"),
	require("lazy.render-markdown"),
	require("lazy.snacks"),
	require("lazy.zk"),
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

require("diagnostics").setup()

-- local hues = require('mini.hues')
-- local palette = hues.make_palette(hues._palette)
--
-- vim.api.nvim_set_hl(0, 'StatusLine', { fg = palette.fg, bg = palette.bg })
-- vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = palette.fg, bg = palette.bg })
