-- Table of contents generation for Markdown

local map = require("utils.keymap").lazy_map

return {
	"hedyhli/markdown-toc.nvim",
	ft = "markdown", -- Lazy load on markdown filetype
	cmd = { "Mtoc" }, -- Or, lazy load on "Mtoc" command
	opts = {},
	keys = {
		map("n", "<leader>mt", "<cmd>Mtoc<CR>", {
			desc = "Create Table of Contents",
		}),
	},
}
