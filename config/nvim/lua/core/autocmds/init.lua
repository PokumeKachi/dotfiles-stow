require("core.autocmds.dart")

require("core.autocmds.oil")
require("core.autocmds.terminal")
require("core.autocmds.text")

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("General", { clear = true })

autocmd("CursorHold", {
    group = augroup,
	callback = function()
		vim.diagnostic.open_float(nil, { focusable = false })
	end,
})

autocmd(
    { "FocusGained", "BufEnter", "CursorHold" },
    {
        group = augroup,
        command = "checktime",
    }
)

