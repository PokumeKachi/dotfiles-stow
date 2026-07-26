local g = vim.g
local is_termux = vim.fn.getenv("PREFIX") == "/data/data/com.termux/files/usr"

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

if vim.env.SSH_CONNECTION then
    g.clipboard = "osc52"
    return
end

if is_termux then
    setup_termux_clipboard()
end
