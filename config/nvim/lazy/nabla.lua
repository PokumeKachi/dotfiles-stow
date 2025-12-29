return {
    "jbyuki/nabla.nvim",
    dependencies = {
        "nvim-neo-tree/neo-tree.nvim",
    },
    lazy = true,

    config = function()
        -- require("nvim-treesitter.configs").setup({
        --     ensure_installed = { "latex" },
        --     auto_install = true,
        --     sync_install = false,
        -- })
    end,

    keys = function()
        return {
            {
                "<leader>mp",
                ':lua require("nabla").popup()<cr>',
                -- ':lua require("nabla").toggle_virt()<cr>',
                desc = "NablaPopUp",
            },
        }
    end,
}
