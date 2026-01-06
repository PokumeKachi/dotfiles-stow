

return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets" },
	version = "1.*",

	opts = {
		keymap = {
			preset = "default",
			["<CR>"] = { "accept", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },
			["<Tab>"] = { "select_next", "fallback" },
		},
		cmdline = { enabled = true, sources = { "cmdline", "path" } },
		appearance = { nerd_font_variant = "mono" },
		completion = {
			keyword = { range = "full" },

			accept = { auto_brackets = { enabled = false } },

			list = { selection = { preselect = false, auto_insert = true } },

			menu = {
				auto_show = true,

				draw = {
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon", "kind" },
					},
				},
			},

			documentation = { auto_show = true, auto_show_delay_ms = 10 },

			ghost_text = { enabled = true },
		},
		sources = { default = { "lsp", "path", "snippets", "buffer" } },
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
}
