-- IDE-like breadcrumbs
local map = require("utils.keymap").map

return {
	"Bekaboo/dropbar.nvim",
	dependencies = {
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	config = function()
		local dropbar_api = require("dropbar.api")
		map("n", "<leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
		map("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
		map("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
	end,
}
