return {
	"neovim/nvim-lspconfig",
	dependencies = { "saghen/blink.cmp" },
	config = function()
		local servers = {
			texlab = {
				filetypes = { "tex", "markdown" },
			},
			clangd = {},
			nixd = {},
			luau_lsp = {},
			rust_analyzer = {
				settings = {
					["rust-analyzer"] = {
						imports = {
							granularity = { group = "crate" },
							prefix = "self",
						},
						assist = {
							importGranularity = "crate",
							importPrefix = "by_self",
						},
						procMacro = { enable = false },
						cargo = {
							features = "all",
							buildScripts = { enable = false },

							noDefaultFeatures = false,
							allTargets = true,
							extraArgs = { "-j", 8 },
							targetDir = ".target-clippy",
						},

						noDefaultFeatures = false,
						allTargets = true,
						checkOnSave = true,
						diagnostics = { enable = false },
						check = {
							command = "check",
							extraArgs = {
								"--target-dir",
								".target-clippy",
								"-D",
								"warnings", -- deny warnings for stricter linting
								"--", -- pass remaining args to clippy
								"-j",
								8, -- parallel jobs
								"--quiet", -- reduce output noise
							},
							-- command = nil,
						},
					},
				},
			},
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
					return vim.fs.root(0, { "package.json", ".git" }) or vim.loop.cwd()
				end,
				settings = {
					css = { validate = true },
					scss = { validate = true },
					less = { validate = true },
				},
			}, -- CSS
			ts_ls = {}, -- JS/TS
			svelte = {}, -- Svelte/SvelteKit
			htmx = {}, -- if available, custom setup below
			jsonls = {},
			html = {
				cmd = { "vscode-html-language-server", "--stdio" },
				filetypes = { "html" },
				init_options = {
					-- configurationSection = { "html", "css", "javascript" },
					embeddedLanguages = {
						css = true,
						javascript = true,
					},
				},
				root_dir = function(_)
					return vim.fs.root(0, { "package.json", ".git" }) or vim.loop.cwd()
				end,
				settings = {},
			},
			lua_ls = {
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT", -- for neovim
						},
						diagnostics = {
							globals = { "vim" }, -- avoid "undefined global vim"
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			},
			marksman = {},
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
		}

		local blink_cmp = require("blink.cmp")
		local capabilities = blink_cmp.get_lsp_capabilities()

		local on_attach = function(client, bufnr)
			-- 	if vim.b[bufnr].lsp_maps_set then
			-- 		return
			-- 	end
			-- 	vim.b[bufnr].lsp_maps_set = true
			--
			-- 	local buf_map = function(mode, lhs, rhs, desc)
			-- 		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
			-- 	end
			--
			-- 	buf_map("n", "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<CR>", "Go To Definition")
			-- 	buf_map("n", "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<CR>", "View Documentation")
			-- 	buf_map("n", "<leader>ln", "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename")
			-- 	buf_map("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", "View Code Actions")
			-- 	buf_map("n", "<leader>lr", "<cmd>lua vim.lsp.buf.references()<CR>", "Go To References")
			-- 	buf_map("n", "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<CR>", "Go To Implementation")
			-- 	buf_map("n", "<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Go To Type Definition")
			--
			-- 	if client.server_capabilities.documentFormattingProvider then
			-- 		-- vim.api.nvim_create_autocmd("BufWritePre", {
			-- 		--   buffer = bufnr,
			-- 		--   callback = function()
			-- 		--     vim.lsp.buf.format({ async = false })
			-- 		--   end,
			-- 		-- })
			-- 	end
		end

		-- manual setup

		local configs = require("lspconfig.configs")

		if not configs.just_lsp then
			configs.just_lsp = {
				default_config = {
					cmd = { "just-lsp" },
					filetypes = { "just" },
					root_dir = vim.fs.root(0, { "justfile", ".justfile", ".git" }),
				},
			}
		end

		if not configs.htmx then
			configs.htmx = {
				default_config = {
					cmd = { "htmx-lsp" },
					filetypes = { "html" },
					root_dir = vim.fs.root(0, { ".git", "." }),
				},
			}
		end

		for server, config in pairs(servers) do
            config.capabilities = capabilities

			vim.lsp.config(server, config)
			vim.lsp.enable(server)
		end
	end,
}
