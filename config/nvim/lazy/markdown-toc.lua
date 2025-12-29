return {
  "hedyhli/markdown-toc.nvim",
  ft = "markdown",  -- Lazy load on markdown filetype
  cmd = { "Mtoc" }, -- Or, lazy load on "Mtoc" command
  config = function()
    require("mtoc").setup()
  end,
  -- opts = {
  --   -- Your configuration here (optional)
  -- },
}
