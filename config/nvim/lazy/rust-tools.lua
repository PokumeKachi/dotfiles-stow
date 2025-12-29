return {
  "simrat39/rust-tools.nvim",
  dependencies = { "nvim-lspconfig" },
  config = function()
    require("rust-tools").setup({
      server = {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      },
    })
  end,
}
