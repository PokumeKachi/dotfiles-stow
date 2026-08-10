local map = require("utils.keymap").lazy_map

return {
	"lewis6991/gitsigns.nvim",
	event = "BufReadPost",
	opts = {
		signs = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signs_staged = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signs_staged_enable = true,
		signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
		numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
		linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
		word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
		watch_gitdir = {
			follow_files = true,
		},
		auto_attach = true,
		attach_to_untracked = false,
		current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
			delay = 1000,
			ignore_whitespace = false,
			virt_text_priority = 100,
			use_focus = true,
		},
		current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil, -- Use default
		max_file_length = 40000, -- Disable if file is longer than this (in lines)
		preview_config = {
			-- Options passed to nvim_open_win
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
	},
	keys = {
		map("n", "<leader>gu", function()
			for _, cmd in ipairs({
				"toggle_signs",
				"toggle_linehl",
				"toggle_numhl",
				"toggle_current_line_blame",
				"toggle_deleted",
				"toggle_word_diff",
			}) do
				vim.cmd("Gitsigns " .. cmd)
			end
		end, {
			desc = "Toggle Git UI Decorations",
		}),
		map("n", "<leader>gs", function()
			require("gitsigns").stage_hunk()
		end, {
			desc = "Git (Un)stage Hunk",
		}),
		map("v", "<leader>gs", function()
			require("gitsigns").stage_hunk({
				vim.fn.line("."),
				vim.fn.line("v"),
			})
		end, {
			desc = "Git (Un)stage Selected Lines",
		}),
		map("n", "<leader>gS", function()
			require("gitsigns").stage_buffer()
		end, {
			desc = "Git Stage Entire Buffer",
		}),
	},
}
