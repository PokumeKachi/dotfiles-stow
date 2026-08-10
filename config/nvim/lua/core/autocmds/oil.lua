local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("Oil", { clear = true })

local oil = require("oil")

autocmd("BufEnter", {
	pattern = "",
	group = augroup,
	callback = function()
		vim.schedule(function()
			local buf = vim.api.nvim_get_current_buf()

			if vim.api.nvim_buf_get_name(buf) == "" and vim.bo[buf].buftype == "" then
				local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
				if #lines == 0 or (#lines == 1 and lines[1] == "") then
					oil.open()
				end
			end
		end)
	end,
	desc = "Replace empty buffers with Oil",
})
