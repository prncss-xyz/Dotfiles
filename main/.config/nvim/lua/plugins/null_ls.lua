M = {}

local on_attach = function(client)
  if client.resolved_capabilities.document_formatting then
    vim.cmd 'autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()'
  end
end

function M.setup()
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
          'svelte',
          'css',
          'html',
          'json',
          'yaml',
          -- 'markdown', -- slow
          'scss',
          'toml',
        },
      },
      b.formatting.eslint_d,
      b.formatting.stylua,
      b.formatting.shfmt,
      b.diagnostics.shellcheck,
      b.code_actions.gitsigns,
      b.code_actions.refactoring,
      b.formatting.fish_indent,
      -- b.diagnostics.markdownlint,
      -- b.diagnostics.selene,
    },
  }
end

return M
