local opt = vim.opt
vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.g.mkdp_markdown_css = ''
vim.g.mkdp_math = 1

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_set_hl(0, "markdownItalic", { italic = true })

opt.timeout = true
opt.timeoutlen = 200

opt.cursorline = true

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevelstart = 99

local is_termux = vim.fn.has("unix") == 1 and vim.fn.getenv("PREFIX") == "/data/data/com.termux/files/usr"

if is_termux then
    vim.g.clipboard = {
        name = "termux-clipboard",
        copy = {
            ["+"] = "termux-clipboard copy",
            ["*"] = "termux-clipboard copy",
        },
        paste = {
            ["+"] = "termux-clipboard paste",
            ["*"] = "termux-clipboard paste",
        },
        cache_enabled = 0,
    }
end

opt.clipboard = "unnamedplus"

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

vim.cmd([[
  highlight CursorLineNr guifg=#ffcc00 guibg=NONE gui=bold
  highlight LineNr guifg=#888888 guibg=NONE
]])
