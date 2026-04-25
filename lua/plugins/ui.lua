-- UI: colorscheme, statusline, which-key, indent guides.

return {
  -- Colorscheme. tokyonight-night reads great in dark terminals and has good treesitter support.
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = { style = 'night', transparent = false },
    config = function(_, opts)
      require('tokyonight').setup(opts)
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- Statusline (replaces vim-airline)
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        theme = 'tokyonight',
        section_separators = { left = '', right = '' },
        component_separators = { left = '│', right = '│' },
        globalstatus = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    },
  },

  -- Leader-key cheatsheet (huge discoverability win — new to your workflow)
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      preset = 'modern',
      delay = 300,
      spec = {
        { '<leader>f', group = 'Find / Files' },
        { '<leader>g', group = 'Git' },
        { '<leader>h', group = 'Git Hunks' },
        { '<leader>c', group = 'Code' },
        { '<leader>k', group = 'Bookmarks (Harpoon)' },
        { '<leader>b', group = 'Buffers' },
        { '<leader>v', group = 'Config' },
        { '<leader>d', group = 'Debug / Diagnostics' },
        { '<leader>x', group = 'Diagnostics List' },
        { '<leader>r', group = 'Refactor / Rename' },
        { '<leader>s', group = 'Search / Spectre' },
      },
    },
  },

  -- Indent guides (replaces vim-indent-guides)
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    main = 'ibl',
    opts = { indent = { char = '│' }, scope = { enabled = false } },
  },

  -- Pretty notifications + cmdline (cosmetic but very nice)
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' },
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
    },
  },

  -- Devicons everywhere
  { 'nvim-tree/nvim-web-devicons', lazy = true },
}
