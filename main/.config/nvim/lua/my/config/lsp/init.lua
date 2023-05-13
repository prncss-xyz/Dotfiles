local M = {}

-- `null_ls` uses its own configuration file

function M.config()
  local capabilities = require('my.utils.lsp').get_cmp_capabilities()
  local flags = require('my.utils.lsp').flags
  local lspconfig = require 'lspconfig'
  for _, lsp in ipairs {
    'bashls',
    'cssls',
    'html',
    'graphql',
    'eslint',
    'julials',
    'prismals',
  } do
    lspconfig[lsp].setup {
      -- on_attach = on_attach,
      -- capabilities = capabilities,
      -- flags = flags,
    }
  end
  -- graphql, needs graphqlrc: https://the-guild.dev/graphql/config/docs
  --
  local lazy_table = require('my.utils.lazy').table

  lspconfig.yamlls.setup {
    settings = lazy_table(function()
      return {
        yaml = {
          schemas = require('schemastore').yaml.schemas(),
        },
      }
    end),
  }
  if false then
    --FIX: schemas seems to disable jsonls
    lspconfig.jsonls.setup {
      settings = lazy_table(function()
        return {
          json = { schemas = require('schemastore').json.schemas() },
          validate = { enable = true },
        }
      end),
    }
  else
    lspconfig.jsonls.setup {}
  end

  -- FIXME: emmet is always the first completion match, making it a nuisance
  if false then
    lspconfig.emmet_ls.setup {
      -- capabilities = capabilities,
      filetypes = { 'html', 'css', 'typescriptreact', 'javascriptreact' },
    }
  end
end

return M
