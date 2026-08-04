local lspconfig = require("lspconfig")
local blink_cmp = require("blink.cmp")

local M = {}

-- Shared capabilities and on_attach
M.capabilities = blink_cmp.get_lsp_capabilities()

-- on_attach uses the same helper for buffer-local keymaps
M.on_attach = function(client, bufnr)
    M.buf_keymap(bufnr, "n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
    M.buf_keymap(bufnr, "n", "K", vim.lsp.buf.hover, { desc = "Hover" })
    M.buf_keymap(bufnr, "n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
    M.buf_keymap(bufnr, "n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
end

-- Helper to set up an LSP server
function M.lsp_setup(server_name, user_opts)
    user_opts = user_opts or {}
    local defaults = lspconfig[server_name] and lspconfig[server_name].configs.default_config
    if not defaults then
        vim.notify("Server '" .. server_name .. "' not found in lspconfig", vim.log.levels.WARN)
        return
    end

    local final_config = vim.tbl_deep_extend("force", defaults, user_opts)
    final_config.capabilities = M.capabilities
    final_config.on_attach = M.on_attach

    vim.lsp.config(server_name, final_config)
    vim.lsp.enable(server_name)
end

return M
