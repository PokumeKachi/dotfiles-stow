require("core.options.clipboard")

require("core.options.undo")

local opt = vim.opt

opt.autoread = true
opt.updatetime = 200

opt.splitbelow = true
opt.splitright = true

opt.completeopt = { "menu", "menuone", "noselect" }
opt.background = 'light'

opt.timeout = true
opt.timeoutlen = 200

opt.cursorline = true

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevelstart = 99

opt.number = true
opt.relativenumber = true

opt.mouse = "a"
opt.softtabstop = 4
opt.tabstop = 4
opt.shiftwidth = 4
opt.wrap = false
opt.linebreak = true
opt.breakindent = true
opt.expandtab = true
opt.smartindent = true
opt.termguicolors = true
opt.inccommand = "nosplit" -- or "split" if you like a preview window
opt.signcolumn = "yes"

opt.wildmenu = true
opt.wildmode = 'longest:full,full'
