return {
	"zilibobi/luau-tree.nvim",
	config = function()
		local config = require("luau-tree.config")

		config.host = "127.0.0.1"
		config.port = 3667

		config.enabled = true
	end,
}
