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

map("n", "<leader>ws", "<C-w>s", { desc = "Horizontal Split Window" })
map("n", "<leader>wv", "<C-w>v", { desc = "Vertical Split Window" })

for key, direction in pairs(DIRECTION_MAP) do
	map("n", "<leader>w" .. key, "<C-w>" .. key, {
		desc = "Focus Window " .. direction,
	})
end

map("n", "<leader>wm", function()
	require("winmove").start_mode("resize")
end, {
	desc = "Resize Window",
})

map("n", "<leader>wt", ":term<CR>", { desc = "Open Terminal" })

map("n", "<leader>wqc", ":quit<CR>", { desc = "Quit Current Window" })
map("n", "<leader>wqa", ":qa<CR>", { desc = "Quit All Windows" })
map("n", "<leader>wqo", ":only<CR>", { desc = "Quit Other Windows" })
