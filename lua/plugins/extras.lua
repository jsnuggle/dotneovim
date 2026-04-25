-- Extras: undo tree, yank ring, harpoon (bookmarks), trouble, spectre, aerial.

return {
  -- Undotree: replaces gundo
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    keys = { { '<leader>u', '<cmd>UndotreeToggle<cr>', desc = 'Toggle [U]ndo tree' } },
  },

  -- Yanky: replaces YankRing (history + cycle paste)
  {
    'gbprod/yanky.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'kkharji/sqlite.lua' },
    keys = {
      { '<leader>y', '<cmd>YankyRingHistory<cr>',                       desc = 'Yank history' },
      { 'p',         '<Plug>(YankyPutAfter)',                           mode = { 'n', 'x' } },
      { 'P',         '<Plug>(YankyPutBefore)',                          mode = { 'n', 'x' } },
      { '[y',        '<Plug>(YankyCycleForward)',                       desc = 'Cycle yank forward' },
      { ']y',        '<Plug>(YankyCycleBackward)',                      desc = 'Cycle yank backward' },
    },
    opts = { ring = { storage = 'sqlite' } },
  },

  -- Harpoon 2: pinned files (replaces your custom librarian bookmark workflow)
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'VeryLazy',
    config = function()
      local h = require 'harpoon'
      h:setup()
      vim.keymap.set('n', '<leader>ka', function() h:list():add() end, { desc = 'Harpoon: [A]dd file' })
      vim.keymap.set('n', '<leader>kl', function() h.ui:toggle_quick_menu(h:list()) end, { desc = 'Harpoon: [L]ist' })
      vim.keymap.set('n', '<leader>k1', function() h:list():select(1) end, { desc = 'Harpoon: file 1' })
      vim.keymap.set('n', '<leader>k2', function() h:list():select(2) end, { desc = 'Harpoon: file 2' })
      vim.keymap.set('n', '<leader>k3', function() h:list():select(3) end, { desc = 'Harpoon: file 3' })
      vim.keymap.set('n', '<leader>k4', function() h:list():select(4) end, { desc = 'Harpoon: file 4' })
    end,
  },

  -- Trouble: pretty diagnostics / quickfix / references
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = { focus = true },
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>',                       desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',          desc = 'Buffer diagnostics' },
      { '<leader>xr', '<cmd>Trouble lsp_references toggle<cr>',                    desc = 'LSP references' },
      { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>',               desc = 'Document symbols' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<cr>',                            desc = 'Quickfix list' },
    },
  },

  -- Spectre: project-wide find-and-replace with preview
  {
    'nvim-pack/nvim-spectre',
    cmd = 'Spectre',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>sr', '<cmd>Spectre<cr>', desc = '[S]earch & [R]eplace project' },
      { '<leader>sw', function() require('spectre').open_visual { select_word = true } end,
        desc = '[S]earch [W]ord under cursor' },
    },
  },

  -- Aerial: code outline (replaces taglist)
  {
    'stevearc/aerial.nvim',
    cmd = { 'AerialToggle', 'AerialOpen' },
    keys = { { '<leader>o', '<cmd>AerialToggle!<cr>', desc = 'Toggle [O]utline' } },
    opts = { backends = { 'lsp', 'treesitter', 'markdown', 'man' } },
  },

  -- Eunuch: :Move, :Rename, :SudoWrite (still useful, keep)
  { 'tpope/vim-eunuch', cmd = { 'Move', 'Rename', 'Delete', 'SudoWrite', 'SudoEdit', 'Mkdir', 'Chmod' } },

  -- Repeat: makes . work for plugin maps (still relevant)
  { 'tpope/vim-repeat', event = 'VeryLazy' },

  -- Snacks (folke utility grab-bag): bigfile, quickfile, notifier
  -- Image / picker / lazygit modules disabled — they pull in heavy deps we don't use
  -- (kitty/wezterm graphics protocol, magick, fd, rg-as-required, etc.)
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      notifier = { enabled = true },
      statuscolumn = { enabled = true },
    },
  },
}
