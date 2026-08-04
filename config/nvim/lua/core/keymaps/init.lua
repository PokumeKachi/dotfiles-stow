require("core.keymaps.general")
require("core.keymaps.git")

require("core.keymaps.lsp")
require("core.keymaps.markdown")
require("core.keymaps.navigation")
require("core.keymaps.pickers")
require("core.keymaps.terminal")
require("core.keymaps.typst")
require("core.keymaps.ui")

local map = vim.keymap.set

local direction_map = {
    h = "left",
    j = "below",
    k = "above",
    l = "right",
}

local silent = {
	silent = true,
}
local Snacks = require("snacks")
local Picker = Snacks.picker
local Rename = Snacks.rename

local BlinkCmp = require("blink.cmp")
local Zk = require("zk")
local ZkApi = require("zk.api")
local Lsp = vim.lsp.buf

local function is_buf_in_other_win(buf)
	local current_win = vim.api.nvim_get_current_win()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if win ~= current_win and vim.api.nvim_win_get_buf(win) == buf then
			return true
		end
	end
	return false
end

local function split(split_direction, no_oil)
	local ft = vim.bo.filetype
	vim.api.nvim_open_win(0, true, { split = split_direction })
	if ft ~= "oil" and not no_oil then
		require("oil").open()
	end
end

