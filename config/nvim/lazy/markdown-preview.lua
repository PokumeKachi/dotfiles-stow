return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && yarn install",
	init = function()
		vim.cmd([[
        function! OpenMarkdownPreview(url)
          call jobstart(['firefox', '--new-window', a:url], {'detach': v:true})
        endfunction
        ]])

		-- local config_path = vim.fn.stdpath("config")
		-- vim.g.mkdp_markdown_css = config_path .. "/md.css"
		vim.g.mkdp_filetypes = { "markdown" }
		vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
	end,
	ft = { "markdown" },
}
