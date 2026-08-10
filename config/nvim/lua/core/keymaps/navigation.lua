local map = require("utils.keymap").map

map("n", "<Tab>", ":bnext<CR>")
map("n", "<S-tab>", ":bprev<CR>")
map("n", "<leader><Tab>", "<C-^>")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

