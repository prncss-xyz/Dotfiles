local M = {}

-- `null_ls` uses its own configuration file

function M.config()
  -- Are also used by vim-illuminate.
  -- The defaults option (CursorLine) was quite unreadable.
  -- Actual settings cause issue when cursor it at the beginning or end.
  -- `vim.cmd 'highlight! link LspReferenceText String'`
  -- for Neon colorscheme:
  -- vim.cmd 'highlight! LspReferenceText guibg=#4db5bd guifg=#ecee7b'
  local diff_add = require('utils').extract_nvim_hl 'DiffAdd'
  local diff_change = require('utils').extract_nvim_hl 'DiffChange'
  local diagnostic_warn = require('utils').extract_nvim_hl 'DiagnosticWarn'
  vim.api.nvim_set_hl(
    0,
    'LspReferenceWrite',
    { bg = diff_add.fg, fg = diagnostic_warn.fg }
  )
  vim.api.nvim_set_hl(
    0,
    'LspReferenceRead',
    { bg = diff_change.fg, fg = diagnostic_warn.fg }
  )
  vim.api.nvim_set_hl(
    0,
    'LspReferenceText',
    { bg = diff_change.fg, fg = diagnostic_warn.fg }
    --  '#ecee7b'
  )

  local function noformat_on_attach(client, bufnr)
    -- TODO: bindings
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.config.flags.debounce_text_changes = 150
  end

  -- LSP settings
  local lspconfig = require 'lspconfig'
  -- local capabilities = vim.lsp.protocol.make_client_capabilities()
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  local flags = {
    debounce_text_changes = 500,
    allow_incremental_sync = true,
  }

  lspconfig.bashls.setup {
    on_attach = noformat_on_attach,
    capabilities = capabilities,
    flags = flags,
  }
  for _, lsp in ipairs {
    'bashls',
    'html',
    -- 'cssls',
    -- 'vimls',
    'yamlls',
    'graphql',
  } do
    lspconfig[lsp].setup {
      on_attach = noformat_on_attach,
      capabilities = capabilities,
      flags = flags,
    }
  end
  -- graphql, needs graphqlrc: https://the-guild.dev/graphql/config/docs
  do
    local capabilities_ = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    lspconfig.cssls.setup {
      settings = {},
      on_attach = noformat_on_attach,
      capabilities = capabilities_,
      flags = flags,
    }
  end
  lspconfig.jsonls.setup {
    settings = { json = { schemas = require('schemastore').json.schemas() } },
    on_attach = noformat_on_attach,
    capabilities = capabilities,
    flags = flags,
  }
  require('typescript').setup {
    disable_commands = false,
    debug = false,
    settings = {
      completions = {
        completeFunctionCalls = true,
      },
      javascript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all';
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
      typescript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all';
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
    },
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      noformat_on_attach(client, bufnr)
      -- FIXME: is it working?
      require('inlay-hints').on_attach(client, bufnr)
    end,
    flags = flags,
  }
  require('neodev').setup {
    override = function(root_dir, library)
      if
        require('neodev.util').has_file(root_dir, '/home/prncss/Dotfiles/')
      then
        library.enabled = true
        library.plugins = true
      end
    end,
  }

  lspconfig.sumneko_lua.setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      noformat_on_attach(client, bufnr)
      require('inlay-hints').on_attach(client, bufnr)
    end,
    flags = flags,
    cmd = { 'lua-language-server' },
    settings = {
      Lua = {
        hint = {
          enable = true,
        },
        diagnostics = {
          globals = {
            -- nvim
            'vim',
            'dump',
            -- packer.nvim
            'use',
            -- xplr
            'xplr',
            'version',
            -- busted
            'it',
            'describe',
            'assert',
          },
        },
        runtime = {
          version = 'LuaJIT',
        },
        telemetry = {
          enable = false,
        },
      },
      flags = flags,
    },
  }

  lspconfig.sqls.setup {
    on_attach = function(client, bufnr)
      noformat_on_attach(client, bufnr)
      require('sqls').on_attach(client, bufnr)
    end,
  }

  lspconfig.eslint.setup {
    settings = {
      packageManager = 'pnpm',
    },
  }

  -- FIXME: emmet is always the first completion match, making it a nuisance
  if false then
    lspconfig.emmet_ls.setup {
      capabilities = capabilities,
      filetypes = { 'html', 'css', 'typescriptreact', 'javascriptreact' },
    }
  end
end

return M
