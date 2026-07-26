return {
    "mrcjkb/rustaceanvim",
    version = "^6",
    ft = { "rust" },

    init = function()
        vim.g.rustaceanvim = {
            server = {
                default_settings = {
                    ["rust-analyzer"] = {},
                },
            },
        }
    end,
}
