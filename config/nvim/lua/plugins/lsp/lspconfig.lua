return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lsp_utils = require("utils.lsp")
		local lsp_servers = require("utils.toolset").lsp

		local configs = require("lspconfig.configs")
		if not configs.just_lsp then
			configs.just_lsp = {
				default_config = {
					cmd = { "just-lsp" },
					filetypes = { "just" },
					root_dir = vim.fs.root(0, { "justfile", ".justfile", ".git" }),
				},
			}
		end

		lsp_utils.register_all(lsp_servers)
	end,
}
