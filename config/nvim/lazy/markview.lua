return {
    "OXY2DEV/markview.nvim",
    lazy = false,
    config = function()
        local markview = require("markview")
        vim.api.nvim_create_autocmd({ "InsertEnter" }, {
            callback = function()
                vim.cmd("Markview Disable")
            end,
        })

        vim.api.nvim_create_autocmd({ "InsertLeave" }, {
            callback = function()
                vim.cmd("Markview Enable")
            end,
        })

        markview.setup({
            enable_math = true,
            preview = {
                icon_provider = "mini",
            },
        })
    end,
    priority = 49,
}
