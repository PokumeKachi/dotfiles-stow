local map = require("utils.keymap").map

local buffer = require("utils.buffer")

map("n", "<leader>bqc", function()
	vim.api.nvim_buf_delete(vim.api.nvim_get_current_buf(), { force = false })
end, {
	desc = "Quit Current Buffer",
})

map("n", "<leader>bqa", function()
	for _, buf in ipairs(buffer.get_bufs()) do
		vim.api.nvim_buf_delete(buf, { force = false })
	end
end, {
	desc = "Quit All Buffers",
})

map("n", "<leader>bqo", function()
	for _, buf in ipairs(buffer.get_bufs()) do
		if
			#vim.fn.win_findbuf(buf) == 0
			and vim.bo[buf].buftype == ""
			and vim.bo[buf].buflisted
		then
			vim.api.nvim_buf_delete(buf, { force = false })
		end
	end
end, {
	desc = "Quit Other Buffers",
})
