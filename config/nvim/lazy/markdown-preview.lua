function _G.OpenMarkdownPreview(url)
    vim.fn.jobstart({ "brave", "--new-window", url }, { detach = true })
end

return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    config = function()
        vim.g.mkdp_math = 1
        vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
    end,
}
