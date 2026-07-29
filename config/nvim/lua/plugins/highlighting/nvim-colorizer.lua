-- #FF0000
-- red
-- #F00
-- rgb(255, 0, 0)
-- rgba(255, 0, 0, 0)
-- Nvim-colorize.nvim makes all the texts above red-background-colored

return {
	"catgoose/nvim-colorizer.lua",
	event = "BufReadPost",
	opts = {
		filetypes = { "*" },
		user_default_options = {
			RGB = true, -- #RGB hex codes
			RRGGBB = true, -- #RRGGBB hex codes
			names = true, -- "blue", "red", etc.
			RRGGBBAA = true, -- #RRGGBBAA hex codes
			rgb_fn = true, -- rgb() and rgba()
			hsl_fn = true, -- hsl() and hsla()
			css = true, -- enable all CSS features
			mode = "background", -- foreground | background | virtualtext
		},
        options = {
            parsers = {
              tailwind = {
                enable = true,
                lsp = {
                  enable = true,
                  disable_document_color = true, -- default
                },
                update_names = true,
              },
            },
          },
	},
}
