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
          'svelte',
          'css',
          'html',
          'json',
          'yaml',
          'markdown',
          'scss',
          'toml',
        },
      },
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
