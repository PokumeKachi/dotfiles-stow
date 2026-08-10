local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("General", { clear = true })

autocmd("CursorHold", {
	group = augroup,
	callback = function()
		vim.diagnostic.open_float(nil, { focusable = false })
	end,
	desc = "Show Hovering Diagnostics When Caret Is Idling",
})

autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	group = augroup,
	command = "checktime",
	desc = "Auto-reload File Changes On Disk",
})
