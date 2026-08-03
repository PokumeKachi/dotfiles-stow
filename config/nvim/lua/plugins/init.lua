local ToBeLoaded = {}

local NonTerminalPlugins = {
  require("plugins.completion"),
  require("plugins.dap"),
  require("plugins.editing"),
  require("plugins.git"),
  require("plugins.highlighting"),
  require("plugins.languages"),
  require("plugins.lsp"),
  require("plugins.navigation"),
  require("plugins.sessions"),
  require("plugins.suites"),
  require("plugins.themes"),
  require("plugins.ui"),
}

-- Condition: skip these plugins when running in terminal-only mode
local is_terminal_mode = vim.fn.argc() == 1 and vim.fn.argv()[1] == "+term"

if not is_terminal_mode then
  vim.list_extend(ToBeLoaded, NonTerminalPlugins) -- cleaner than ipairs loop
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup
require("lazy").setup(ToBeLoaded, {
  git = { depth = 1 },
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
})
