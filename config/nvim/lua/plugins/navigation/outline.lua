local map = require("utils.keymap").lazy_map

return {
	"hedyhli/outline.nvim",
	cmd = "Outline",
	opts = {},

	keys = {
		map("<leader>bo", ":Outline<CR>", {
			mode = { "n" },
			desc = "View Buffer Outline",
		}),
	},
}
