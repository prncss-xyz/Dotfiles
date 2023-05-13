M = {}

local on_attach = function(client, bufnr)
  client.config.flags.debounce_text_changes = 150
  -- if client.server_capabilities.documentFormattingProvider then
  --   vim.cmd 'autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()' -- FIXME:
  --   vim.cmd 'autocmd InsertLeave <buffer> lua vim.lsp.buf.formatting_sync()'
  -- end
end

function M.config()
  local b = require('null-ls').builtins
  require('null-ls').setup {
    on_attach = on_attach,
    sources = {
      b.formatting.prettierd.with {
        filetypes = {
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
          'vue',
          'css',
          'scss',
          'less',
          'html',
          'json',
          'jsonc',
          'yaml',
          'markdown',
          'mdx',
          'graphql',
          'handlebars',
          'toml',
        },
      },

      b.formatting.stylua,
      b.formatting.shfmt,
      b.diagnostics.shellcheck,
      b.code_actions.gitsigns,
      b.code_actions.refactoring,
      -- b.diagnostics.markdownlint,
      -- b.diagnostics.selene,
      -- b.diagnostics.gospel,
      b.diagnostics.golangci_lint,
      b.formatting.golines.with {
        extra_args = {
          '--max-len=100',
          '--base-formatter=gofumpt',
        },
      },
      b.formatting.fourmolu,
    },
  }
end

return M
