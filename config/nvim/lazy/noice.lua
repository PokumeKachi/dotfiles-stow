return {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    require("notify").setup({
      stages = "static", -- disables animations
    })
    require("noice").setup({
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written", -- example: suppress ":w" messages
          },
          opts = { skip = true },
        },
      },
    })
  end,
}
