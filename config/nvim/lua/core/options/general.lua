local opt = vim.opt

-- === Core Behavior ===
opt.autoread = true
opt.updatetime = 200
opt.timeoutlen = 200

-- === Splits & Windows ===
opt.splitbelow = true
opt.splitright = true

-- === UI & Display ===
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.mouse = "a"

-- === Indentation (Global defaults) ===
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- === Text Display ===
opt.wrap = false
opt.linebreak = true
opt.breakindent = true

-- === Folding (Modern Treesitter) ===
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.fold()"
opt.foldlevelstart = 99

-- === Command Line ===
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.inccommand = "nosplit"
opt.completeopt = { "menu", "menuone", "noselect" }
