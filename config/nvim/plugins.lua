local LazyList = {
	-- require('lazy.which-key'),
	-- replaced by mini.clue ^^
}

local NonTerm = {
	-- require('lazy.auto-save'),
	-- require('lazy.bufferline'),,
	require("lazy.blink"),
	require("lazy.bullets"),
	require("lazy.colorscheme"),
	require("lazy.comfy-line-numbers"),
	require("lazy.conform"),
	require("lazy.flutter-tools"),
	require("lazy.focus"),
	-- require('lazy.fyler'),
	-- require('lazy.headlines'), replaced by render-markdown
	-- require("lazy.incline"), just use mini.statusline
	require("lazy.indent-blankline"),
	require("lazy.gitsigns"),
	require("lazy.lspconfig"),
	require("lazy.luau-lsp"),
	require("lazy.luau-tree"),
	-- require('lazy.markdown-preview'),
	require("lazy.markdown-toc"),
	-- require('lazy.markview'),
	require("lazy.mini"),
	require("lazy.nabla"),
	require("lazy.neoscroll"),
	require("lazy.noice"),
	require("lazy.none-ls"),
	-- require('lazy.nvim-cmp'),
	require("lazy.nvim-colorizer"),
	-- require('lazy.nvim-surround'),
	require("lazy.oil"),
	require("lazy.outline"),
	require("lazy.telescope"),
	require("lazy.template"),
	require("lazy.tex2uni"),
	require("lazy.tgpt"),
	require("lazy.toggleterm"),
	require("lazy.treesitter"),
	require("lazy.treesitter-context"),
	require("lazy.unicode"),
	require("lazy.vimtex"),
	require("lazy.vim-fugitive"),
	require("lazy.rainbow-delimiters"),
	require("lazy.render-markdown"),
	-- require('lazy.rust-tools'),
	require("lazy.snacks"),
	require("lazy.zk"),
	-- require('lazy.stay-centered'),
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

require('diagnostics').setup()

-- local hues = require('mini.hues')
-- local palette = hues.make_palette(hues._palette)
--
-- vim.api.nvim_set_hl(0, 'StatusLine', { fg = palette.fg, bg = palette.bg })
-- vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = palette.fg, bg = palette.bg })
