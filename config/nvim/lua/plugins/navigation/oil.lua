local map = require("utils.keymap").lazy_map

function _G.get_oil_winbar()
	local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
	local dir = require("oil").get_current_dir(bufnr)
	if dir then
		return vim.fn.fnamemodify(dir, ":~")
	else
		-- If there is no current directory (e.g. over ssh), just show the buffer name
		return vim.api.nvim_buf_get_name(0)
	end
end

return {
	"stevearc/oil.nvim",
	-- lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		default_file_explorer = true,
		columns = {
			-- "mtime",
			-- "size",
			-- "permissions",
			"icon",
		},
		buf_options = {
			buflisted = true,
			bufhidden = "hide",
		},
		win_options = {
			wrap = true,
			signcolumn = "yes:2",
			cursorcolumn = true,
			foldcolumn = "0",
			spell = false,
			list = false,
			conceallevel = 3,
			concealcursor = "nvic",
			winbar = "%!v:lua.get_oil_winbar()",
		},
		view_options = { show_hidden = false, show_parent_dir = false },
		delete_to_trash = true,
		lsp_file_methods = {
			-- Enable or disable LSP file operations
			enabled = false,
			-- Time to wait for LSP file operations to complete before skipping
			timeout_ms = 1000,
			-- Set to true to autosave buffers that are updated with LSP willRenameFiles
			-- Set to "unmodified" to only save unmodified buffers
			autosave_changes = false,
		},
	},
	keys = {
		map("n", "-", "<cmd>Oil<cr>", {
			desc = "Open Oil",
		}),
	},
}
