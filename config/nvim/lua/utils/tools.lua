local M = {}

M.lsp = {
    -- Astro (AstroJS / Astro framework)
    astro = {},

    -- Clangd (C/C++)
    clangd = {},

    -- CSS Language Server (CSS, SCSS, Less)
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

    -- Dart (Flutter / Dart)
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

    -- JSON Language Server
    jsonls = {},

    -- Just (justfile)
    just_lsp = {},

    -- Lua Language Server (Neovim config)
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

    -- Markdown (Marksman)
    marksman = {
        settings = {
            marksman = {
                diagnostics = { wikiLinks = false },
            },
        },
    },

    -- Nix (nixd)
    nixd = {},

    -- Rust (rust-analyzer)
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
                        "warnings",
                        "--",
                        "-j",
                        8,
                        "--quiet",
                    },
                },
            },
        },
    },

    -- SuperHTML (HTML)
    superhtml = {
        filetypes = { "html" },
        root_dir = function(_)
            return vim.fs.root(0, { "package.json", ".git" }) or vim.fn.getcwd()
        end,
    },

    -- Svelte (SvelteKit)
    svelte = {},

    -- Texlab (LaTeX)
    texlab = {
        filetypes = { "tex", "markdown" },
    },

    -- Tinymist (Typst)
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

    -- TypeScript / JavaScript (ts_ls)
    ts_ls = {},

    zk = {},
}

return M
