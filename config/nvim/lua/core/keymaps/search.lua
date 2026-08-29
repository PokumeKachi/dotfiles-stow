local map = require("utils.keymap").map

map({ "n", "x" }, "/", "/\\V")

map("v", "/", "<Esc>/\\%V\\V", {
	desc = "Search Within Visual Selection",
})
