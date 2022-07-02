local M = {}

-- `null_ls` uses its own configuration file

function M.setup()
  vim.fn.sign_define(
    'DiagnosticSignError',
    { text = ' ', texthl = 'diagnosticvirtualtextError' }
  )
  vim.fn.sign_define(
    'DiagnosticSignWarn',
    { text = ' ', texthl = 'diagnosticvirtualtextWarn' }
  )
  vim.fn.sign_define(
    'DiagnosticSignHint',
    { text = '', texthl = 'diagnosticvirtualtextHint' }
  )
  vim.fn.sign_define(
    'DiagnosticSignInfo',
    { text = ' ', texthl = 'diagnosticvirtualtextInfo' }
  )

  vim.diagnostic.config {
    virtual_text = false,
  }
end

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
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
    client.config.flags.debounce_text_changes = 150
    require('illuminate').on_attach(client)
    require('aerial').on_attach(client, bufnr)
    -- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
    -- FIXME:
    vim.api.nvim_create_autocmd('CursorHold', {
      buffer = bufnr,
      callback = function()
        vim.diagnostic.open_float()
      end,
    })
  end

  -- LSP settings
  local lspconfig = require 'lspconfig'
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
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
    -- 'bashls',
    'html',
    'cssls',
    'vimls',
    'yamlls',
    -- 'graphql',
  } do
    lspconfig[lsp].setup {
      on_attach = noformat_on_attach,
      capabilities = capabilities,
      flags = flags,
    }
  end
  lspconfig.jsonls.setup {
    settings = { json = { schemas = require('schemastore').json.schemas() } },
    on_attach = noformat_on_attach,
    capabilities = capabilities,
    flags = flags,
  }
  require 'typescript'.setup {
    disable_commands = false,
    debug = false,
    server = {
      capabilities = capabilities,
      on_attach = noformat_on_attach,
      flags = flags,
    }
  }
  local luadev = require('lua-dev').setup {
    lspconfig = {
      capabilities = capabilities,
      cmd = { 'lua-language-server' },
      on_attach = noformat_on_attach,
      settings = {
        Lua = {
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
      },
      flags = flags,
    },
  }
  lspconfig.sumneko_lua.setup(luadev)

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

  local language_id_mapping = {
    bib = 'bibtex',
    plaintex = 'tex',
    rnoweb = 'sweave',
    rst = 'restructuredtext',
    tex = 'latex',
    xhtml = 'xhtml',
    sh = 'shellscript',
  }

  require('lspconfig').ltex.setup {
    filetypes = {
      'html',
      'bib',
      'gitcommit',
      'markdown',
      'org',
      'plaintex',
      'rst',
      'rnoweb',
      'tex',
      -- causes too many false positives
      -- 'sh',
      'go',
      'javascript',
      'javascriptreact',
      'lua',
      'python',
      'sql',
      'typescript',
      'typescriptreact',
      'NeogitCommitMessage',
    },
    get_langugage_id = function(_, filetype)
      local language_id = language_id_mapping[filetype]
      if language_id then
        return language_id
      else
        return filetype
      end
    end,
    settings = {
      ltex = {
        enabled = true and {
          'shellscript',
          'go',
          'javascript',
          'javascriptreact',
          'lua',
          'python',
          'sql',
          'typescript',
          'typescriptreact',
          'markdown',
        } or {},
        language = 'en',
        -- autodetection does not work well for source files and keyword heavy notes
        -- language = 'auto',
        additionalRules = {
          motherTongue = {
            'fr',
          },
        },
        completionEnabled = true,
      },
    },
  }

  -- FIXME: emmet is always the first completion match, making it a nuisance
  if false then
    lspconfig.emmet_ls.setup {
      capabilities = capabilities,
      filetypes = { 'html', 'css', 'typescriptreact', 'javascriptreact' },
    }
  end

  require 'plugins.lsp.utils'
end

return M
