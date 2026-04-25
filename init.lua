-- jsnuggle's neovim config
-- Entrypoint. Loads core settings, then bootstraps lazy.nvim and plugins.

-- Leader must be set BEFORE plugins load so their lazy-load keymaps pick it up.
vim.g.mapleader = ','
vim.g.maplocalleader = ','

require 'options'
require 'keymaps'
require 'autocmds'

-- Bootstrap lazy.nvim (clones it on first run, then takes over plugin management).
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = { { import = 'plugins' } },
  install = { colorscheme = { 'tokyonight-night', 'habamax' } },
  checker = { enabled = true, notify = false }, -- background update checks, no notifications
  change_detection = { notify = false },
})
