M = {}
local formatting_callback = function(client, bufnr)
  vim.b.lsp_format = function()
    local params = vim.lsp.util.make_formatting_params {}
    if false then
      client.request_sync('textDocument/formatting', params, 1000, bufnr)
    else
      -- print 'async'
      client.request('textDocument/formatting', params, nil, bufnr)
    end
  end
end

local on_attach = function(client, bufnr)
  formatting_callback(client, bufnr)
  client.config.flags.debounce_text_changes = 150
  -- if client.resolved_capabilities.document_formatting then
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
          'markdown', -- slow
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
