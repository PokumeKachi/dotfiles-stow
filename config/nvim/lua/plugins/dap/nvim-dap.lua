local map = require('utils.keymap').lazy_map

return {
    "mfussenegger/nvim-dap",
    keys = {
        map('<F9>', {
            mode = "n",
            callback = function()
                require("dap").toggle_breakpoint()
            end,
            desc = "Toggle brekapoint",
        })
        -- You can add more DAP‑related keys here if desired, e.g.:
        -- { "<F10>", function() require("dap").step_over() end,  mode = "n", desc = "Step over" },
        -- { "<F11>", function() require("dap").step_into() end,  mode = "n", desc = "Step into" },
        -- { "<F12>", function() require("dap").step_out() end,   mode = "n", desc = "Step out" },
        -- { "<F5>",  function() require("dap").continue() end,   mode = "n", desc = "Start/continue debug" },
    },
}
