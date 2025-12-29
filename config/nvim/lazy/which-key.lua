
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
lazy = false,
  config = function()
    local wk = require("which-key")

    wk.setup()

    wk.add({
      { "<leader>l", group = "lsp" },
      { "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "go to definition", silent = true },
      { "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "view documentation", silent = true },
      { "<leader>ln", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "rename", silent = true },
      { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "view code actions", silent = true },
      { "<leader>lr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "go to references", silent = true },
      { "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "go to implementation", silent = true },
      { "<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", desc = "go to type definition", silent = true },
      {
        "<leader>?",
        function()
          wk.show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    })
  end,
}

