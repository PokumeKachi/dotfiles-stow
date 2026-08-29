local M = {}

M.lsp = {
	astro = {},
	clangd = {},
	cssls = {
		cmd = { "vscode-css-language-server", "--stdio" },
		filetypes = { "css", "scss", "less" },
		init_options = {
			configurationSection = { "css", "scss", "less" },
			embeddedLanguages = {
				css = true,
				javascript = true,
			},
		},
		root_dir = function(_)
			return vim.fs.root(0, { "package.json", ".git" }) or vim.fn.getcwd()
		end,
		settings = {
			css = { validate = true },
			scss = { validate = true },
			less = { validate = true },
		},
	},
	dartls = {
		cmd = { "dart", "language-server", "--protocol=lsp" },
		settings = {
			dart = {
				completeFunctionCalls = true,
				showTodos = true,
				updateImportsOnRename = true,
			},
		},
	},
	jsonls = {},
	just_lsp = {},
	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = { enable = false },
			},
		},
	},
	marksman = {
		settings = {
			marksman = {
				diagnostics = { wikiLinks = false },
			},
		},
	},
	nixd = {},
	rust_analyzer = {
		settings = {
			["rust-analyzer"] = {
				check = {
					extraArgs = {
						"--target-dir",
						".target-clippy",
						"--",
						"--quiet",
					},
				},
			},
		},
	},
	superhtml = {
		filetypes = { "html" },
		root_dir = function(_)
			return vim.fs.root(0, { "package.json", ".git" }) or vim.fn.getcwd()
		end,
	},
	svelte = {},
	texlab = {
		filetypes = { "tex", "markdown" },
	},
	tinymist = {
		settings = {
			exportPdf = "never",
			semanticTokens = "disable",
			formatterMode = "typstyle",
			formatterProseWrap = true,
			formatterPrintWidth = 80,
			formatterIndentSize = 4,
		},
	},
	ts_ls = {},
	zk = {},
}

M.formatters = {
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
	dart_format = {
		command = "dart",
		args = { "format", "--indent", "4", "$FILENAME" },
	},
}

M.formatters_by_ft = {
	dart = { "dart_format" },
	lua = { "stylua" },
	luau = { "stylua" },
	tex = { "latexindent" },
	python = { "black" },
	sh = { "shfmt" },
	c = { "clang_format" },
	cpp = { "clang_format" },
	rust = { "rustfmt" },
	nix = { "nixfmt" },
	toml = { "taplo" },
	-- typst = { "lsp" }, -- Uncomment when ready
}

for _, ft in ipairs({
	"javascript",
	"html",
	"css",
	"typescript",
	"json",
	"markdown",
}) do
	M.formatters_by_ft[ft] = { "prettier" }
end

M.linters_by_ft = {
	luau = { "selene" },
}

return M
