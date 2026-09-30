vim.filetype.add({
	extension = {
		rn = "rune",
		rune = "rune",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "rune",
	callback = function()
		vim.bo.commentstring = "// %s"
	end,
})
