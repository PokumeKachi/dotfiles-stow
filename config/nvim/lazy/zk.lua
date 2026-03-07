return {
	"zk-org/zk-nvim",
	config = function()
		require("zk").setup({
			picker = "fzf_lua",

			lsp = {
				config = {
					name = "zk",
					cmd = { "zk", "lsp" },
					filetypes = { "markdown", "typst" },
				},

				auto_attach = {
					enabled = true,
				},
			},
		})
	end,
}
