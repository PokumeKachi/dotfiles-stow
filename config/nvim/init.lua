local config_path = vim.fn.stdpath("config")
package.path = package.path .. ";" .. config_path .. "/?.lua"

require('priority')

local cmd = vim.cmd

local undodir = vim.fn.stdpath("state") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end
vim.o.undodir = undodir
vim.o.undofile = true

-- local undodir = vim.fn.stdpath('state') .. '/undo'
-- if vim.fn.isdirectory(undodir) == 0 then
--   vim.fn.mkdir(undodir, 'p')
-- end
--
-- vim.o.undodir = undodir
-- vim.o.undofile = true
vim.o.undolevels = 1000 -- optional: lots of undo levels
vim.o.undoreload = 10000 -- optional: many lines to record

vim.g.mapleader = " "

require("plugins")
for _, f in ipairs(vim.fn.glob(vim.fn.stdpath("config") .. "/core/*.lua", true, true)) do
	pcall(require, "core." .. vim.fn.fnamemodify(f, ":t:r"))
end

if vim.fn.argc() == 1 and vim.fn.argv()[1] == "+term" then
	print("terminal!")
end

if os.getenv("SSH_CONNECTION") then
	vim.g.clipboard = "osc52"
end
