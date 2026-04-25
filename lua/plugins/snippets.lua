-- Snippet engine. Friendly-snippets ports the common vim-snippets corpus.

return {
  {
    'L3MON4D3/LuaSnip',
    lazy = true,
    version = 'v2.*',
    build = (vim.fn.has 'win32' == 0) and 'make install_jsregexp' or nil,
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
}
