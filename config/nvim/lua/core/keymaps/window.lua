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
