local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("General", { clear = true })

-- Your new code: Hover diagnostics on cursor hold
autocmd("CursorHold", {
  group = augroup,
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
  desc = "Show hovering diagnostics when caret is idling",
})

-- Your new code: Auto-reload files changed on disk
autocmd(
  { "FocusGained", "BufEnter", "CursorHold" },
  {
    group = augroup,
    command = "checktime",

  desc = "Auto-reload file changes on disk",
  }
)
