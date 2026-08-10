local map = require("utils.keymap").map

map({ "n", "x" }, "/", "/\\V")
map("v", "/", "<Esc>/\\%V\\V", {
	desc = "Search Within Visual Selection",
})
map("n", "<leader>rr", function()
	local keys = vim.api.nvim_replace_termcodes(":%s///gc<Left><Left><Left>", true, false, true)
	vim.api.nvim_feedkeys(keys, "t", false)
end, {
	desc = "(replace) search",
})
