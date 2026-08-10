-- Press ":"
-- See how the command input box is floating in the middle of the screen?
-- Yeah that was *noice*
-- The same styling also applies to like dialog boxes and notifications and allat
-- (Notifications is passed on to be handled by nvim-notify.nvim though)

local map = require("utils.keymap").lazy_map

return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = function()
		require("noice").setup({
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "written",
					},
					opts = { skip = true },
				},
			},

			notify = {
				enabled = true,
				view = "notify",
			},
			lsp = {
				progress = {
					enabled = true,
					-- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
					-- See the section on formatting for more details on how to customize.
					--- @type NoiceFormat|string
					format = "lsp_progress",
					--- @type NoiceFormat|string
					format_done = "lsp_progress_done",
					throttle = 1000 / 5, -- frequency to update lsp progress message
					view = "mini",
				},
			},
		})
	end,
	keys = {
		map("<leader>el", ":NoiceSnacks<CR>", {
			mode = { "n" },
            desc = "View Noice Notification History (With Snacks!)",
		}),
	},
}
