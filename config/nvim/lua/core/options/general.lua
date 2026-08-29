local opt = vim.opt

-- === Core Behavior ===
opt.autoread = true
opt.updatetime = 200
opt.timeoutlen = 200

-- === UI & Display ===
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.mouse = ""

-- === Text Display ===
opt.wrap = false
opt.linebreak = true
opt.breakindent = true

-- === Command Line ===
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.inccommand = "nosplit"
opt.completeopt = { "menu", "menuone", "noselect" }
