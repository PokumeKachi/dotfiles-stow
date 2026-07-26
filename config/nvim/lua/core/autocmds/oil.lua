local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("Oil", { clear = true })

local oil = require("oil")

autocmd("VimEnter", {
    group = augroup,
	callback = function()
		local args = vim.fn.argv()

		if #args == 0 then
			vim.schedule(function()
				if not vim.bo.modified then
					oil.open(vim.fn.getcwd())
				end
			end)
			return
		end

		for _, path in ipairs(args) do
			local stat = vim.uv.fs_stat(path)
			if stat and stat.type == "directory" then
				vim.schedule(function()
					oil.open(path)
				end)
                return
			end
		end
	end,
})
