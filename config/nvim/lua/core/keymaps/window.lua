local map = require("utils.keymap").map

local DIRECTION_MAP = {
	h = "left",
	j = "below",
	k = "above",
	l = "right",
}

for key, direction in pairs(DIRECTION_MAP) do
	map("n", "<leader>wn" .. key, function()
		vim.api.nvim_open_win(0, true, { split = direction })
	end, {
		desc = "Split Window To " .. direction,
	})
end

for key, direction in pairs(DIRECTION_MAP) do
	map("n", "<leader>w" .. key, "<C-w>" .. key, {
		desc = "Focus Window " .. direction,
	})
end

map("n", "<leader>qwc", ":quit<CR>", { desc = "Quit Current Window" })
map("n", "<leader>qwa", ":qa<CR>", { desc = "Quit All Windows" })
map("n", "<leader>qwo", ":only<CR>", { desc = "Quit Other Windows" })

map("n", "<leader>w=", "<C-w>=", { desc = "Equalize Window Sizes" })

map("n", "<leader>wf", function()
	local wins = vim.api.nvim_tabpage_list_wins(0)
	local float_wins = {}

	for _, win in ipairs(wins) do
		local config = vim.api.nvim_win_get_config(win)
		if config.relative ~= "" then
			table.insert(float_wins, win)
		end
	end

	if #float_wins == 0 then
		vim.notify("No floating windows found", vim.log.levels.INFO)
		return
	end

	local cur_win = vim.api.nvim_get_current_win()
	local idx = nil
	for i, w in ipairs(float_wins) do
		if w == cur_win then
			idx = i
			break
		end
	end

	if idx then
		local next_idx = idx % #float_wins + 1
		vim.api.nvim_set_current_win(float_wins[next_idx])
	else
		vim.api.nvim_set_current_win(float_wins[1])
	end
end, { desc = "Cycle Through Floating Windows" })
