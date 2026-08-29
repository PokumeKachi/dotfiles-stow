local map = require("utils.keymap").map

local Lsp = vim.lsp.buf
local Diagnostic = vim.diagnostic

map("n", "<leader>la", Lsp.code_action, {
	desc = "See Code Actions",
})

map("n", "K", Lsp.hover, {
	desc = "Hover Documentation",
})

map("n", "<leader>ln", Lsp.rename, {
	desc = "Rename Symbol",
})

map("n", "<C-k>", Lsp.signature_help, {
	desc = "Signature Help",
})

map("n", "<leader>df", Diagnostic.open_float, {
	desc = "View Floating Diagnostics",
})

map("n", "<leader>dq", Diagnostic.setqflist, {
	desc = "View Diagnostics Quickfix List",
})

map("n", "<leader>dl", Diagnostic.setloclist, {
	desc = "View Diagnostic Location Lists",
})

map("n", "[d", Diagnostic.goto_prev, {
	desc = "Prev Diagnostic",
})

map("n", "]d", Diagnostic.goto_next, {
	desc = "Next Diagnostic",
})
