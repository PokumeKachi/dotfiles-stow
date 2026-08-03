return {
  "DrKJeff16/project.nvim",

  config = function()
    local project = require("project")
    project.setup({
  -- Runs before right before changing the project directory
  ---@type nil|fun(target_dir: string, method: string, bufnr?: integer)
  before_attach = nil,

  on_attach = nil,
  -- OR
  ---@param dir string
  ---@param method string
  ---@param bufnr? integer
  ---@param map
  ---|fun(mode_or_maps: 'n'|'i'|'v'|'V'|'t'|'o'|'x', lhs: string, rhs: string|function, opts: vim.keymap.set.Opts)
  ---|fun(mode_or_maps: table<'n'|'i'|'v'|'V'|'t'|'o'|'x', { [1]: string, [2]: string|function, [3]: vim.keymap.set.Opts }[]>)
  --[[on_attach = function(dir, method, bufnr, map)
    -- You can map a single key (ALWAYS BUFFER LOCAL AUTOMATICALLY):
    map(
      'n',
      '<leader>pS',
      function()
        vim.cmd.Project('session')
      end,
      { desc = 'Project Session' }
    )

    -- Or multiple keys, in multiple modes (ALWAYS BUFFER LOCAL AUTOMATICALLY):
    map({
      -- Normal mode
      n = {
        ['<leader>pR'] = {
          function()
            vim.cmd.Project('recents')
          end,
          { desc = 'Recent Projects' },
        },
        ['<leader>pS'] = {
          function()
            vim.cmd.Project('session')
          end,
          { desc = 'Project Session' },
        },
      },

      -- Insert mode
      i = {
        ['<A-p>'] = { ':Project<CR>', { desc = 'Project UI' } },
      }
    })

    -- ...
  end,]]

  lsp = {
    -- Whether to enable LSP-based detection
    enabled = true,

    -- LSP clients to ignore
    ignore = {},

    -- If `true`, no pattern matching will be used as a backup.
    -- WARNING: ENABLE AT YOUR OWN DISCRETION!!!!
    no_fallback = false,

    -- Whether to double-check the LSP root with the pattern matching method.
    use_pattern_matching = false,
  },

  -- Read the `Custom Projects` section below
  custom_projects = {},

  -- If enabled, projects will ONLY change manually
  manual_mode = false,

  -- Files and directories to look for to detect a root directory.
  -- These patterns will not affect LSP-based detection unless `lsp.use_pattern_matching`
  -- is set to `true`
  --
  -- This list is permanent, and any new entries are appended. You can leave this empty
  patterns = {
    '.git',
    '.github',
    '_darcs',
    '.hg',
    '.bzr',
    '.svn',
    'Pipfile',
    'Makefile',
    'Justfile',
    'pyproject.toml',
    '.pre-commit-config.yaml',
    '.pre-commit-config.yml',
    '.csproj',
    '.sln',
    '.nvim.lua',
    '.neoconf.json',
    'neoconf.json',
  },

  different_owners = {
    -- Allow adding projects with a different owner to the project session
    allow = false,

    -- Notify the user when a project with a different owner is found
    notify = true,
  },

  -- Set this to `true` if you prefer having `vim.o.autochdir` set to `true`
  enable_autochdir = false,

  -- Show projects by their name instead of their full path
  show_by_name = false,

  -- Show hidden files (global)
  show_hidden = false,

  -- Add any directory to exclude (absolute path). Keep in mind that this is recursive
  exclude_dirs = {},

  -- If disabled, you'll be notified each time the project root directory is changed
  silent_chdir = true,

  -- Whether the CWD is changed globally (`'global'`), per-tab (`'tab'`) or per-window (`'win'`)
  ---@type 'global'|'tab'|'win'
  scope_chdir = 'global',

  history = {
    -- The directory in which the history will be stored at.
    -- NOTE: A subdirectory will be created called `project_nvim`, where the history file resides
    save_dir = vim.fn.stdpath('data'),

    -- The file name for the JSON project history
    save_file = 'project_history.json',

    -- The maximum number of history entries to write in your history file
    size = 100,
  },

  log = {
    -- Whether to enable logging
    enabled = false,

    -- The maximum file size allowed for the log file before it gets cleaned
    -- This size is in Mebibytes (MiB), A.K.A. 1MiB -> 1024KiB
    max_size = 1.1,

    -- The directory where the log file will be written to
    logpath = vim.fn.stdpath('state'),
  },

  snacks = {
    -- Enable snacks.nvim picker integration
    enabled = false,

    -- Snacks project picker options
    opts = {
      -- path_icons = {},
      -- icon = {},

      -- Show hidden files
      hidden = false,

      layout = 'select',

      -- Sort directories by the newest or oldest
      ---@type 'newest'|'oldest'
      sort = 'newest',

      -- Snacks picker title prompt
      title = 'Select Project',

      -- Show project entries either by their path (`'paths'`) or their custom name (`'names'`)
      ---@type 'paths'|'names'
      show = 'paths',
    },
  },

  fzf_lua = {
    -- Enables fzf-lua picker integration
    enabled = false,

    -- Sort directories by the newest or oldest
    ---@type 'newest'|'oldest'
    sort = 'newest',

    -- Show project entries either by their path (`'paths'`) or their custom name (`'names'`)
    ---@type 'paths'|'names'
    show = 'paths',
  },

  picker = {
    -- Enables picker.nvim picker integration
    enabled = false,

    -- Show hidden files
    hidden = false,

    -- Sort directories by the newest or oldest
    ---@type 'newest'|'oldest'
    sort = 'newest',

    -- Show project entries either by their path (`'paths'`) or their custom name (`'names'`)
    ---@type 'paths'|'names'
    show = 'paths',
  },

  disable_on = {
    -- The filetypes that this plugin should ignore.
    -- This list is permanent, and any new entries are appended. You can leave this empty
    ft = {
      '',
      'NvimTree',
      'TelescopePrompt',
      'TelescopeResults',
      'alpha',
      'checkhealth',
      'lazy',
      'log',
      'ministarter',
      'neo-tree',
      'notify',
      'nvim-pack',
      'packer',
      'qf',
    },

    -- The buftypes that this plugin should ignore.
    -- This list is permanent, and any new entries are appended. You can leave this empty
    bt = { 'help', 'nofile', 'nowrite', 'terminal' },
  },

  telescope = {
    -- Whether to disable the built-in Telescope file-picker
    disable_file_picker = false,

    -- Telescope picker mappings.
    -- The operations can be:
    --   - `rename_project`
    --   - `browse_project_files`
    --   - `delete_project`
    --   - `find_project_files`
    --   - `recent_project_files`
    --   - `search_in_project_files`
    --   - `change_cwd`
    mappings = {
      -- Normal mode
      n = {
        R = 'rename_project',
        b = 'browse_project_files',
        d = 'delete_project',
        f = 'find_project_files',
        r = 'recent_project_files',
        s = 'search_in_project_files',
        w = 'change_cwd',
      },

      -- Insert mode
      i = {
        ['<C-b>'] = 'browse_project_files',
        ['<C-d>'] = 'delete_project',
        ['<C-f>'] = 'find_project_files',
        ['<C-n>'] = 'rename_project',
        ['<C-r>'] = 'recent_project_files',
        ['<C-s>'] = 'search_in_project_files',
        ['<C-w>'] = 'change_cwd',
      },
    },

    -- Whether to use `telescope-file-browser.nvim` instead
    -- (if enabled, will set `disable_file_picker` to `false`)
    prefer_file_browser = false,

    -- Sort directories by the newest or oldest
    ---@type 'oldest'|'newest'
    sort = 'newest',

    -- If `true`, project paths like `'/home/foo/...'` will become `'~/...'`
    tilde = false,
  },
})

    vim.keymap.set("n", "<leader>fp", function()
      require("telescope").extensions.projects.projects()
    end, { desc = "Find Projects" })
  end,
}
