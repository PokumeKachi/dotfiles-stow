return {
	"mrcjkb/rustaceanvim",
	version = "^9",
	ft = { "rust" },

	init = function()
		vim.g.rustaceanvim = function()
			return {
				server = {
					default_settings = {
						["rust-analyzer"] = {
							checkOnSave = false,
						},
					},
				},
			}
		end
	end,
}
