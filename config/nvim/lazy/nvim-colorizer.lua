return {
  'NvChad/nvim-colorizer.lua',
  opts = {
    filetypes = { "*" },
    user_default_options = {
      RGB = true,          -- #RGB hex codes
      RRGGBB = true,       -- #RRGGBB hex codes
      names = true,        -- "blue", "red", etc.
      RRGGBBAA = true,     -- #RRGGBBAA hex codes
      rgb_fn = true,       -- rgb() and rgba()
      hsl_fn = true,       -- hsl() and hsla()
      css = true,          -- enable all CSS features
      mode = "background", -- foreground | background | virtualtext
    }
  },
  config = function(_, opts)
    require("colorizer").setup(opts)
  end
}
