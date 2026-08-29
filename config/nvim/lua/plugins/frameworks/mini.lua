-- ~/.config/nvim/lua/plugins/mini.lua
-- All available mini.nvim modules.
-- Commented-out modules are either not needed or require additional setup.
-- Uncomment and adjust as you like.

return {
  "nvim-mini/mini.nvim",
  version = "*",
  config = function()
    -- ============================================================================
    -- 1. COLORS / HUES (commented out – use your own colorscheme)
    -- ============================================================================
    -- local hues = require("mini.hues")
    -- local hues_palette = {
    --   foreground = "#f6d0d5",
    --   background = "#202456",
    --   n_hues = 8,
    --   saturation = "high",
    --   accent = "fg",
    -- }
    -- hues._palette = hues_palette
    -- require("mini.hues").setup(hues._palette)

    -- ============================================================================
    -- 2. TEXT OBJECTS (ai)
    -- ============================================================================
    require("mini.ai").setup({
      custom_textobjects = nil,
      mappings = {
        around = "a",
        inside = "i",
        around_next = "an",
        inside_next = "in",
        around_last = "al",
        inside_last = "il",
        goto_left = "g[",
        goto_right = "g]",
      },
      n_lines = 200,
      search_method = "cover_or_nearest",
      silent = false,
    })

    -- ============================================================================
    -- 3. ANIMATIONS (disabled to avoid mouse scroll issues)
    -- ============================================================================
    require("mini.animate").setup({
      scroll = { enable = false },
      resize = { enable = false },
      cursor = { enable = false },
      open = { enable = false },
      close = { enable = false },
    })

    -- ============================================================================
    -- 4. OTHER MODULES – Uncomment if needed
    -- ============================================================================

    -- base16 (colorscheme builder) – not used
    -- require("mini.base16").setup()

    -- basics (basic keymaps, e.g., Q, ;) – not needed
    -- require("mini.basics").setup()

    -- bracket (bracket navigation) – not used
    -- require("mini.bracket").setup()

    -- bufremove (buffer deletion) – you might already have this elsewhere
    -- require("mini.bufremove").setup()

    -- clue (which-key like) – not used
    -- require("mini.clue").setup()

    -- colors (color preview) – not used
    -- require("mini.colors").setup()

    -- comment (built-in comments already exist in Neovim >=0.10)
    -- require("mini.comment").setup()

    -- completion (LSP/completion) – you likely use nvim-cmp
    -- require("mini.completion").setup()

    -- cursorword (highlight word under cursor) – ENABLED
    require("mini.cursorword").setup()

    -- diff (git diff signs) – not used (maybe use gitsigns)
    -- require("mini.diff").setup()

    -- doc (documentation preview) – not used
    -- require("mini.doc").setup()

    -- extra (extra operators: g? etc.) – optional
    -- require("mini.extra").setup()

    -- files (file operations) – not used
    -- require("mini.files").setup()

    -- hipatterns (highlight patterns, e.g., hex colors) – ENABLED
    require("mini.hipatterns").setup()

    -- icons (icons for other mini modules) – ENABLED
    require("mini.icons").setup()

    -- indentscope (indentation guides) – not used
    -- require("mini.indentscope").setup()

    -- jump (jump to next/prev character) – not used
    -- require("mini.jump").setup()

    -- map (create mappings with descriptions) – you have your own mapping util
    -- require("mini.map").setup()

    -- misc (misc helpers) – not used
    -- require("mini.misc").setup()

    -- notify (notification system) – you use snacks.notify
    -- require("mini.notify").setup()

    -- operators (g? etc.) – not used
    -- require("mini.operators").setup()

    -- pairs (auto‑pair) – ENABLED (customized)
    require("mini.pairs").setup({
      modes = { insert = true, command = false, terminal = false },
      mappings = {
        ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
        ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },
        -- ['<'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].' },
        [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
        ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
        ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
        [">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },
        ['"'] = { action = "open", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
        ["'"] = { action = "open", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
        ["`"] = { action = "open", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
      },
    })

    -- picker (file picker) – you use snacks.picker
    -- require("mini.picker").setup()

    -- sessions (session management) – not used
    -- require("mini.sessions").setup()

    -- splitjoin (split/join lines) – not used
    -- require("mini.splitjoin").setup()

    -- starter (start screen) – not used
    -- require("mini.starter").setup()

    -- statusline – ENABLED (custom)
    require("mini.statusline").setup({
      use_icons = vim.g.have_nerd_font,
      content = {
        inactive = function()
          local buf = vim.api.nvim_get_current_buf()
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")
          return MiniStatusline.combine_groups({
            { hl = "Comment", strings = { filename or "" } },
            { hl = "Comment", strings = { " %=" } },
          })
        end,
        active = function()
          local buf = vim.api.nvim_get_current_buf()

          local check_macro_recording = function()
            if vim.fn.reg_recording() ~= "" then
              return "Recording @" .. vim.fn.reg_recording()
            else
              return ""
            end
          end

          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
          local git = MiniStatusline.section_git({ trunc_width = 40 })
          local diff = MiniStatusline.section_diff({ trunc_width = 75 })
          local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
          local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")
          local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
          local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
          local macro = check_macro_recording()
          local location_raw = MiniStatusline.section_location({ trunc_width = 200 })

          local line = vim.fn.line(".")
          local total_lines = vim.fn.line("$")
          local scroll_percent = math.floor(line / total_lines * 100)
          local location = string.format("%s (%d%%%%)", location_raw, scroll_percent)

          return MiniStatusline.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
            "%<",
            { hl = "MiniStatuslineFilename", strings = { filename, lsp } },
            "%=",
            { hl = "MiniStatuslineFilename", strings = { macro } },
            { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
            { hl = mode_hl, strings = { search, location } },
          })
        end,
      },
    })

    -- sticky (sticky scrolling) – not used
    -- require("mini.sticky").setup()

    -- surround (surroundings) – ENABLED
    require("mini.surround").setup({
      search_method = "cover_or_nearest",
      n_lines = 20,
      silent = true,
    })

    -- tabline – ENABLED
    require("mini.tabline").setup({
      tabpage_section = "left",
    })

    -- test (testing framework integration) – not used
    -- require("mini.test").setup()

    -- trailspace (trailing whitespace) – ENABLED
    require("mini.trailspace").setup()

    -- vis (visual mode enhancements) – not used
    -- require("mini.vis").setup()
  end,
}
