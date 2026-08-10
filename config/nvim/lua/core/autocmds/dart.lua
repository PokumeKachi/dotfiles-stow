local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("Dart", { clear = true })

autocmd("FileType", {
	pattern = "dart",
	group = augroup,
	callback = function()
		vim.opt_local.softtabstop = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
	end,
	desc = "Custom Tab Size For Dart",
})
