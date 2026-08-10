local M = {}

function M.get_bufs()
	return vim.tbl_filter(function(b)
		local name = vim.api.nvim_buf_get_name(b)

		return vim.api.nvim_buf_is_loaded(b) and name ~= ""
	end, vim.api.nvim_list_bufs())
end

function M.is_buf_in_other_win(buf)
	local current_win = vim.api.nvim_get_current_win()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if win ~= current_win and vim.api.nvim_win_get_buf(win) == buf then
			return true
		end
	end
	return false
end

return M
