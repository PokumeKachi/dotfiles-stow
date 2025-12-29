vim.api.nvim_create_user_command("TermFloat", function()
    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
        row = math.floor(vim.o.lines * 0.1),
        col = math.floor(vim.o.columns * 0.1),
        style = "minimal",
        border = "rounded",
    })
    -- vim.fn.termopen(os.getenv("SHELL"))
    vim.fn.termopen(os.getenv("SHELL"), { buf = buf })
    vim.cmd("startinsert")
end, {})
