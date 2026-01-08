local map = vim.keymap.set
-- local map = require("nvim-mapper").map_keymap

local silent = {
	silent = true,
}

local snacks = require("snacks")
local blink_cmp = require("blink.cmp")
local lsp = vim.lsp.buf

local function is_buf_in_other_win(buf)
	local current_win = vim.api.nvim_get_current_win()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if win ~= current_win and vim.api.nvim_win_get_buf(win) == buf then
			return true
		end
	end
	return false
end

local function get_bufs()
	return vim.tbl_filter(function(b)
		local name = vim.api.nvim_buf_get_name(b)
		local buftype = vim.bo[b].buftype
		local filetype = vim.bo[b].filetype

		return vim.api.nvim_buf_is_loaded(b)
			and name ~= "" -- ignore unnamed buffers
			and buftype == "" -- skip special buffers (help, terminal, mininotify, etc.)
			and filetype ~= "mininotify" -- skip mininotify explicitly
	end, vim.api.nvim_list_bufs())
end

local function all_case_map(modes, keys, action, opts)
	local function case_combinations(str)
		if #str == 0 then
			return { "" }
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

	opts = opts or { noremap = true, silent = true }

	if type(modes) ~= "table" then
		modes = { modes }
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

map("n", "<leader>w", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>", true, false, true), "m", true)
end, { noremap = true, silent = true, desc = "window operations" })

map("n", "<leader>ld", lsp.definition, { silent = true, desc = "go to definition" })
map("n", "<leader>lh", lsp.hover, { silent = true, desc = "view documentation" })
map("n", "<leader>ln", lsp.rename, { silent = true, desc = "rename symbol" })
map("n", "<leader>la", lsp.code_action, { silent = true, desc = "code actions" })
map("n", "<leader>lr", lsp.references, { silent = true, desc = "find references" })
map("n", "<leader>li", lsp.implementation, { silent = true, desc = "go to implementation" })
map("n", "<leader>lt", lsp.type_definition, { silent = true, desc = "go to type definition" })

-- map("i", "jk", "<Esc>", { noremap = true })
-- map("i", "jK", "<Esc>", { noremap = true })
-- map("i", "Jk", "<Esc>", { noremap = true })
-- map("i", "JK", "<Esc>", { noremap = true })
all_case_map({ "i" }, "jk", "<C-\\><C-n>", { noremap = true, silent = true })
-- all_case_map({ "t", "i" }, "jk", "<C-\\><C-n>", { noremap = true, silent = true })

map("n", "<Tab>", ":bnext<CR>", silent)
map("n", "<S-tab>", ":bprev<CR>", silent)
map("n", "<C-Tab>", "<C-^>", silent)

map("n", "<leader>ca", ":bufdo bd<CR>", { silent = true, desc = "close all buffers" })
map("n", "<leader>cc", function()
	local bufs = get_bufs()
	local current_buf = vim.api.nvim_get_current_buf()
	local is_in_other_win = is_buf_in_other_win(current_buf)

	if is_in_other_win then
		require("oil").open()
		return
	end

	if #bufs == 1 and bufs[1] == current_buf then
		require("oil").open()
		-- vim.cmd("confirm bd " .. current_buf)
		require("bufdelete").bufdelete(current_buf)
	else
		require("bufdelete").bufdelete(0)
	end
end, { silent = true, desc = "close buffer" })
map("n", "<leader>co", function()
	local bufs = get_bufs()

	for _, buf in ipairs(bufs) do
		if
			vim.fn.bufwinnr(buf) == -1
			-- and vim.bo[buf].modified == false
		then
			vim.cmd(string.format("confirm bd %d", buf))
		end
	end
end, { silent = true, desc = "close other buffers" })

map("n", "<leader>ff", ":Telescope find_files<CR>", { silent = true, desc = "find files" })
map("n", "<leader>fw", ":Telescope live_grep<CR>", { silent = true, desc = "find word" })
map("n", "<leader>fm", function()
	require("conform").format({ async = true })
	-- vim.lsp.buf.format({ async = true })
end, { silent = true, desc = "format code" })

map("n", "<leader>b", ":enew<CR>", {
	desc = "new buffer",
	silent = true,
})

