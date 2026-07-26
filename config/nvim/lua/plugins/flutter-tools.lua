return {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()

        require("flutter-tools").setup {
            closing_tags = {
                -- highlight = "ErrorMsg",
                prefix = "   >> ",
            },
            lsp = {
                color = {
                    enabled = true,
                    foreground = true,
                },
                capabilities = capabilities,
            },
        }
    end,
}
