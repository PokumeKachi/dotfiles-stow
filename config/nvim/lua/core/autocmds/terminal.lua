local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("Terminal", { clear = true })

autocmd("TermOpen", {
    group = augroup,
	callback = function()
        vim.cmd.startinsert()
	end,
    desc = "Start terminal in Insert mode, not the default Normal mode",
})
