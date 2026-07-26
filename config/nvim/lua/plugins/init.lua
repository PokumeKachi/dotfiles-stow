local LazyList = {
	-- require('plugins.which-key'),
	-- replaced by mini.clue ^^
}

local NonTerm = {
	require("plugins.appearance"),
	require("plugins.completion"),
	require("plugins.dap"),
	require("plugins.editing"),
	require("plugins.git"),
	require("plugins.languages"),
	require("plugins.lsp"),
	require("plugins.markdown"),
	require("plugins.navigation"),
	require("plugins.treesitter"),
	require("plugins.ui"),
}

function ensure_lazy()
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

end

if vim.fn.argc() == 1 and vim.fn.argv()[1] == "+term" then
else
	for _, v in ipairs(NonTerm) do
		table.insert(LazyList, v)
	end
end

ensure_lazy()

require("lazy").setup(LazyList, {
	git = {
		depth = 1,
	},
	lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
})

-- local hues = require('mini.hues')
-- local palette = hues.make_palette(hues._palette)
--
-- vim.api.nvim_set_hl(0, 'StatusLine', { fg = palette.fg, bg = palette.bg })
-- vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = palette.fg, bg = palette.bg })
