local blink_cmp = require("blink.cmp")
local map = require("utils.keymap").buf_map

local M = {}

-- Shared capabilities
M.capabilities = blink_cmp.get_lsp_capabilities()

-- Shared on_attach (LSP keymaps)
M.on_attach = function(client, bufnr)
	map(bufnr, "n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
	map(bufnr, "n", "K", vim.lsp.buf.hover, { desc = "Hover" })
	map(bufnr, "n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
	map(bufnr, "n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
	if client.server_capabilities.inlayHintProvider then
		vim.defer_fn(function()
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		end, 100) -- 100ms is usually enough
	end
end

-- Defaults that apply to ALL servers
M.defaults = {
	capabilities = M.capabilities,
	on_attach = M.on_attach,
}

-- Register a server with the modern API
function M.register(server_name, user_opts)
	user_opts = user_opts or {}

	-- Merge user options with defaults
	local config = vim.tbl_deep_extend("force", M.defaults, user_opts)

	-- Register using the modern API
	vim.lsp.config(server_name, config)
	vim.lsp.enable(server_name)
end

-- Batch register multiple servers
function M.register_all(servers)
	for server_name, user_opts in pairs(servers) do
		M.register(server_name, user_opts)
	end
end

return M