-- local function get_visual_selection_txt()
-- 	local s = vim.fn.getpos("'<")
-- 	local e = vim.fn.getpos("'>")
-- 	if s[2] == 0 and e[2] == 0 then
-- 		return ""
-- 	end
--
-- 	-- ensure start <= end
-- 	if s[2] > e[2] or (s[2] == e[2] and (s[3] or 0) > (e[3] or 0)) then
-- 		s, e = e, s
-- 	end
--
-- 	local function clamp_pos(p)
-- 		p[2] = math.max(1, math.min(vim.api.nvim_buf_line_count(0), p[2]))
-- 		local ln = vim.fn.getline(p[2]) or ""
-- 		p[3] = math.max(1, math.min(#ln + 1, p[3] or 1))
-- 	end
-- 	clamp_pos(s)
-- 	clamp_pos(e)
--
-- 	local t = vim.fn.visualmode() or "v"
-- 	if t ~= "v" and t ~= "V" and t ~= string.char(22) then
-- 		t = "v"
-- 	end
--
-- 	if t == "V" then
-- 		local lines = vim.api.nvim_buf_get_lines(0, s[2] - 1, e[2], true)
-- 		return table.concat(lines, "\n")
-- 	elseif t == "v" then
-- 		local parts = vim.api.nvim_buf_get_text(0, s[2] - 1, s[3] - 1, e[2] - 1, e[3], {})
-- 		return table.concat(parts, "\n")
-- 	else -- blockwise
-- 		local cs = math.min(s[3], e[3]) - 1
-- 		local ce = math.max(s[3], e[3]) -- end is exclusive for nvim_buf_get_text
-- 		local out = {}
-- 		for ln = s[2] - 1, e[2] - 1 do
-- 			local line = vim.api.nvim_buf_get_lines(0, ln, ln + 1, true)[1] or ""
-- 			local maxc = #line
-- 			local a = math.max(0, math.min(maxc, cs))
-- 			local b = math.max(0, math.min(maxc, ce))
-- 			out[#out + 1] = (vim.api.nvim_buf_get_text(0, ln, a, ln, b, {})[1] or "")
-- 		end
-- 		return table.concat(out, "\n")
-- 	end
-- end

local function get_bufs()
	return vim.tbl_filter(function(b)
		local name = vim.api.nvim_buf_get_name(b)
		local buftype = vim.bo[b].buftype
		local filetype = vim.bo[b].filetype

		return vim.api.nvim_buf_is_loaded(b) and name ~= "" -- ignore unnamed buffers and buftype == "" -- skip special buffers (help, terminal, mininotify, etc.) and filetype ~= "mininotify" -- skip mininotify explicitly
	end, vim.api.nvim_list_bufs())
end

local function all_case_map(modes, keys, action, opts)
	local function case_combinations(str)
		if #str == 0 then
			return {
				"",
			}
		end
		local rest = case_combinations(str:sub(2))
		local c = str:sub(1, 1)
		local t = {}
		for _, r in ipairs(rest) do
			table.insert(t, c:lower() .. r)
			table.insert(t, c:upper() .. r)
		end
		return t
	end

	opts = opts or {
		noremap = true,
		silent = true,
	}

	if type(modes) ~= "table" then
		modes = {
			modes,
		}
	end
	-- map(modes, variant, action, opts)
	for _, mode in ipairs(modes) do
		for _, variant in ipairs(case_combinations(keys)) do
			vim.api.nvim_set_keymap(mode, variant, action, opts)
		end
	end
end

local function get_word_under_cursor()
	local col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	if not line then
		return ""
	end
	local s = col
	local e = col
	while s > 0 and line:sub(s, s):match("[%w_]") do
		s = s - 1
	end
	while e <= #line and line:sub(e + 1, e + 1):match("[%w_]") do
		e = e + 1
	end
	return line:sub(s + 1, e)
end

local function get_current_file()
	local cwd = vim.uv.cwd()

	if vim.bo.buftype == "terminal" or vim.bo.filetype == "oil" then
		return "."
	end

	local name = vim.api.nvim_buf_get_name(0)
	if name == "" then
		return "."
	end

	return vim.fn.fnamemodify(name, ":.")
end

local luasnip = require("luasnip")

vim.keymap.set({ "i" }, "<C-k>", function()
	luasnip.expand()
end, {
	silent = true,
})
vim.keymap.set({ "i", "s" }, "<C-l>", function()
	luasnip.jump(1)
end, {
	silent = true,
})
vim.keymap.set({ "i", "s" }, "<C-h>", function()
	luasnip.jump(-1)
end, {
	silent = true,
})
vim.keymap.set({ "i", "s" }, "<C-e>", function()
	if luasnip.choice_active() then
		luasnip.change_choice(1)
	end
end, {
	silent = true,
})

map("n", "<leader>w", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>", true, false, true), "m", true)
end, {
	noremap = true,
	silent = true,
	desc = "window operations",
})

for key, dir in pairs(direction_map) do
    map("n", "<C-w>n" .. key, function()
        split(dir)
    end, {
        noremap = true,
        desc = "split " .. dir,
        silent = true,
    })
end

map("n", "<C-w>m", function()
	require("winmove").start_mode("resize")
end, {
	noremap = true,
	desc = "winmove",
	silent = true,
})

-- map("n", "<C-w>v", function()
-- 	vim.api.nvim_open_win(0, true, { split = "right" })
--
-- 	if vim.bo.filetype ~= "oil" then
-- 		require("oil").open()
-- 	end
-- end, {
-- 	noremap = true,
-- 	desc = "vsplit",
-- 	silent = true,
-- })



map("n", "<leader>qq", ":quit<CR>", {
	silent = true,
	desc = "quit window",
})
map("n", "<leader>qa", ":qa<CR>", {
	silent = true,
	desc = "quit all windows",
})
map("n", "<leader>qo", ":only<CR>", {
	silent = true,
	desc = "quit other windows",
})

local function noAutoConfirmWrapper(fn)
	return function()
		fn({ auto_confirm = true })
	end
end

for key, fn, desc in ipairs({
    { "d", Picker.lsp_definitions, "definitions" },
    { "r", Picker.lsp_references, "references" },
    { "i", Picker.lsp_implementations, "implementations" },
    { "t", Picker.lsp_type_definitions, "type definitions" },
}) do
    map("n", "<leader>l" .. fn[1], noAutoConfirmWrapper(fn[2]), {
        desc = fn[3],
    })
end

map("n", "<leader>la", Lsp.code_action, {
	desc = "code actions",
})
map("n", "<leader>lh", Lsp.hover, {
	silent = true,
	desc = "view documentation",
})
map("n", "<leader>ln", Lsp.rename, {
	silent = true,
	desc = "rename symbol",
})

all_case_map({ "i" }, "jk", "<C-\\><C-n>", {
	noremap = true,
	silent = true,
})
-- all_case_map({ "i", "t" }, "jk", "<C-\\><C-n>", { noremap = true, silent = true })

map("n", "<Tab>", ":bnext<CR>", silent)
map("n", "<S-tab>", ":bprev<CR>", silent)
map("n", "<C-Tab>", "<C-^>", silent)

local dim = false

map("n", "<leader>ad", function()
	dim = not dim

	if dim then
		Snacks.dim.enable()
	else
		Snacks.dim.disable()
	end
end, {
	desc = "[appearance] dim",
})

map("n", "<leader>fr", function()
    Rename()
end, {
	desc = "[file] rename",
})

map("n", "<leader>fd", function()
	local file = vim.api.nvim_buf_get_name(0)
	if file ~= "" then
		local ok = vim.fn.confirm("Delete file?\n" .. file, "&Yes\n&No", 2)
		if ok == 1 then
			vim.fn.system({
				"trash-put",
				file,
			})
			Snacks.bufdelete()
		end
	end
end, {
	desc = "[f]ile delete",
	silent = true,
})

map(
	{
		"n",
		"v",
		"s",
		"o",
	},
	"<leader>bs",
	"ggVG",
	{
		desc = "[b]uffer select",
		silent = true,
	}
)

map("n", "<leader>bp", function()
	local ft = vim.bo.filetype

	if ft == "tex" then
		vim.cmd("VimtexCompile")
		return
	end

	if ft == "markdown" then
		-- local browser = os.getenv("BROWSER") or "firefox"
		-- os.execute(browser .. " --new-window")
		vim.cmd("Vivify")
		return
	end

	if ft ~= "typst" then
		return
	end

	local file = vim.fn.expand("%:p")
	local out = "/tmp/" .. vim.fn.expand("%:t:r") .. ".pdf"

	killTypstPreview()

	typstJob = vim.fn.jobstart({
		"typst",
		"watch",
		file,
		out,
	}, {
		stderr_buffered = false,
		on_stderr = function(_, data)
			if not data then
				return
			end

			local errors = {}
			local isError = false

			for _, line in ipairs(data) do
				table.insert(errors, line)
				if line:match("^error:") then
					isError = true
				end
			end

			if not isError then
				return
			end

			local tmp = "/tmp/typst_error.typ"
			local lines = {
				"= Compilation failed",
				"",
			}

			for _, line in ipairs(errors) do
				table.insert(lines, "=== `" .. line .. "`")
			end

			vim.fn.writefile(lines, tmp)
			vim.fn.system({
				"typst",
				"compile",
				tmp,
				out,
			})
		end,
	})

	zathuraJob = vim.fn.jobstart({
		"zathura",
		out,
	}, {
		detach = true,
	})
end, {
	silent = true,
	desc = "[b]uffer [p]review",
})

map({ "n", "v", "s", "o" }, "<leader>btr", ":RenderMarkdown buf_toggle<CR>", {
	desc = "[b]uffer [t]oggle [r]ender",
	silent = true,
})

map("n", "<leader>bqc", function()
	local bufs = get_bufs()
	local current_buf = vim.api.nvim_get_current_buf()

	local is_in_other_win = is_buf_in_other_win(current_buf)

	if is_in_other_win then
		require("oil").open()
		return
	end

	if #bufs == 1 and bufs[1] == current_buf then
		-- print("check here 2")
		require("oil").open()
		Snacks.bufdelete(current_buf)
	else
		-- print("check here")
		local idx
		for i, b in ipairs(bufs) do
			if b == current_buf then
				idx = i
				break
			end
		end

		Snacks.bufdelete(current_buf)
		--
		-- if not idx then
		-- 	return
		-- end

		-- local target = bufs[idx - 1] or bufs[idx + 1]
		--
		-- if target then
		-- 	vim.api.nvim_set_current_buf(target)
		-- end
	end
end, {
	silent = true,
	desc = "[b]uffer [q]uit [c]urrent",
})
map("n", "<leader>bqa", ":bufdo bd<CR>", {
	silent = true,
	desc = "[b]uffer [q]uit [a]ll",
})
map("n", "<leader>bqo", function()
	local bufs = get_bufs()

	for _, buf in ipairs(bufs) do
		if
			#vim.fn.win_findbuf(buf) == 0 and vim.bo[buf].buftype == ""
			-- and vim.bo[buf].modified == false
		then
			-- vim.cmd(string.format("confirm bd %d", buf))
			vim.api.nvim_buf_delete(buf, {
				force = false,
			})
		end
	end
end, {
	silent = true,
	desc = "[b]uffer [q]uit [o]thers",
})

map("i", "<C-w>", function()
	-- local wins = vim.api.nvim_tabpage_list_wins(0)
	-- local filtered_wins = {}
	-- for _, w in ipairs(wins) do
	-- 	local cfg = vim.api.nvim_win_get_config(w)
	-- 	local width = vim.api.nvim_win_get_width(w)
	-- 	local height = vim.api.nvim_win_get_height(w)
	-- 	if width > 2 and height > 2 then -- ignore tiny windows like scrollbars
	-- 		table.insert(filtered_wins, w)
	-- 	end
	-- end
	-- wins = filtered_wins
	-- local cur = vim.api.nvim_get_current_win()
	-- local next_win = wins[1]
	-- for i, w in ipairs(wins) do
	-- 	if w == cur then
	-- 		next_win = wins[i % #wins + 1]
	-- 		break
	-- 	end
	-- end
	-- vim.api.nvim_set_current_win(next_win)
	-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_config(win).relative ~= "" then
			vim.api.nvim_set_current_win(win)
		end
	end
end, {
	noremap = true,
	silent = true,
	desc = "window operations",
})

map("n", "<leader>ff", function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_config(win).relative ~= "" then
			vim.api.nvim_set_current_win(win)
		end
	end
end, {
	silent = true,
	desc = "focus floating window",
})

map("n", "<leader>fzq", function()
	Picker.qflist()
end, {
	desc = "quickfix",
})
map("n", "<leader>fzf", function()
	Picker.files()
end, {
	desc = "by file name",
})

map("n", "<leader>fzg", function()
	Picker.grep()
end, {
	desc = "by word",
})
map("n", "<leader>fm", function()
	require("conform").format({
		lsp_fallback = true,
		async = true,
	})
end, {
	silent = true,
	desc = "format code",
})

map("n", "<leader>bn", ":enew<CR>", {
	desc = "new buffer",
	silent = true,
})

-- map("n", ";", ":", { noremap = true })
-- map("n", "<leader>nm", function()
--   require("noice").cmd("last")
-- end, { desc = "noice: focus last message" })

map("n", "<C-d>", "<C-d>zz", {
	noremap = true,
	silent = true,
})
map("n", "<C-u>", "<C-u>zz", {
	noremap = true,
	silent = true,
})
map("n", "<esc>", "<cmd>nohlsearch<cr>", {
	noremap = true,
	silent = true,
})
-- map('n', 'jk', '<cmd>nohlsearch<cr>', { noremap = true, silent = true })

-- show diagnostics in a floating window under the cursor

map(
	{
		"n",
		"i",
		"v",
	},
	"<C-s>",
	function()
		vim.cmd("write")
	end,
	{
		desc = "Save file",
		silent = true,
	}
)

map("n", "<leader>zz", function()
	Snacks.zen.zen()
end, {
	desc = "zen mode",
	noremap = true,
	silent = true,
})

map("n", "<leader>zf", function()
	Snacks.zen.zoom()
end, {
	desc = "fullscreen (zoomed) mode",
	noremap = true,
	silent = true,
})

map("n", "<leader>zknn", ":ZkNew<CR>", {
	desc = "[z][k] [n]ew [n]ote",
	noremap = true,
	silent = true,
})

map("x", "zknn", ":ZkNewFromTitleSelection<CR>", {
	desc = "[z][k] [n]ew [n]ote",
	silent = true,
})

map("n", "<leader>zknl", function()
	ZkApi.index()
	vim.cmd("ZkInsertLink")
end, {
	desc = "[z][k] [n]ew [l]ink",
	noremap = true,
	silent = true,
})

map("x", "zknl", ":'<,'>ZkInsertLinkAtSelection<CR>", {
	desc = "[z][k] new link",
	silent = true,
})

local function pickNotes(param1, param2)
	Zk.pick_notes(param1 or {}, param2 or {}, function(selection)
		if not selection then
			return
		end

		for _, note in ipairs(selection) do
			local buf = vim.fn.bufadd(note.absPath)
			vim.fn.bufload(buf)
			vim.bo[buf].buflisted = true
			vim.api.nvim_open_win(buf, true, {
				split = "right",
			})
		end
	end)
end

map("n", "<leader>zkpn", function()
	Zk.index()
	pickNotes()
end, {
	desc = "[z][k] [p]icker - notes",
	noremap = true,
	silent = true,
})

map("n", "<leader>zkpt", function()
	Zk.index()
	Zk.pick_tags({}, {}, function(selection)
		if not selection then
			return
		end

		local tags = {}

		for _, tag in pairs(selection) do
			table.insert(tags, tag.name)
		end

		pickNotes({
			tags = tags,
		})
	end)
end, {
	desc = "[z][k] [p]icker - tags",
	noremap = true,
	silent = true,
})

map("n", "<leader>zkl", ":ZkLinks<CR>", {
	desc = "[z][k] [l]inks view",
	noremap = true,
	silent = true,
})

map("n", "<leader>zkb", ":ZkBacklinks<CR>", {
	desc = "[z][k] [back]links view",
	noremap = true,
	silent = true,
})

map("n", "<leader>da", Lsp.code_action, {
	desc = "Show code actions",
})
map("n", "<leader>df", vim.diagnostic.open_float, {
	desc = "Show floating errors",
	silent = true,
})
map("n", "<leader>dl", function()
	vim.diagnostic.setloclist()
end, {
	desc = "Show diagnostics in location list",
	silent = true,
})

-- map("n", "<leader>n", function()
-- 	if not vim.wo.number then
-- 		vim.wo.signcolumn = "yes"
-- 	else
-- 		vim.wo.signcolumn = "no"
-- 	end
--
-- 	vim.wo.number = not vim.wo.number
-- 	vim.wo.relativenumber = vim.wo.number
-- end, { desc = "line numbers" })

map("n", "<leader>rr", function()
	local keys = vim.api.nvim_replace_termcodes(":%s///gc<Left><Left><Left>", true, false, true)
	vim.api.nvim_feedkeys(keys, "t", false)
end, {
	desc = "(replace) search",
})

map({ "n", "x" }, "/", "/\\V", {
	noremap = true,
})
map("v", "/", "<Esc>/\\%V\\V", {
	desc = "search within visual selection",
})

map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", {
	desc = "Toggle Markdown Preview",
})
map({ "n", "v" }, "<leader>mp", function()
	require("nabla").popup()
end, {
	desc = "view latex",
})
map("n", "<leader>mt", "<cmd>Mtoc<CR>", {
	desc = "create table of contents",
})

for key, dir in pairs(direction_map) do
    map("n", "<leader>t" .. key, function()
        split(dir)
        vim.cmd.term()
    end, {
        desc = "terminal " .. dir,
        silent = true,
    })
end

map("n", "<leader>ts", "<cmd>split | term<CR>", {
	desc = "terminal (horizontal split)",
	noremap = true,
	silent = true,
})
map("n", "<leader>tv", "<cmd>vsplit | term<CR>", {
	desc = "terminal (vertical split)",
	noremap = true,
	silent = true,
})

map("n", "<leader>gd", function()
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
	desc = "toggle git diff",
	noremap = true,
	silent = true,
})

map("n", "<leader>gc", "<cmd>Git commit<CR>", {
	desc = "commit",
	silent = true,
})
map("n", "<leader>gu", function()
	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = vim.o.columns,
		height = vim.o.lines,
		row = 0,
		col = 0,
		style = "minimal",
		border = "none",
	})

	vim.cmd("term gitui")

	vim.wo[win].number = false
	vim.wo[win].relativenumber = false
	vim.wo[win].signcolumn = "no"
	vim.wo[win].winbar = ""
	vim.wo[win].statusline = ""
