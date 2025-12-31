return {
	"stevearc/oil.nvim",
	-- lazy = false,
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
			signcolumn = "yes",
			cursorcolumn = true,
			foldcolumn = "0",
			spell = false,
			list = false,
			conceallevel = 3,
			concealcursor = "nvic",
		},
		view_options = { show_hidden = true, show_parent_dir = false },
	},
	delete_to_trash = true,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = { { "-", "<cmd>Oil<cr>", desc = "oil" } },
}
