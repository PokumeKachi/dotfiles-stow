-- Fancy notification boxes!

return {
	"rcarriga/nvim-notify",
	   event = "VeryLazy",
	config = function()
		vim.notify = require("notify")
		vim.notify.setup({
			background_colour = "NotifyBackground",
			fps = 30,
			icons = {
				DEBUG = "",
				ERROR = "",
				INFO = "",
				TRACE = "✎",
				WARN = "",
			},
			level = 2,
			minimum_width = 30,
			render = "compact",
			stages = "slide",
			time_formats = {
				notification = "%T",
				notification_history = "%FT%T",
			},
			timeout = 2000,
			top_down = true,
		})
	end,
}
