local map = require("utils.keymap").map

local buffer = require("utils.buffer")

vim.keymap.set("n", "<leader>qbc", function()
	local current_buf = vim.api.nvim_get_current_buf()
	vim.cmd("bnext")
	vim.api.nvim_buf_delete(current_buf, { force = false })
end, { desc = "Delete previous buffer (keep window)" })

map("n", "<leader>qba", function()
	for _, buf in ipairs(buffer.get_bufs()) do
		vim.api.nvim_buf_delete(buf, { force = false })
	end
end, {
	desc = "Quit All Buffers",
})

map("n", "<leader>qbo", function()
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
