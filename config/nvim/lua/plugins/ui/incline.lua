-- Floating statusline, particularly annoying when it hides the actual content!

local function hex(c)
	return string.format("#%06x", c)
end

local function get_hl_attrs(group, defaults)
	defaults = defaults or {}
	local ok, attrs = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
	if not ok or not attrs then
		return defaults
	end

	return vim.tbl_extend("force", defaults, attrs)
end

return {
	"b0o/incline.nvim",
	opts = {
		debounce_threshold = {
			falling = 30,
			rising = 10,
		},
		hide = {
			cursorline = "smart",
			focused_win = false,
			only_win = false,
		},
		highlight = {
			groups = {
				InclineNormal = {
					default = true,
					group = "NormalFloat",
				},
				InclineNormalNC = {
					default = true,
					group = "NormalFloat",
				},
			},
		},
		ignore = {
			buftypes = "special",
			filetypes = {},
			floating_wins = true,
			unlisted_buffers = true,
			wintypes = "special",
		},

		render = function(props)
			local buf, win = props.buf, props.win

			-- 1. Gather dynamic data
			local mode = vim.fn.mode()
			local cur = vim.api.nvim_win_get_cursor(win)[1]
			local total = math.max(1, vim.api.nvim_buf_line_count(buf))
			local pct = math.floor(cur / total * 100 + 0.5)
			local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")
			local rec = vim.fn.reg_recording()
			local rec_indicator = rec ~= "" and (" REC@" .. rec) or ""
			local ft = vim.bo[buf].filetype or "?"
			local flags = (vim.bo[buf].modified and "" or "")
				.. (vim.bo[buf].readonly and "" or "")

			-- 2. Safely get highlight groups
			local normal = get_hl_attrs("NormalFloat", { fg = 0xcccccc, bg = 0x1a1a1a })
			local title = get_hl_attrs("Title", { fg = 0xffff00, bg = normal.bg })
			local title_bg = title.bg or normal.bg

			-- 3. Build the statusline as a list of items.
			--    Each item is either a string or a table with the string as its first element
			--    followed by highlight attributes.
			local parts = {}

			-- Mode indicator (bold, using Title colours)
			parts[#parts + 1] = {
				" " .. mode .. " ",
				guifg = hex(title.fg),
				guibg = hex(title_bg),
				gui = "bold",
			}

			-- Main part: name, flags, filetype, recording indicator
			local main_text = " │ " .. name
			if flags ~= "" then
				main_text = main_text .. " " .. flags
			end
			main_text = main_text .. " [" .. ft .. "]" .. rec_indicator .. " "

			parts[#parts + 1] = {
				main_text,
				guifg = hex(normal.fg),
				guibg = hex(normal.bg),
			}

			-- Percentage (line number / total)
			parts[#parts + 1] = {
				(" │ %d/%d (%d%%)"):format(cur, total, pct),
				guifg = hex(normal.fg),
				guibg = hex(normal.bg),
			}

			return parts
		end,

		window = {
			margin = {
				horizontal = 1,
				vertical = 1,
			},
			options = {
				signcolumn = "no",
				wrap = false,
			},
			overlap = {
				borders = true,
				statusline = false,
				tabline = false,
				winbar = false,
			},
			padding = 1,
			padding_char = " ",
			placement = {
				horizontal = "right",
				vertical = "top",
			},
			width = "fit",
			winhighlight = {
				active = {
					EndOfBuffer = "None",
					Normal = "InclineNormal",
					Search = "None",
				},
				inactive = {
					EndOfBuffer = "None",
					Normal = "InclineNormalNC",
					Search = "None",
				},
			},
			zindex = 50,
		},
	},
	event = "VeryLazy",
}