end, {
	desc = "gitui fullscreen",
})
map("n", "<leader>gp", "<cmd>Git push<CR>", {
	desc = "push",
	silent = true,
})
map("n", "<leader>gP", "<cmd>Git pull<CR>", {
	desc = "pull",
	silent = true,
})

map("n", "<leader>gs", function()
	require("gitsigns").stage_hunk()
end, {
	desc = "stage/unstage hunk",
})
map("v", "<leader>gs", function()
	require("gitsigns").stage_hunk({
		vim.fn.line("."),
		vim.fn.line("v"),
	})
end, {
	desc = "stage/unstage selected lines",
})
map("n", "<leader>gS", function()
	require("gitsigns").stage_buffer()
end, {
	desc = "stage entire file",
})

-- map("n", "<leader>o", "<cmd>Outline<CR>", { desc = "see outline", silent = true })
map("n", "<leader>o", function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local ft = vim.bo[buf].filetype
		if ft == "Outline" then
			if win == vim.api.nvim_get_current_win() then
				vim.cmd("Outline")
			else
				vim.api.nvim_set_current_win(win)
			end
			return
		end
	end
	vim.cmd("Outline")
end, {
	desc = "file outline",
	silent = true,
})

local function at_line_edge(is_left, cur, last, count)
	if last == 1 then
		return true
	end
	return (is_left and cur - count < 1) or (not is_left and cur + count >= last)
