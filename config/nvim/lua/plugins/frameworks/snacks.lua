-- A bunch of plugins...

local map = require("utils.keymap").lazy_map
local file = require("utils.file")

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- animate = {enabled = true},
		bigfile = { enabled = true },
		-- bufdelete = { enabled = true },
		-- dashboard = { enabled = true },
		debug = { enabled = true },
		dim = { enabled = true },
		explorer = { enabled = true },
		gh = { enabled = true },
		git = { enabled = true },
		gitbrowse = { enabled = true },
		image = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		keymap = { enabled = true },
		layout = { enabled = true },
		-- lazygit = { enabled = true },
		-- notifier = { enabled = true },
		notify = { enabled = true },
		picker = {
			enabled = true,
			layout = { preset = "ivy" }, -- default, vertical, ivy, vscode
		},
		profiler = { enabled = true },
		quickfile = { enabled = true },
		rename = { enabled = true },
		scope = { enabled = true },
		-- scroll = { enabled = true },
		statuscolumn = { enabled = true },
		terminal = { enabled = true },
		toggle = { enabled = true },
		util = { enabled = true },
		win = { enabled = true },
		words = { enabled = true },
		zen = { enabled = true },
	},
	keys = {
		map("n", "<leader><space>", function()
			Snacks.picker.smart()
		end, { desc = "Smart Find Files" }),
		map("n", "<leader>nh", function()
			Snacks.notifier.show_history()
		end, { desc = "Notification History" }),
		map("n", "<leader>e", function()
			local explorers = Snacks.picker.get({ source = "explorer" })
			if explorers and #explorers > 0 then
				explorers[1]:focus()
			else
				Snacks.explorer()
			end
		end, { desc = "Toggle Explorer" }),
		-- find
		map("n", "<leader>fb", function()
			Snacks.picker.buffers()
		end, { desc = "Find Buffers" }),
		map("n", "<leader>ff", function()
			Snacks.picker.files()
		end, { desc = "Find Files" }),
		map("n", "<leader>fg", function()
			Snacks.picker.git_files()
		end, { desc = "Find Git Files" }),
		map("n", "<leader>fp", function()
			Snacks.picker.projects()
		end, { desc = "Find Projects" }),
		map("n", "<leader>fr", function()
			Snacks.picker.recent()
		end, { desc = "Find Recent Files" }),
		-- git
		map("n", "<leader>gb", function()
			Snacks.picker.git_branches()
		end, { desc = "Git Branches" }),
		map("n", "<leader>gl", function()
			Snacks.picker.git_log()
		end, { desc = "Git Log" }),
		map("n", "<leader>gL", function()
			Snacks.picker.git_log_line()
		end, { desc = "Git Log Line" }),
		map("n", "<leader>gs", function()
			Snacks.picker.git_status()
		end, { desc = "Git Status" }),
		map("n", "<leader>gS", function()
			Snacks.picker.git_stash()
		end, { desc = "Git Stash" }),
		map("n", "<leader>gd", function()
			Snacks.picker.git_diff()
		end, { desc = "Git Diff (Hunks)" }),
		map("n", "<leader>gf", function()
			Snacks.picker.git_log_file()
		end, { desc = "Git Log File" }),
		-- gh
		map("n", "<leader>gi", function()
			Snacks.picker.gh_issue()
		end, { desc = "GitHub Issues (open)" }),
		map("n", "<leader>gI", function()
			Snacks.picker.gh_issue({ state = "all" })
		end, { desc = "GitHub Issues (all)" }),
		map("n", "<leader>gp", function()
			Snacks.picker.gh_pr()
		end, { desc = "GitHub Pull Requests (open)" }),
		map("n", "<leader>gP", function()
			Snacks.picker.gh_pr({ state = "all" })
		end, { desc = "GitHub Pull Requests (all)" }),
		-- Grep
		map("n", "<leader>sb", function()
			Snacks.picker.lines()
		end, { desc = "Buffer Lines" }),
		map("n", "<leader>sB", function()
			Snacks.picker.grep_buffers()
		end, { desc = "Grep Open Buffers" }),
		map("n", "<leader>sg", function()
			Snacks.picker.grep()
		end, { desc = "Grep" }),
		map({ "n", "x" }, "<leader>sw", function()
			Snacks.picker.grep_word()
		end, { desc = "Visual selection or word" }),
		-- search
		map("n", '<leader>s"', function()
			Snacks.picker.registers()
		end, { desc = "Registers" }),
		map("n", "<leader>s/", function()
			Snacks.picker.search_history()
		end, { desc = "Search History" }),
		map("n", "<leader>sa", function()
			Snacks.picker.autocmds()
		end, { desc = "Autocmds" }),
		map("n", "<leader>sc", function()
			Snacks.picker.command_history()
		end, { desc = "Command History" }),
		map("n", "<leader>sC", function()
			Snacks.picker.commands()
		end, { desc = "Commands" }),
		map("n", "<leader>sd", function()
			Snacks.picker.diagnostics()
		end, { desc = "Diagnostics" }),
		map("n", "<leader>sD", function()
			Snacks.picker.diagnostics_buffer()
		end, { desc = "Buffer Diagnostics" }),
		map("n", "<leader>sh", function()
			Snacks.picker.help()
		end, { desc = "Help Pages" }),
		map("n", "<leader>sH", function()
			Snacks.picker.highlights()
		end, { desc = "Highlights" }),
		map("n", "<leader>si", function()
			Snacks.picker.icons()
		end, { desc = "Icons" }),
		map("n", "<leader>sj", function()
			Snacks.picker.jumps()
		end, { desc = "Jumps" }),
		map("n", "<leader>sk", function()
			Snacks.picker.keymaps()
		end, { desc = "Keymaps" }),
		map("n", "<leader>sl", function()
			Snacks.picker.loclist()
		end, { desc = "Location List" }),
		map("n", "<leader>sm", function()
			Snacks.picker.marks()
		end, { desc = "Marks" }),
		map("n", "<leader>sM", function()
			Snacks.picker.man()
		end, { desc = "Man Pages" }),
		map("n", "<leader>sp", function()
			Snacks.picker.lazy()
		end, { desc = "Search for Plugin Spec" }),
		map("n", "<leader>sq", function()
			Snacks.picker.qflist()
		end, { desc = "Quickfix List" }),
		map("n", "<leader>sR", function()
			Snacks.picker.resume()
		end, { desc = "Resume" }),
		map("n", "<leader>su", function()
			Snacks.picker.undo()
		end, { desc = "Undo History" }),
		map("n", "<leader>uC", function()
			Snacks.picker.colorschemes()
		end, { desc = "Colorschemes" }),
		-- LSP
		map("n", "gd", function()
			Snacks.picker.lsp_definitions()
		end, { desc = "Goto Definition" }),
		map("n", "gD", function()
			Snacks.picker.lsp_declarations()
		end, { desc = "Goto Declaration" }),
		map("n", "gr", function()
			Snacks.picker.lsp_references()
		end, { nowait = true, desc = "References" }),
		map("n", "gI", function()
			Snacks.picker.lsp_implementations()
		end, { desc = "Goto Implementation" }),
		map("n", "gy", function()
			Snacks.picker.lsp_type_definitions()
		end, { desc = "Goto T[y]pe Definition" }),
		map("n", "gai", function()
			Snacks.picker.lsp_incoming_calls()
		end, { desc = "C[a]lls Incoming" }),
		map("n", "gao", function()
			Snacks.picker.lsp_outgoing_calls()
		end, { desc = "C[a]lls Outgoing" }),
		map("n", "<leader>ss", function()
			Snacks.picker.lsp_symbols()
		end, { desc = "LSP Symbols" }),
		map("n", "<leader>sS", function()
			Snacks.picker.lsp_workspace_symbols()
		end, { desc = "LSP Workspace Symbols" }),
		-- Other
		map("n", "<leader>zz", function()
			Snacks.zen()
		end, { desc = "Toggle Zen Mode" }),
		map("n", "<leader>zZ", function()
			Snacks.zen.zoom()
		end, { desc = "Toggle Zoom (Fullscreen) Mode" }),
		map("n", "<leader>.", function()
			Snacks.scratch()
		end, { desc = "Toggle Scratch Buffer" }),
		map("n", "<leader>S", function()
			Snacks.scratch.select()
		end, { desc = "Select Scratch Buffer" }),
		map("n", "<leader>cR", function()
			Snacks.rename.rename_file()
		end, { desc = "Rename File" }),
		map({ "n", "v" }, "<leader>gB", function()
			Snacks.gitbrowse()
		end, { desc = "Open On GitHub (Browser)" }),
		map("n", "<leader>gg", function()
			Snacks.lazygit()
		end, { desc = "Lazygit" }),
		map("n", "<leader>un", function()
			Snacks.notifier.hide()
		end, { desc = "Dismiss All Notifications" }),
		map({ "n", "t" }, "]]", function()
			Snacks.words.jump(vim.v.count1)
		end, { desc = "Next Reference" }),
		map({ "n", "t" }, "[[", function()
			Snacks.words.jump(-vim.v.count1)
		end, { desc = "Prev Reference" }),
		-- Custom Just mappings
		map("n", "<F5>", function()
			Snacks.terminal({ "just", "--choose", "--", file.get_current() })
		end, { desc = "Open Just" }),
		map("n", "<F6>", function()
			Snacks.terminal({ "just", "run" })
		end, { desc = "Execute just run" }),
		-- Neovim News
		map("n", "<leader>N", function()
			Snacks.win({
				file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
				width = 0.6,
				height = 0.6,
				wo = {
					spell = false,
					wrap = false,
					signcolumn = "yes",
					statuscolumn = " ",
					conceallevel = 3,
				},
			})
		end, { desc = "Neovim News" }),
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Setup some globals for debugging (lazy-loaded)
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end

				-- Override print to use snacks for `:=` command
				if vim.fn.has("nvim-0.11") == 1 then
					vim._print = function(_, ...)
						dd(...)
					end
				else
					vim.print = _G.dd
				end

				-- Create some toggle mappings
				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
				Snacks.toggle
					.option("relativenumber", { name = "Relative Number" })
					:map("<leader>uL")
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.line_number():map("<leader>ul")
				Snacks.toggle
					.option(
						"conceallevel",
						{ off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }
					)
					:map("<leader>uc")
				Snacks.toggle.treesitter():map("<leader>uT")
				Snacks.toggle
					.option("background", { off = "light", on = "dark", name = "Dark Background" })
					:map("<leader>ub")
				Snacks.toggle.inlay_hints():map("<leader>uh")
				Snacks.toggle.indent():map("<leader>ug")
				Snacks.toggle.dim():map("<leader>uD")
			end,
		})
	end,
}
