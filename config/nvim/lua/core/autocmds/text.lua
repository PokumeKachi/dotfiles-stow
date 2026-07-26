local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("Text", { clear = true })

autocmd("FileType", {
	pattern = { "text", "markdown", "typst" },
    group = augroup,
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
	end,
})

autocmd("FileType", {
	pattern = "markdown",
    group = augroup,
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en"

		-- vim.b.cmp_enabled = false

		vim.opt_local.completefunc = ""
		vim.opt_local.omnifunc = ""
		vim.opt_local.spell = false
		vim.b.copilot_enabled = false
		-- require("blink.cmp").setup.buffer { enabled = false }

		local pairs = require("mini.pairs")
		pairs.map_buf(0, "i", "*", { action = "open", pair = "**" })
		pairs.map_buf(0, "i", "$", { action = "open", pair = "$$" })

		vim.opt_local.conceallevel = 2
		vim.opt_local.concealcursor = "nc"

		vim.fn.matchadd("Conceal", "->", 10, -1, { conceal = "→" })
		vim.fn.matchadd("Conceal", "=>", 10, -1, { conceal = "⇒" })
		vim.fn.matchadd("Conceal", "\\.\\.\\.", 10, -1, { conceal = "…" })
	end,
})
