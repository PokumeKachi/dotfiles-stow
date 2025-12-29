return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require("bufferline").setup({
      -- highlights = require("bufferline.themes").get_theme("catppuccin"),
      options = {
        mode = "buffers",
        show_close_icon = false,
        show_buffer_close_icons = false,
        indicator = { style = "none" },
        hover = { enabled = false }, -- disables mouse hover interactions
        clickable = false,           -- disables mouse clicks on tabs
        separator_style = "thin",    -- or "none" for minimal style
      },
    })
  end,
}
