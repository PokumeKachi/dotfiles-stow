return {
	"Thiago4532/mdmath.nvim",
	event = { "BufReadPost *.md", "BufNewFile *.md" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		dynamic = true,
		dynamic_scale = 1,
		update_interval = 200,
		internal_scale = 1.5,
	},

	-- The build is already done by default in lazy.nvim, so you don't need
	-- the next line, but you can use the command `:MdMath build` to rebuild
	-- if the build fails for some reason.
	-- build = ':MdMath build'
}
