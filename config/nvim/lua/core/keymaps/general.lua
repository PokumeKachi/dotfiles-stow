local map = require("utils.keymap").map

map({ "n", "i", "v" }, "<C-s>", "<cmd>write<CR>", {
	desc = "Save file",
})

map("n", "<leader>t", ":term<CR>", { desc = "Open Terminal" })
