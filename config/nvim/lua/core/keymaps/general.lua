local map = require('utils.keymap').map

local window = require('utils.window')
local file = require('utils.file')

map("n", "<F5>", function()
	local current_file = file.get_current()
	window.create_floating()
	vim.fn.termopen("just --choose -- " .. current_file)
end)

-- map("n", "<F3>", nil)

map("n", "<F6>", function()
	window.create_floating()
	vim.fn.termopen("just run")
end)
