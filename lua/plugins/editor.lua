-- Editor: file finder, file tree, treesitter, surround, comment, autopairs.

return {
  -- Telescope: replaces Command-T, CtrlP, Ack, MRU, Buffergator in one
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-ui-select.nvim',
    },
    keys = {
      { '<leader>ff', '<cmd>Telescope find_files<cr>',                desc = '[F]ind [F]iles' },
      { '<leader>fg', '<cmd>Telescope live_grep<cr>',                 desc = '[F]ind by [G]rep' },
      { '<leader>fb', '<cmd>Telescope buffers<cr>',                   desc = '[F]ind [B]uffers' },
      { '<leader>fh', '<cmd>Telescope help_tags<cr>',                 desc = '[F]ind [H]elp' },
      { '<leader>fr', '<cmd>Telescope oldfiles<cr>',                  desc = '[F]ind [R]ecent (MRU)' },
      { '<leader>fs', '<cmd>Telescope lsp_document_symbols<cr>',      desc = '[F]ind [S]ymbols (file)' },
      { '<leader>fS', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', desc = '[F]ind [S]ymbols (workspace)' },
      { '<leader>fd', '<cmd>Telescope diagnostics<cr>',               desc = '[F]ind [D]iagnostics' },
      { '<leader>fk', '<cmd>Telescope keymaps<cr>',                   desc = '[F]ind [K]eymaps' },
      { '<leader>fc', '<cmd>Telescope commands<cr>',                  desc = '[F]ind [C]ommands' },
      { '<leader>f/', '<cmd>Telescope current_buffer_fuzzy_find<cr>', desc = '[F]ind in current buffer' },
      { '<leader>fw', '<cmd>Telescope grep_string<cr>',               desc = '[F]ind [W]ord under cursor' },
      -- Buffer shortcuts (your old <leader>bb)
      { '<leader>bb', '<cmd>Telescope buffers<cr>',                   desc = '[B]uffer list' },
      -- Ack replacement
      { '<leader>a',  function() vim.cmd('Telescope grep_string default_text=' .. vim.fn.input('Grep > ')) end,
        desc = '[A]ck-style grep prompt' },
    },
    opts = function()
      local actions = require 'telescope.actions'
      return {
        defaults = {
          layout_strategy = 'horizontal',
          layout_config = { horizontal = { preview_width = 0.55 } },
          path_display = { 'truncate' },
          mappings = {
            i = {
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<esc>'] = actions.close,
            },
          },
          file_ignore_patterns = { 'node_modules', '%.git/', 'dist/', 'build/', '__pycache__/', '%.next/' },
        },
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown {} },
        },
      }
    end,
    config = function(_, opts)
      local t = require 'telescope'
      t.setup(opts)
      pcall(t.load_extension, 'fzf')
      pcall(t.load_extension, 'ui-select')
    end,
  },

  -- Neo-tree: file explorer (replaces NERDTree + nerdtree-tabs)
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    cmd = 'Neotree',
    keys = {
      { '<leader>n', '<cmd>Neotree toggle<cr>',           desc = 'Toggle file tree' },
      { '<leader>N', '<cmd>Neotree reveal<cr>',           desc = 'Reveal current file in tree' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    opts = {
      filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = 'open_default',
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = { '.DS_Store', '.git', '__pycache__', 'node_modules', '.next' },
        },
      },
      window = { width = 32 },
      default_component_configs = {
        indent = { padding = 0 },
        git_status = { symbols = {
          added = '✚', modified = '', deleted = '✖', renamed = '➜',
          untracked = '★', ignored = '◌', unstaged = '✗', staged = '✓', conflict = ''
        } },
      },
    },
  },

  -- Treesitter: modern syntax + incremental parsing
  -- Using the stable `master` branch (the classic configs API). The newer `main`
  -- branch is a rewrite with a different surface and isn't stable yet.
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'bash', 'c', 'css', 'diff', 'dockerfile', 'go', 'graphql', 'html',
        'javascript', 'jsdoc', 'json', 'jsonc', 'lua', 'luadoc', 'make',
        'markdown', 'markdown_inline', 'python', 'query', 'regex', 'ruby',
        'rust', 'scss', 'sql', 'toml', 'tsx', 'typescript', 'vim', 'vimdoc',
        'yaml',
      },
      auto_install = true,
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-Space>',
          node_incremental = '<C-Space>',
          node_decremental = '<bs>',
          scope_incremental = false,
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer', ['if'] = '@function.inner',
            ['ac'] = '@class.outer',    ['ic'] = '@class.inner',
            ['aa'] = '@parameter.outer',['ia'] = '@parameter.inner',
            ['al'] = '@loop.outer',     ['il'] = '@loop.inner',
            ['ai'] = '@conditional.outer',['ii'] = '@conditional.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
          goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
        },
      },
    },
  },

  -- Surround (replaces tpope/vim-surround)
  {
    'kylechui/nvim-surround',
    event = { 'BufReadPost', 'BufNewFile' },
    version = '*',
    opts = {},
  },

  -- Commenting (replaces nerdcommenter; nvim 0.10+ also has builtin gc)
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },

  -- Autopairs (replaces delimitMate)
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = { check_ts = true },
  },

  -- Better-escape: jj→Esc without input lag (modern way to handle the mapping)
  {
    'max397574/better-escape.nvim',
    event = 'InsertEnter',
    opts = { mappings = { i = { j = { j = '<Esc>' } } } },
  },
}
