-- lsp/utils.lua
local lspconfig = require("lspconfig")
local blink_cmp = require("blink.cmp")

local M = {}

-- Shared capabilities and on_attach (defined once)
M.capabilities = blink_cmp.get_lsp_capabilities()
M.on_attach = function(client, bufnr)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover" })
end

-- Helper that merges defaults, injects capabilities, and registers
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

function M.keymap(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { silent = true }, opts or {}))
end

function M.buf_keymap(bufnr, mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { silent = true, buffer = bufnr }, opts or {}))
end

return M
