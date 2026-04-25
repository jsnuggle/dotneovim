-- LSP, completion, formatting, linting.
-- Stack: mason -> nvim-lspconfig (for server defaults) -> blink.cmp (completion)
--        conform.nvim (format) -> nvim-lint (extra linters not covered by LSP)

return {
  -- Mason: installs LSP servers, formatters, linters as portable binaries
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonUpdate' },
    opts = { ui = { border = 'rounded' } },
  },

  -- mason-lspconfig: bridges Mason and lspconfig + auto-installs declared servers
  {
    'williamboman/mason-lspconfig.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function()
      require('mason').setup()

      -- Servers to install. mason-lspconfig auto-enables them via vim.lsp.config (nvim 0.11+ API).
      local servers = {
        lua_ls = {
          settings = { Lua = {
            completion = { callSnippet = 'Replace' },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          } },
        },
        pyright = {
          settings = { python = { analysis = {
            typeCheckingMode = 'basic',
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          } } },
        },
        ruff = {},                -- Python linter+formatter LSP
        vtsls = {                 -- TypeScript/React (faster successor to tsserver)
          settings = {
            typescript = { inlayHints = {
              parameterNames = { enabled = 'literals' },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
            } },
            javascript = { inlayHints = {
              parameterNames = { enabled = 'literals' },
              variableTypes = { enabled = true },
            } },
          },
        },
        eslint = {},
        tailwindcss = {},
        jsonls = {},
        yamlls = {},
        bashls = {},
        cssls = {},
        html = {},
        marksman = {},            -- Markdown LSP
      }

      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      }

      -- Apply per-server config via vim.lsp.config (nvim 0.11+)
      for name, cfg in pairs(servers) do
        vim.lsp.config(name, cfg)
      end

      -- Extra tools: formatters, linters, debug adapters
      require('mason-tool-installer').setup {
        ensure_installed = {
          'prettierd',
          'stylua',
          'shfmt',
          'eslint_d',
        },
      }

      -- LSP keymaps applied per-buffer when an LSP attaches
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('jsnuggle_lsp_attach', { clear = true }),
        callback = function(event)
          local map = function(keys, fn, desc)
            vim.keymap.set('n', keys, fn, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          map('gd', vim.lsp.buf.definition,        '[G]oto [D]efinition')
          map('gD', vim.lsp.buf.declaration,       '[G]oto [D]eclaration')
          map('gr', vim.lsp.buf.references,        '[G]oto [R]eferences')
          map('gI', vim.lsp.buf.implementation,    '[G]oto [I]mplementation')
          map('gy', vim.lsp.buf.type_definition,   '[G]oto t[y]pe definition')
          map('K',  vim.lsp.buf.hover,             'Hover docs')
          map('<leader>rn', vim.lsp.buf.rename,    '[R]e[n]ame symbol')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('<leader>cs', '<cmd>Telescope lsp_document_symbols<cr>',           'Document [S]ymbols')
          map('<leader>cS', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>',  'Workspace [S]ymbols')

          -- Inlay hints if available
          if vim.lsp.inlay_hint and event.data and event.data.client_id then
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client.server_capabilities.inlayHintProvider then
              vim.keymap.set('n', '<leader>ch', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf },
                  { bufnr = event.buf })
              end, { buffer = event.buf, desc = 'LSP: Toggle inlay [H]ints' })
            end
          end
        end,
      })

      -- Diagnostics UI
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '✘',
            [vim.diagnostic.severity.WARN]  = '▲',
            [vim.diagnostic.severity.INFO]  = '●',
            [vim.diagnostic.severity.HINT]  = '⚑',
          },
        },
        virtual_text = { source = 'if_many', spacing = 2 },
      }
    end,
  },

  { 'neovim/nvim-lspconfig', lazy = true },

  -- Completion engine (modern, fast — replaces YouCompleteMe / SuperTab / AutoComplPop)
  {
    'saghen/blink.cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    version = '*',
    dependencies = { 'rafamadriz/friendly-snippets', 'L3MON4D3/LuaSnip' },
    opts = {
      keymap = { preset = 'default' },
      appearance = { nerd_font_variant = 'mono' },
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
      snippets = { preset = 'luasnip' },
      signature = { enabled = true },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        ghost_text = { enabled = false },
      },
    },
  },

  -- Format-on-save (replaces your BeautifyCode function and php sniff hooks)
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      { '<leader>cf', function() require('conform').format { async = true, lsp_format = 'fallback' } end,
        desc = '[C]ode [F]ormat' },
    },
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_format', 'ruff_organize_imports' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd' },
        jsonc = { 'prettierd' },
        css = { 'prettierd' },
        scss = { 'prettierd' },
        html = { 'prettierd' },
        yaml = { 'prettierd' },
        markdown = { 'prettierd' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
      },
      format_on_save = function(bufnr)
        -- Allow disabling via :FormatDisable / :FormatEnable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return { timeout_ms = 1500, lsp_format = 'fallback' }
      end,
    },
    init = function()
      vim.api.nvim_create_user_command('FormatDisable', function(args)
        if args.bang then vim.b.disable_autoformat = true else vim.g.disable_autoformat = true end
      end, { desc = 'Disable autoformat-on-save', bang = true })
      vim.api.nvim_create_user_command('FormatEnable', function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, { desc = 'Re-enable autoformat-on-save' })
    end,
  },

  -- Linters not covered by LSP (eslint_d for JS/TS in monorepos with config detection)
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePost' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        -- TS/JS handled by eslint LSP usually; nvim-lint as a fallback if needed
        -- python is fully handled by ruff LSP, no entry needed
      }
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('jsnuggle_lint', { clear = true }),
        callback = function() require('lint').try_lint() end,
      })
    end,
  },
}
