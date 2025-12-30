local function hex(c)
	return string.format("#%06x", c)
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
			local mode = vim.fn.mode()
			local cur = vim.api.nvim_win_get_cursor(win)[1]
			local total = math.max(1, vim.api.nvim_buf_line_count(buf))
			local pct = math.floor(cur / total * 100 + 0.5)
			local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")
			local rec = vim.fn.reg_recording()
			local rec_indicator = rec ~= "" and (" REC@" .. rec) or ""
			local ft = vim.bo[buf].filetype or "?"
			local flags = (vim.bo[buf].modified and "" or "") .. (vim.bo[buf].readonly and "" or "")

			-- gather highlights once
			local want = { "Cursor", "DiffChange", "DiffAdd", "DiffDelete", "IncSearch", "Normal", "StatusLine" }
			local hls = {}
			for _, n in ipairs(want) do
				local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = n })
				if ok and hl then
					hls[n] = {
						fg = hl.fg and string.format("#%06x", hl.fg) or nil,
						bg = hl.bg and string.format("#%06x", hl.bg) or nil,
					}
				end
			end

			-- tasteful fallback palette (harmonious, good contrast)
			local palette = {
				n = "#2e3440", -- neutral slate
				i = "#2aa198", -- teal (edit)
				v = "#5e81ac", -- blue (visual)
				R = "#bf616a", -- warm red (replace)
				c = "#b48ead", -- mauve (command)
				t = "#d08770", -- orange (terminal)
				default = "#3b4252",
			}

			local mode_map =
				{ n = "Cursor", i = "DiffChange", v = "DiffAdd", R = "DiffDelete", c = "IncSearch", t = "IncSearch" }
			local chosen_hl = hls[mode_map[mode] or "IncSearch"] or hls["StatusLine"] or hls["Normal"]

			local function hex_to_rgb(h)
				if not h then
					return nil
				end
				h = h:gsub("#", "")
				return tonumber(h:sub(1, 2), 16), tonumber(h:sub(3, 4), 16), tonumber(h:sub(5, 6), 16)
			end
			local function rgb_to_hex(r, g, b)
				return string.format("#%02x%02x%02x", r, g, b)
			end

			-- gentle saturation/lightness boost (fast)
			local function boost(hex)
				local r, g, b = hex_to_rgb(hex)
				if not r then
					return hex
				end
				r, g, b = r / 255, g / 255, b / 255
				local mx, mn = math.max(r, g, b), math.min(r, g, b)
				local l = (mx + mn) / 2
				local s = (mx == mn) and 0 or (mx - mn) / (1 - math.abs(2 * l - 1))
				s = math.min(1, s * 1.22 + 0.04)
				l = math.max(0.08, math.min(0.92, l * 0.96 + 0.03))
				-- cheap tweak: nudge channels proportional to saturation
				local rr = math.floor(math.min(255, (r * (1 + s) + 0.02) * 255 + 0.5))
				local gg = math.floor(math.min(255, (g * (1 + s) + 0.02) * 255 + 0.5))
				local bb = math.floor(math.min(255, (b * (1 + s) + 0.02) * 255 + 0.5))
				return rgb_to_hex(rr, gg, bb)
			end

			local function lumin(hex)
				local r, g, b = hex_to_rgb(hex)
				if not r then
					return 0
				end
				local function comp(c)
					c = c / 255
					if c <= 0.03928 then
						return c / 12.92
					end
					return ((c + 0.055) / 1.055) ^ 2.4
				end
				return 0.2126 * comp(r) + 0.7152 * comp(g) + 0.0722 * comp(b)
			end
			local function best_text(bg)
				if not bg then
					return "#ffffff"
				end
				local l = lumin(bg)
				return (1.05 / (l + 0.05)) >= ((l + 0.05) / 0.05) and "#ffffff" or "#000000"
			end

			local base = (chosen_hl and (chosen_hl.bg or chosen_hl.fg)) or palette[mode] or palette.default
			local pop_bg = boost(base)
			local pop_fg = best_text(pop_bg)
			local normal = hls["Directory"] or { fg = "#d0d0d0", bg = "#1a1a1a" }

			-- compose with elegant separator
			local sep = "#"
			local parts = {}

			table.insert(parts, { " " .. mode .. " ", guifg = pop_fg, guibg = pop_bg })
			table.insert(parts, {
				" " .. sep .. " " .. name .. (flags ~= "" and " " .. flags or "") .. " [" .. ft .. "] " .. rec_indicator .. " ",
				guifg = normal.fg,
				guibg = normal.bg,
			})
			table.insert(parts, {
				" " .. sep .. " " .. cur .. "/" .. total .. " (" .. pct .. "%)",
				guifg = pop_fg,
				guibg = pop_bg,
				-- guifg = normal.fg,
				-- guibg = normal.bg,
			})

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
