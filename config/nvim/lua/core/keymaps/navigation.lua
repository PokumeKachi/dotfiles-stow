local map = require("utils.keymap").map

local function next_same_indent()
	local indent = vim.fn.indent(".")
	local line = vim.fn.line(".")
	local last = vim.fn.line("$")

	for i = line + 1, last do
		if vim.fn.indent(i) == indent then
			vim.cmd("normal! " .. i .. "G")
			return
		end
	end
end

local function prev_same_indent()
	local indent = vim.fn.indent(".")
	local line = vim.fn.line(".")

	for i = line - 1, 1, -1 do
		if vim.fn.indent(i) == indent then
			vim.cmd("normal! " .. i .. "G")
			return
		end
	end
end

map({ "n", "i", "c", "x", "t" }, "<leader>]", next_same_indent, {
	desc = "Next Same Indent",
})
map({ "n", "i", "c", "x", "t" }, "<leader>[", prev_same_indent, {
	desc = "Previous Same Indent",
})

map("n", "<Tab>", ":bnext<CR>")
map("n", "<S-tab>", ":bprev<CR>")
map("n", "<leader><Tab>", "<C-^>")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