end

local function smart_move(key, edge_check, edge_cmd, move_cmd)
	map("n", key, function()
		local count = vim.v.count1
		local cur = vim.fn.col(".")
		local last = vim.fn.col("$")
		if edge_check(cur, last, count) then
			vim.cmd("normal! " .. edge_cmd)
		else
			vim.cmd(("normal! %d%s"):format(count, move_cmd))
		end
	end, {
		noremap = true,
	})
end

smart_move("h", function(cur, last, count)
	return at_line_edge(true, cur, last, count)
end, "k$", "h")
smart_move("l", function(cur, last, count)
	return at_line_edge(false, cur, last, count)
end, "j0", "l")
smart_move("<left>", function(cur, last, count)
	return at_line_edge(true, cur, last, count)
end, "k$", "h")
smart_move("<right>", function(cur, last, count)
	return at_line_edge(false, cur, last, count)
end, "j0", "l")

-- map({ "n", "v", "x", "s", "o" }, "H", "zh", { noremap = true })
-- map({ "n", "v", "x", "s", "o" }, "L", "zl", { noremap = true })
-- map({ "n", "v", "x", "s", "o" }, "J", "<C-e>", { noremap = true })
-- map({ "n", "v", "x", "s", "o" }, "K", "<C-y>", { noremap = true })

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0
		and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s")
			== nil
end

-- map({ "i" }, "<Tab>", function()
-- 	if BlinkCmp.is_visible() then
-- 		BlinkCmp.select_next()
-- 	elseif has_words_before() then
-- 		BlinkCmp.select_accept_and_enter()
-- 	end
-- end)
--
-- map({ "i" }, "<S-Tab>", function()
-- 	if BlinkCmp.is_visible() then
-- 		BlinkCmp.select_prev()
-- 	end
-- end)
--
-- map({ "i" }, "<CR>", function()
-- 	BlinkCmp.accept()
-- 	if BlinkCmp.is_visible() then
-- 		BlinkCmp.accept()
-- 		print("yea")
-- 	else
-- 		return "<CR>"
-- 	end
-- end, { expr = true })

map("n", "<F9>", function()
	require("dap").toggle_breakpoint()
end)


local typstJob
local zathuraJob

function killTypstPreview()
	if typstJob then
		vim.fn.jobstop(typstJob)
	end
	if zathuraJob then
		vim.fn.jobstop(zathuraJob)
	end
end

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = killTypstPreview,
})


map("n", "<leader>el", ":NoiceSnacks<CR>")
map("n", "<leader>ee", function()
    Snacks.explorer()
end)
