local M = {}

function M.create_floating()
	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = math.floor(vim.o.columns * 0.7),
		height = math.floor(vim.o.lines * 0.6),
		row = math.floor(vim.o.lines * 0.2),
		col = math.floor(vim.o.columns * 0.15),
		style = "minimal",
		border = "rounded",
	})
end

return M
