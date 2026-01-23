function mini_clue()
	-- local key_tree = {
	-- 	["<leader>"] = {
	-- 		l = {
	-- 			d = "go to definition",
	-- 			h = "view documentation",
	-- 			n = "rename",
	-- 			a = "view code actions",
	-- 			r = "go to references",
	-- 			i = "go to implementation",
	-- 			t = "go to type definition",
	-- 		},
	-- 	},
	-- }
	--
	-- local generated_clues = {}
	--
	-- local function build_clues(prefix, tbl)
	-- 	for k, v in pairs(tbl) do
	-- 		local new_prefix = prefix .. k
	-- 		if type(v) == "string" then
	-- 			table.insert(generated_clues, { mode = "n", keys = new_prefix, desc = v })
	-- 		elseif type(v) == "table" then
	-- 			-- for group, add a group label
	-- 			table.insert(generated_clues, { mode = "n", keys = new_prefix, desc = "+" .. k })
	-- 			build_clues(new_prefix, v)
	-- 		end
	-- 	end
	-- end
	--
	-- build_clues("", key_tree)
	--
	-- print(generated_clues)

	local miniclue = require("mini.clue")

	miniclue.setup({
		triggers = {
			{ mode = "n", keys = "<leader>" },
			{ mode = "x", keys = "<leader>" },

			{ mode = "i", keys = "<C-x>" },

			-- `g` key
			{ mode = "n", keys = "g" },
			{ mode = "x", keys = "g" },

			-- Maks
			{ mode = "n", keys = "'" },
			{ mode = "n", keys = "`" },
			{ mode = "x", keys = "'" },
			{ mode = "x", keys = "`" },

			-- Registes
			{ mode = "n", keys = '"' },
			{ mode = "x", keys = '"' },
			{ mode = "i", keys = "<C-r>" },

			{ mode = "c", keys = "<C-r>" },

			-- Window commands
			{ mode = "n", keys = "<C-w>" },

			-- `z` key
			{ mode = "n", keys = "z" },
			{ mode = "x", keys = "z" },
		},

		clues =
			-- vim.list_extend(
			{
				miniclue.gen_clues.builtin_completion(),
				miniclue.gen_clues.g(),
				miniclue.gen_clues.marks(),
				miniclue.gen_clues.registers(),
				miniclue.gen_clues.windows(),
				miniclue.gen_clues.z(),

				{ mode = "n", keys = "<leader>l", desc = "+lsp" },
			},
		-- , generated_clues),

		window = {
			delay = 0,
			config = { width = "auto" },
		},
	})
end

