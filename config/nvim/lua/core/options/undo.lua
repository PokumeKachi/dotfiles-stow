local opt = vim.opt

local undodir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undodir, "p")

opt.undodir = undodir
opt.undofile = true
opt.undolevels = 1000
opt.undoreload = 10000
