local g = vim.g
local opt = vim.opt

local is_termux = vim.fn.getenv("prefix") == "/data/data/com.termux/files/usr"

local function setup_termux_clipboard()
    g.clipboard = {
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

if vim.env.ssh_connection then
    g.clipboard = "osc52"
    return
end

if is_termux then
    setup_termux_clipboard()
end

opt.clipboard = "unnamedplus"
