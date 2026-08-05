local toolset = require("utils.toolset")

return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("conform").setup({
			format_on_save = false,
			--[[{
                timeout_ms = 1000,
			    lsp_fallback = true,
			},]]

			formatters = toolset.formatters,
			formatters_by_ft = toolset.formatters_by_ft,
		})
	end,
}
