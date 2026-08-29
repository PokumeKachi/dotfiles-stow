local map = require("utils.keymap").lazy_map

return {
	"hedyhli/outline.nvim",
	cmd = "Outline",
	opts = {},

	keys = {
		map({ "n" }, "<leader>bo", "<cmd>Outline<CR>", {
			desc = "View Buffer Outline",
		}),
	},
}
