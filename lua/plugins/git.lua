-- Git integration: fugitive (kept), gitsigns (gutter), diffview (PR-style).

return {
  -- Fugitive: still the gold standard for `:Git ...`
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'G', 'Gdiffsplit', 'Gread', 'Gwrite', 'Gblame', 'Gbrowse',
            'Ggrep', 'GMove', 'GDelete', 'GBrowse' },
    keys = {
      { '<leader>gb', '<cmd>Git blame<cr>',  desc = 'Git [B]lame' },
      { '<leader>gd', '<cmd>Gdiffsplit<cr>', desc = 'Git [D]iff' },
      { '<leader>gs', '<cmd>Git<cr>',        desc = 'Git [S]tatus' },
      { '<leader>gw', '<cmd>Gwrite<cr>',     desc = 'Git [W]rite (stage current file)' },
      { '<leader>gc', '<cmd>Git commit<cr>', desc = 'Git [C]ommit' },
    },
  },

  -- gh integration for fugitive's :GBrowse on github.com (replaces vim-rhubarb)
  { 'tpope/vim-rhubarb', dependencies = { 'tpope/vim-fugitive' }, cmd = 'GBrowse' },

  -- Gitsigns: hunk gutter + inline blame + stage/preview hunks
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs = require 'gitsigns'
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map('n', ']c', function() if vim.wo.diff then vim.cmd.normal { ']c', bang = true } else gs.nav_hunk('next') end end, 'Next git hunk')
        map('n', '[c', function() if vim.wo.diff then vim.cmd.normal { '[c', bang = true } else gs.nav_hunk('prev') end end, 'Prev git hunk')
        map('n', '<leader>hs', gs.stage_hunk,         'Git: [S]tage hunk')
        map('n', '<leader>hr', gs.reset_hunk,         'Git: [R]eset hunk')
        map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, 'Git: [S]tage hunk (visual)')
        map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, 'Git: [R]eset hunk (visual)')
        map('n', '<leader>hS', gs.stage_buffer,       'Git: [S]tage buffer')
        map('n', '<leader>hp', gs.preview_hunk,       'Git: [P]review hunk')
        map('n', '<leader>hb', function() gs.blame_line { full = true } end, 'Git: [B]lame line')
        map('n', '<leader>hd', gs.diffthis,           'Git: [D]iff this')
        map('n', '<leader>htb', gs.toggle_current_line_blame, 'Git: [T]oggle [B]lame')
      end,
    },
  },

  -- Diffview: PR-style review of any commit/branch range
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gv', '<cmd>DiffviewOpen<cr>',         desc = 'Git: Diff[V]iew' },
      { '<leader>gV', '<cmd>DiffviewClose<cr>',        desc = 'Git: Close Diff[V]iew' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>',desc = 'Git: File [H]istory' },
    },
    opts = { use_icons = true },
  },
}
