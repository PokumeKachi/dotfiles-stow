local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("Oil", { clear = true })

local oil = require("oil")

local function openOil(path)
    vim.schedule(function()
        oil.open(path)
    end)
end

autocmd("VimEnter", {
    group = augroup,
	callback = function()
		local args = vim.fn.argv()

		if #args == 0 then
            openOil(vim.fn.getcwd())
			return
		end

		for _, path in ipairs(args) do
			local stat = vim.uv.fs_stat(path)

			if stat and stat.type == "directory" then
                openOil(path)

                break
			end
		end
	end,
    desc = "Opens Oil on editor start",
})
