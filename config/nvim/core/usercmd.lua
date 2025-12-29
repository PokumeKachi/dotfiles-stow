local usercmd = vim.api.nvim_create_user_command

usercmd("TermFloat", function()
    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
        row = math.floor(vim.o.lines * 0.1),
        col = math.floor(vim.o.columns * 0.1),
        style = "minimal",
        border = "single",
    })

    vim.fn.termopen(os.getenv("SHELL") or "bash", {
        on_exit = function()
            vim.api.nvim_win_close(win, true)
        end,
    })

    vim.cmd("startinsert")
end, {})


