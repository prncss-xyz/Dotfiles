local M = {}

-- `null_ls` uses its own configuration file

function M.config()
  local on_attach = require 'my.utils.lsp'.on_attach
  local capabilities = require 'my.utils.lsp'.get_cmp_capabilities()
  local flags = require 'my.utils.lsp'.flags
  local lspconfig = require 'lspconfig'
  for _, lsp in ipairs {
    'bashls',
    'html',
    'yamlls',
    'graphql',
    'gopls',
  } do
    lspconfig[lsp].setup {
      on_attach = on_attach,
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
      on_attach = on_attach,
      capabilities = capabilities_,
      flags = flags,
    }
  end


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
