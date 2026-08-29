local toolset = require("utils.toolset")
local map = require("utils.keymap").lazy_map

return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("conform").setup({
			format_on_save = false,
			formatters = toolset.formatters,
			formatters_by_ft = toolset.formatters_by_ft,
		})
	end,
	keys = {
		map("n", "<leader>lf", function()
			require("conform").format({
				lsp_fallback = true,
				async = true,
			})
		end, { desc = "Auto-format Code" }),
	},
}