-- map("n", ";", ":", { noremap = true })
-- map("n", "<leader>nm", function()
--   require("noice").cmd("last")
-- end, { desc = "noice: focus last message" })

map("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
map("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
map("n", "<esc>", "<cmd>nohlsearch<cr>", { noremap = true, silent = true })
-- map('n', 'jk', '<cmd>nohlsearch<cr>', { noremap = true, silent = true })

-- show diagnostics in a floating window under the cursor

map({ "n", "i", "v" }, "<C-s>", function()
	vim.cmd("write")
end, { desc = "Save file", silent = true })

map("n", "<leader>zz", function()
	snacks.zen.zen()
end, { desc = "zen mode", noremap = true, silent = true })

map("n", "<leader>zf", function()
	snacks.zen.zoom()
end, { desc = "fullscreen (zoomed) mode", noremap = true, silent = true })

map("n", "<leader>da", vim.lsp.buf.code_action, { desc = "Show code actions" })
map("n", "<leader>df", vim.diagnostic.open_float, { desc = "Show floating errors", silent = true })
map("n", "<leader>dl", function()
	vim.diagnostic.setloclist()
end, { desc = "Show diagnostics in location list", silent = true })

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

map("n", "<leader>r", function()
	local keys = vim.api.nvim_replace_termcodes(":%s///gc<Left><Left><Left>", true, false, true)
	vim.api.nvim_feedkeys(keys, "t", false)
end, { desc = "replace (after search)" })

map({ "n", "v", "s", "o" }, "<leader>a", "ggVG", { desc = "select whole buffer", silent = true })

map({ "n", "x" }, "/", "/\\V", { noremap = true })
map("v", "/", "<Esc>/\\%V\\V", { desc = "search within visual selection" })

map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Toggle Markdown Preview" })
map({ "n", "v" }, "<leader>mp", function()
	require("nabla").popup()
end, { desc = "view latex" })
map("n", "<leader>mt", "<cmd>Mtoc<CR>", { desc = "create table of contents" })

map("n", "<leader>tt", "<cmd>term<CR>", { desc = "terminal", noremap = true, silent = true })
map("n", "<leader>ts", "<cmd>split | wincmd w | term<CR>", {
	desc = "terminal (horizontal split)",
	noremap = true,
	silent = true,
})
map("n", "<leader>tv", "<cmd>vsplit | wincmd w | term<CR>", {
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

map("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "commit", silent = true })
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
end, { desc = "gitui fullscreen" })
map("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "push", silent = true })
map("n", "<leader>gP", "<cmd>Git pull<CR>", { desc = "pull", silent = true })

map("n", "<leader>gs", function()
	require("gitsigns").stage_hunk()
end, { expr = true, desc = "stage/unstage hunk" })
map("v", "<leader>gs", function()
	require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "stage/unstage selected lines" })
map("n", "<leader>gS", function()
	require("gitsigns").stage_buffer()
end, { desc = "stage entire file" })

-- map("n", "<leader>o", "<cmd>Outline<CR>", { desc = "see outline", silent = true })
map("n", "<leader>o", function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local ft = vim.api.nvim_get_option_value(buf, "filetype")
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
end, { desc = "file outline", silent = true })

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
	end, { noremap = true })
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

map({ "n", "v", "x", "s", "o" }, "H", "zh")
map({ "n", "v", "x", "s", "o" }, "L", "zl")
map({ "n", "v", "x", "s", "o" }, "J", "<C-e>")
map({ "n", "v", "x", "s", "o" }, "K", "<C-y>")

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- map({ "i" }, "<Tab>", function()
-- 	if blink_cmp.is_visible() then
-- 		blink_cmp.select_next()
-- 	elseif has_words_before() then
-- 		blink_cmp.select_accept_and_enter()
-- 	end
-- end)
--
-- map({ "i" }, "<S-Tab>", function()
-- 	if blink_cmp.is_visible() then
-- 		blink_cmp.select_prev()
-- 	end
-- end)
--
-- map({ "i" }, "<CR>", function()
-- 	blink_cmp.accept()
-- 	if blink_cmp.is_visible() then
-- 		blink_cmp.accept()
-- 		print("yea")
-- 	else
-- 		return "<CR>"
-- 	end
-- end, { expr = true })
