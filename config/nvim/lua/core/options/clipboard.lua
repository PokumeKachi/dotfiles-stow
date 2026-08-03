local g = vim.g
local opt = vim.opt

-- Always enable system clipboard integration
opt.clipboard = "unnamedplus"

-- Check if the environment variable `PREFIX` is set
local is_termux = vim.fn.getenv("PREFIX") == "/data/data/com.termux/files/usr"

-- Detect SSH connection
local is_ssh = vim.env.SSH_CONNECTION ~= nil

if is_ssh then
    -- Use OSC52 for terminal clipboard (works over SSH)
    g.clipboard = "osc52"
elseif is_termux then
    -- Use Termux's native clipboard commands
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
        cache_enabled = false,
    }
end
-- If neither, `g.clipboard` is left unset for Neovim default fallback
