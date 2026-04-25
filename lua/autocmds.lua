-- Autocommands. Ported selectively from ~/.vim/vimrc.

local aug = function(name) return vim.api.nvim_create_augroup('jsnuggle_' .. name, { clear = true }) end

-- Highlight yanked region briefly
vim.api.nvim_create_autocmd('TextYankPost', {
  group = aug 'yank_highlight',
  callback = function() vim.highlight.on_yank({ timeout = 150 }) end,
})

-- Auto-create parent dirs when saving a buffer to a non-existent path (port of MkNonExDir)
vim.api.nvim_create_autocmd('BufWritePre', {
  group = aug 'mkdir_on_save',
  callback = function(args)
    if vim.bo[args.buf].buftype ~= '' then return end
    local file = vim.uv.fs_realpath(args.match) or args.match
    if file:match('^%w+://') then return end
    local dir = vim.fs.dirname(file)
    if vim.fn.isdirectory(dir) == 0 then vim.fn.mkdir(dir, 'p') end
  end,
})

-- Filetype-specific indent (port of vim's setlocal blocks)
vim.api.nvim_create_autocmd('FileType', {
  group = aug 'filetype_indent',
  pattern = { 'javascript', 'typescript', 'typescriptreact', 'javascriptreact',
              'json', 'yaml', 'css', 'scss', 'html', 'lua', 'java', 'scala',
              'ruby', 'tf' },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.tabstop = 2
  end,
})

-- Makefiles need real tabs
vim.api.nvim_create_autocmd('FileType', {
  group = aug 'makefile_tabs',
  pattern = 'make',
  callback = function()
    vim.bo.expandtab = false
    vim.bo.shiftwidth = 8
    vim.bo.tabstop = 8
  end,
})

-- Wrap and format prose at 78 chars
vim.api.nvim_create_autocmd('FileType', {
  group = aug 'prose_wrap',
  pattern = { 'markdown', 'gitcommit', 'mail', 'text' },
  callback = function()
    vim.bo.textwidth = 78
    vim.opt_local.formatoptions:append 't'
    vim.wo.spell = true
  end,
})

-- Reload config when init.lua or any module is saved (your old vimrc trick)
vim.api.nvim_create_autocmd('BufWritePost', {
  group = aug 'reload_config',
  pattern = { vim.fn.stdpath('config') .. '/init.lua',
              vim.fn.stdpath('config') .. '/lua/options.lua',
              vim.fn.stdpath('config') .. '/lua/keymaps.lua',
              vim.fn.stdpath('config') .. '/lua/autocmds.lua' },
  callback = function()
    -- Note: plugin specs do NOT hot-reload — restart nvim for those.
    vim.cmd 'source <afile>'
    vim.notify('Reloaded ' .. vim.fn.expand('<afile>:t'))
  end,
})
