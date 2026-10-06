return {
	"bullets-vim/bullets.nvim",
	ft = { "markdown", "text", "gitcommit", "typst" },
	---@type bullets.Config
	opts = {
		enabled_file_types = { "markdown", "text", "gitcommit", "typst" },

		-- Match only hyphens and numbers/numbered list variants
		list_item_styles = { "-", ".+", "#." },

		-- Demote/promote cycling only between hyphens and numbers
		outline_levels = { "num", "std-" },
	},
}
