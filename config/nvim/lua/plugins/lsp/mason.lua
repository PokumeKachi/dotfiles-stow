local toolset = require('utils.toolset')

local to_be_installed = {
    "tree-sitter-cli",
}

local excluded_packages = {
    dartls = true,
    nixd = true,
    just_lsp = true,

    rustfmt = true,
    dart_format = true,
}

local formatter_to_mason = {}

local function get_all_referenced_formatters()
    local seen = {}
    local result = {}

    for name, _ in pairs(toolset.formatters) do
        seen[name] = true
        table.insert(result, name)
    end

    for _, formatter_list in pairs(toolset.formatters_by_ft) do
        for _, name in ipairs(formatter_list) do
            if not seen[name] then
                seen[name] = true
                table.insert(result, name)
            end
        end
    end

    return result
end

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
            local mappings = require("mason-lspconfig").get_mappings()

            local lsp_server_names = vim.tbl_keys(toolset.lsp)

            for _, server_name in ipairs(lsp_server_names) do
                if not excluded_packages[server_name] then
                    table.insert(
                        to_be_installed,
                        mappings.lspconfig_to_package[server_name] or server_name
                    )
                end
            end

            local formatter_names = get_all_referenced_formatters()

            for _, name in ipairs(formatter_names) do
                if not excluded_packages[name] then
                    table.insert(to_be_installed, formatter_to_mason[name] or string.gsub(name, "_", "-"))
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
