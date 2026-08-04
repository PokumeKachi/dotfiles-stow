local M = {}

function M.get_current()
	local cwd = vim.uv.cwd()

	if vim.bo.buftype == "terminal" or vim.bo.filetype == "oil" then
		return "."
	end

	local name = vim.api.nvim_buf_get_name(0)
	if name == "" then
		return "."
	end

	return vim.fn.fnamemodify(name, ":.")
end

return M
