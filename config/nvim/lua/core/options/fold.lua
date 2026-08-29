local opt = vim.opt

opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.fold()"
opt.foldlevelstart = 99
