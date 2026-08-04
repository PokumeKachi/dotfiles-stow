return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        opts = {},
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = {},
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        opts = function()
            local to_be_installed = {
                "tree-sitter-cli",
            }

            local mappings = require("mason-lspconfig").get_mappings()
            local lsp_servers = vim.tbl_keys(require("utils.tools").lsp)
            local excluded_lsp_servers = {
                dartls = true,
                nixd = true,
                just_lsp = true,
            }

            for _, server_name in ipairs(lsp_servers) do
                if not excluded_lsp_servers[server_name] then
                    table.insert(
                        to_be_installed,
                        mappings.lspconfig_to_package[server_name] or server_name
                    )
                end
            end

            return {
                ensure_installed = to_be_installed,
                auto_update = false,
                run_on_start = true,
                start_delay = 0,
                debounce_hours = 0,
            }
        end,
    },
}
