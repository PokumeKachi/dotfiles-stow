local hl = vim.api.nvim_set_hl

hl(0, "CursorLineNr", {
    fg = "#ff0000",
    bg = "NONE",
    bold = true,
})

hl(0, "LineNr", {
    fg = "#888888",
    bg = "NONE",
})

hl(0, "markdownItalic", {
    italic = true,
})
