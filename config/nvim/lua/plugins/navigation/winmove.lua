local map = require("utils.keymap").lazy_map

return {
	"MisanthropicBit/winmove.nvim",
	keys = {
		map("n", "<leader>wm", function()
			require("winmove").start_mode("resize")
		end, {
			desc = "Resize Window",
		}),
	},
}
