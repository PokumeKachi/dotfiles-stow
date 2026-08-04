return {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },

    -- Optional: lazy-load on file open for faster startup
    event = { "BufReadPre", "BufNewFile" },

    config = function()
local servers = require("lsp-servers")
        local lsp_utils = require("utils.lsp")

        -- ✅ Register custom servers (if needed)
        local configs = require("lspconfig.configs")
        if not configs.just_lsp then
            configs.just_lsp = {
                default_config = {
                    cmd = { "just-lsp" },
                    filetypes = { "just" },
                    root_dir = vim.fs.root(0, { "justfile", ".justfile", ".git" }),
                },
            }
        end

        -- ✅ Register ALL servers with one call
        lsp_utils.register_all(servers)
    end,
}
