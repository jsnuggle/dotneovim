-- Keymaps. Ported from ~/.vim/vimrc.
-- Plugin-specific keymaps live with each plugin spec under lua/plugins/.

local map = vim.keymap.set

-- Sane command-key swap
map('n', ';', ':', { desc = 'Enter command mode' })

-- Escape from insert without leaving home row
map('i', 'jj', '<Esc>', { desc = 'Exit insert mode' })

-- Goodbye F1
map({ 'n', 'i', 'v' }, '<F1>', '<Esc>', { desc = 'Disable F1 help' })

-- Tab navigation
map('n', '<C-h>', '<cmd>tabprev<cr>', { desc = 'Previous tab' })
map('n', '<C-l>', '<cmd>tabnext<cr>', { desc = 'Next tab' })

-- Visual indent: keep selection
map('v', '<', '<gv', { desc = 'Indent left, keep selection' })
map('v', '>', '>gv', { desc = 'Indent right, keep selection' })

-- Yank to end-of-line (matches C and D)
map('n', 'Y', 'y$', { desc = 'Yank to end of line' })

-- Sane search regexes (very magic)
map({ 'n', 'v' }, '/', '/\\v', { desc = 'Search (very magic)' })

-- Sudo write (cmap equivalent)
map('c', 'w!!', 'w !sudo tee % >/dev/null', { desc = 'Sudo write' })

-- Find merge conflict markers
map('n', '<leader>cf', [[/\v^[<=>]{7}( .*\|$)<cr>]], { desc = 'Find merge [c]on[f]licts' })

-- Open ctag declarations in a new tab split (kept for muscle memory; LSP <gd> is the modern path)
map('n', '<C-\\>', '<cmd>tab split<cr><cmd>exec("tag ".expand("<cword>"))<cr>',
  { desc = 'Tag jump in new tab' })

-- Clear search highlight
map('n', '<leader><space>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlight' })

-- Strip trailing whitespace
map('n', '<leader>W', [[<cmd>%s/\s\+$//<cr><cmd>let @/=''<cr>]],
  { desc = 'Strip trailing whitespace' })

-- Toggle invisible characters
map('n', '<leader>l', '<cmd>set list!<cr>', { desc = 'Toggle invisibles' })

-- Edit config
map('n', '<leader>vv', '<cmd>tabedit $MYVIMRC<cr>', { desc = 'Edit init.lua' })

-- Window navigation (slight upgrade — direct rather than cycling)
map('n', '<C-Left>',  '<C-w>h')
map('n', '<C-Down>',  '<C-w>j')
map('n', '<C-Up>',    '<C-w>k')
map('n', '<C-Right>', '<C-w>l')

-- Diagnostics navigation (LSP era replaces Syntastic ]l/[l)
map('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = 'Prev diagnostic' })
map('n', ']d', function() vim.diagnostic.jump({ count = 1,  float = true }) end, { desc = 'Next diagnostic' })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show line diagnostic' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics to loclist' })

-- Quickfix toggle (your QFix function, simpler in lua)
local qf_open = false
map('n', '\\', function()
  if qf_open then vim.cmd 'cclose' else vim.cmd 'copen 10' end
  qf_open = not qf_open
end, { desc = 'Toggle quickfix' })