return {
	"nvim-mini/mini.nvim",
	version = "*",
	config = function()
		local hues = require("mini.hues")

		local hues_palette = {
			foreground = "#f6d0f5",
			-- background = "#202426",
			-- foreground = "#ffdfb0",
			-- background = "#303436";
			-- foreground = "#ffffff",
			background = "#202426",
			n_hues = 8,
			-- saturation = 'mediumhigh',
			saturation = "high",
			--One of: 'bg', 'fg', 'red', 'orange', 'yellow', 'green',
			-- 'cyan', 'azure', 'blue', 'purple'
			accent = "azure",
		}

		hues._palette = hues_palette

		require("mini.ai").setup({
			-- Table with textobject id as fields, textobject specification as values.
			-- Also use this to disable builtin textobjects. See |MiniAi.config|.
			custom_textobjects = nil,

			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				-- Main textobject prefixes
				around = "a",
				inside = "i",

				-- Next/last variants
				-- NOTE: These override built-in LSP selection mappings on Neovim>=0.12
				-- Map LSP selection manually to use it (see `:h MiniAi.config`)
				around_next = "an",
				inside_next = "in",
				around_last = "al",
				inside_last = "il",

				-- Move cursor to corresponding edge of `a` textobject
				goto_left = "g[",
				goto_right = "g]",
			},

			-- Number of lines within which textobject is searched
			n_lines = 200,

			-- How to search for object (first inside current line, then inside
			-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
			-- 'cover_or_nearest', 'next', 'previous', 'nearest'.
			search_method = "cover_or_nearest",

			-- Whether to disable showing non-error feedback
			-- This also affects (purely informational) helper messages shown after
			-- idle time if user input is required.
			silent = false,
		})

		mini_clue()

		require("mini.surround").setup({
			search_method = "cover_or_nearest",
			n_lines = 20,
		})
		require("mini.pairs").setup({
			-- In which modes mappings from this `config` should be created
			modes = { insert = true, command = false, terminal = false },

			-- Global mappings. Each right hand side should be a pair information, a
			-- table with at least these fields (see more in |MiniPairs.map|):
			-- - <action> - one of 'open', 'close', 'closeopen'.
			-- - <pair> - two character string for pair to be used.
			-- By default pair is not inserted after `\`, quotes are not recognized by
			-- <CR>, `'` does not insert pair after a letter.
			-- Only parts of tables can be tweaked (others will use these defaults).
			mappings = {
				["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
				["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
				["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },
				-- ['<'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].' },

				[")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
				["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
				["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
				[">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },

				['"'] = { action = "open", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
				["'"] = { action = "open", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
				["`"] = { action = "open", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
			},
		})

		require("mini.animate").setup({
			scroll = { enable = false }, -- this shit breaks mouse scrolling
			resize = { enable = false },
			cursor = { enable = true },
			open = { enable = false },
			close = { enable = false },
		})

		-- local cat = require("catppuccin.palettes").get_palette("mocha")
		--
		-- require("mini.colors").make_scheme("catppuccin_mocha", {
		-- 	Normal = { fg = cat.text, bg = cat.base },
		-- 	Comment = { fg = cat.overlay1 },
		-- 	String = { fg = cat.green },
		-- 	Function = { fg = cat.blue },
		-- })
		-- require("mini.colors").apply_scheme("catppuccin_mocha")

		require("mini.colors").setup()
		-- require("mini.hues").setup(hues._palette)
		require("mini.cursorword").setup()
		-- require("mini.cmdline").setup({
		-- 	autocomplete = {
		-- 		enable = false,
		--
		-- 		-- Delay (in ms) after which to trigger completion
		-- 		-- Neovim>=0.12 is recommended for positive values
		-- 		delay = 0,
		--
		-- 		-- Custom rule of when to trigger completion
		-- 		predicate = nil,
		--
		-- 		-- Whether to map arrow keys for more consistent wildmenu behavior
		-- 		map_arrows = true,
		-- 	},
		--
		-- 	-- Autocorrection: adjust non-existing words (commands, options, etc.)
		-- 	autocorrect = {
		-- 		enable = true,
		--
		-- 		-- Custom autocorrection rule
		-- 		func = nil,
		-- 	},
		--
		-- 	-- Autopeek: show command's target range in a floating window
		-- 	autopeek = {
		-- 		enable = true,
		--
		-- 		-- Number of lines to show above and below range lines
		-- 		n_context = 1,
		--
		-- 		-- Custom rule of when to show peek window
		-- 		predicate = nil,
		--
		-- 		-- Window options
		-- 		window = {
		-- 			-- Floating window config
		-- 			config = {},
		--
		-- 			-- Function to render statuscolumn
		-- 			statuscolumn = nil,
		-- 		},
		-- 	},
		-- })
		require("mini.hipatterns").setup()
		require("mini.icons").setup()
		require("mini.indentscope").setup()
		-- require("mini.map").setup()
		-- require('mini.map').open()
		require("mini.notify").setup({
			content = {
				-- Function which formats the notification message
				-- By default prepends message with notification time
				format = nil,

				-- Function which orders notification array from most to least important
				-- By default orders first by level and then by update timestamp
				sort = nil,
			},
			lsp_progress = { enable = false },
			window = {
				-- Floating window config
				config = {},

				-- Maximum window width as share (between 0 and 1) of available columns
				max_width_share = 0.382,

				-- Value of 'winblend' option
				winblend = 25,
			},
		})
		-- require("mini.starter").setup()

		require("mini.statusline").setup({
			use_icons = vim.g.have_nerd_font,
			content = {
				inactive = function()
					local buf = vim.api.nvim_get_current_buf()
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")
					return MiniStatusline.combine_groups({
						{ hl = "Comment", strings = { filename or "" } }, -- dim gray
						{ hl = "Comment", strings = { " %=" } }, -- keep alignment
					})
				end,
				active = function()
					local buf = vim.api.nvim_get_current_buf()

					local check_macro_recording = function()
						if vim.fn.reg_recording() ~= "" then
							return "Recording @" .. vim.fn.reg_recording()
						else
							return ""
						end
					end

					local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
					local git = MiniStatusline.section_git({ trunc_width = 40 })
					local diff = MiniStatusline.section_diff({ trunc_width = 75 })
					local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
					local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
					-- local filename = MiniStatusline.section_filename({ trunc_width = 140 })
					-- local filename = MiniStatusline.section_filename({ trunc_width = 140, modifiers = ":." })
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")
					local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
					local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
					local macro = check_macro_recording()
					local location_raw = MiniStatusline.section_location({ trunc_width = 200 })

					local line = vim.fn.line(".")
					local total_lines = vim.fn.line("$")
					local col = vim.fn.col(".")
					local scroll_percent = math.floor(line / total_lines * 100)

					-- combine like: "123|45 (42%)"
					local location = string.format("%s (%d%%%%)", location_raw, scroll_percent)

					return MiniStatusline.combine_groups({
						{ hl = mode_hl, strings = { mode } },
						{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
						"%<", -- Mark general truncate point
						{ hl = "MiniStatuslineFilename", strings = { filename, lsp } },
						"%=", -- End left alignment
						{ hl = "MiniStatuslineFilename", strings = { macro } },
						{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
						{ hl = mode_hl, strings = { search, location } },
					})
				end,
			},
		})
		require("mini.tabline").setup({
			tabpage_section = "left",
		})
		require("mini.trailspace").setup()
	end,
}
