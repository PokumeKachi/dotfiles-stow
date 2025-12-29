return {
    "bullets-vim/bullets.vim",
    -- ft = { "markdown", "text" },
    config = function()
        -- vim.g.bullets_enabled_file_types = { "markdown", "text" }
        -- vim.g.bullets_checkbox_markers = " x"
        -- -- optional keymap to toggle checkbox
        -- vim.api.nvim_set_keymap("n", "<Space>x", ":call bullets#toggle_checkbox()<CR>", { noremap = true, silent = true })
    end,
}
