local M = {}

function M.setup()
  -- LSP settings
  local nvim_lsp = require 'lspconfig'

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

  local function on_attach(client, _)
    -- TODO: bindings
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end
  local on_attach_format = function(client)
    if client.resolved_capabilities.document_formatting then
      vim.cmd 'autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()'
    end
  end

  for _, lsp in ipairs {
    'bashls',
    'cssls',
    'html',
    'jsonls',
    'vimls',
    'yamlls',
    'tsserver',
  } do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 500,
        allow_incremental_sync = true,
      },
    }
  end

  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')
  local luadev = require('lua-dev').setup {
    lspconfig = {
      capabilities = capabilities,
      cmd = { 'lua-language-server' },
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            path = runtime_path,
          },
          diagnostics = {
            globals = {
              'vim',
              'use', -- packer
              'xplr', -- xplr
              'version', -- xplr
            },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file('', true),
          },
          telemetry = {
            enable = false,
          },
        },
      },
    },
  }
  nvim_lsp.sumneko_lua.setup(luadev)

  local null_ls = require 'null-ls'
  local b = null_ls.builtins
  null_ls.config {
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
      b.formatting.fish_indent,
      -- b.diagnostics.markdownlint,
      -- b.diagnostics.selene,
    },
  }
  nvim_lsp['null-ls'].setup { on_attach = on_attach_format }

  -- TODO:  jose-elias-alvarez/nvim-lsp-ts-utils
  -- TODO: emmet-ls (jsx branch)
  -- TODO:  grammarly

end

return M
