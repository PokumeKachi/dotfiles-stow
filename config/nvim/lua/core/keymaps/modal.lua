local map = require("utils.keymap").map
local map_all_cases = require("utils.keymap").map_all_cases

map("n", "<esc>", "<cmd>nohlsearch<cr>")
map_all_cases(map, { "i" }, "jk", "<C-\\><C-n>")
