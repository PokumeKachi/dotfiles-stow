-- Performance
vim.loader.enable()

-- Disable built-in plugins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("plugins")
require("core")
