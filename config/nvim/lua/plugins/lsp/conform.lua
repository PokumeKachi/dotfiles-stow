return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("conform").setup({
			format_on_save = false,
			--[[{
                timeout_ms = 1000,
			    lsp_fallback = true,
			},]]

			formatters = {
				prettier = {
					command = "prettier",
					args = {
						"--stdin-filepath",
						"$FILENAME",
						"--tab-width",
						"4",
						"--use-tabs",
						"false",
					},
					stdin = true,
				},
				-- dart_format = {
				--     command = "dart",
				--     args = { "format", "--indent", "4", "$FILENAME", },
				-- },
				clang_format = {
					command = "clang-format",
					args = {
						"-style",
						"{BasedOnStyle: Google, IndentWidth: 4}",
					},
				},
				nixfmt = {
					command = "nixfmt",
					args = { "--indent", "4" },
				},
				stylua = {
					command = "stylua",
					args = { "--column-width", "100", "-" },
					stdin = true,
				},
			},
			formatters_by_ft = {
				dart = { "dart_format" },
				lua = { "stylua" },
				luau = { "stylua" },
				tex = { "latexindent" },
				python = { "black" },
				javascript = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
				-- typst = { "lsp" },
				markdown = { "prettier" },
				sh = { "shfmt" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				rust = { "rustfmt" },
				nix = { "nixfmt" },
				toml = { "taplo" },
			},
		})
	end,
}
