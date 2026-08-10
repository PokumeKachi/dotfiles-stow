local map = require("utils.keymap").map

local Snacks = require("snacks")
local Picker = Snacks.picker

local Lsp = vim.lsp.buf

local function noAutoConfirmWrapper(fn)
	return function()
		fn({ auto_confirm = true })
	end
end

for key, fn, desc in ipairs({
    { "d", Picker.lsp_definitions, "definitions" },
    { "r", Picker.lsp_references, "references" },
    { "i", Picker.lsp_implementations, "implementations" },
    { "t", Picker.lsp_type_definitions, "type definitions" },
}) do
    map("n", "<leader>l" .. fn[1], noAutoConfirmWrapper(fn[2]), {
        desc = fn[3],
    })
end


map("n", "<leader>da", Lsp.code_action, {
	desc = "Show code actions",
})
map("n", "<leader>df", vim.diagnostic.open_float, {
	desc = "Show floating errors",
	silent = true,
})
map("n", "<leader>dl", function()
	vim.diagnostic.setloclist()
end, {
	desc = "Show diagnostics in location list",
	silent = true,
})

map("n", "<leader>la", Lsp.code_action, {
	desc = "code actions",
})
map("n", "<leader>lh", Lsp.hover, {
	silent = true,
	desc = "view documentation",
})
map("n", "<leader>ln", Lsp.rename, {
	silent = true,
	desc = "rename symbol",
})

map("n", "<leader>fm", function()
	require("conform").format({
		lsp_fallback = true,
		async = true,
	})
end, {
	silent = true,
	desc = "format code",
})
