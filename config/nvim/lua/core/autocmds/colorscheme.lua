local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("Colorscheme", { clear = true })

local hl = vim.api.nvim_set_hl

-- Define the function once so we can call it repeatedly
local function apply_overrides()
    if vim.o.background == "dark" then
        hl(0, "LineNr", { fg = "#555555" })
        hl(0, "CursorLineNr", { fg = "#ff6b6b", bold = true })
    else
        hl(0, "LineNr", { fg = "#b0b0b0" })
        hl(0, "CursorLineNr", { fg = "#cc0000", bold = true })
    end

    -- These apply regardless of background
    hl(0, "@text.emphasis", { italic = true })
    hl(0, "markdownItalic", { italic = true })
end

-- Apply overrides immediately
apply_overrides()

-- Re-apply overrides every time the colorscheme changes
autocmd("ColorScheme", {
    group = augroup,
    callback = apply_overrides,
    desc = "Apply custom highlight overrides",
})
