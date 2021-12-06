local M = {}

local function noformat_on_attach(client, _)
  -- TODO: bindings
  client.resolved_capabilities.document_formatting = false
  client.resolved_capabilities.document_range_formatting = false
end

local format_on_attach = function(client)
  if client.resolved_capabilities.document_formatting then
    vim.cmd 'autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()'
  end
end

local function ts_uttils_on_attach(client, bufnr)
  local ts_utils = require 'nvim-lsp-ts-utils'
  ts_utils.setup {
    debug = false,
    disable_commands = false,
    enable_import_on_completion = true, -- touched

    -- import all
    import_all_timeout = 5000, -- ms
    -- lower numbers indicate higher priority
    import_all_priorities = {
      same_file = 1, -- add to existing import statement
      local_files = 2, -- git files or files with relative path markers
      buffer_content = 3, -- loaded buffer content
      buffers = 4, -- loaded buffer names
    },
    import_all_scan_buffers = 100,
    import_all_select_source = false,

    -- no eslint
    eslint_enable_code_actions = false,
    eslint_enable_disable_comments = false,
    eslint_enable_diagnostics = false,
    eslint_opts = {},
    -- no prettier
    enable_formatting = false,

    -- update imports on file move
    update_imports_on_move = true,
    require_confirmation_on_move = true,
    watch_dir = nil,

    -- filter diagnostics
    filter_out_diagnostics_by_severity = {},
    filter_out_diagnostics_by_code = {},
  }

  -- required to fix code action ranges and filter diagnostics
  ts_utils.setup_client(client)

  -- no default maps, so you may want to define some here
  -- local opts = { silent = true }
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", opts)
end

function M.setup()
  -- LSP settings
  local nvim_lsp = require 'lspconfig'
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  local flags = {
    debounce_text_changes = 500,
    allow_incremental_sync = true,
  }

  for _, lsp in ipairs {
    'bashls',
    'html',
    'cssls',
    'vimls',
    'yamlls',
  } do
    nvim_lsp[lsp].setup {
      on_attach = noformat_on_attach,
      capabilities = capabilities,
      flags = flags,
    }
  end
  nvim_lsp.jsonls.setup {
    settings = { json = { schemas = require('schemastore').json.schemas() } },
    on_attach = noformat_on_attach,
    capabilities = capabilities,
    flags = flags,
  }
  nvim_lsp.tsserver.setup {
    on_attach = function(client, bufnr)
      noformat_on_attach(client, bufnr)
      ts_uttils_on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    flags = flags,
  }
  local luadev = require('lua-dev').setup {
    lspconfig = {
      capabilities = capabilities,
      cmd = { 'lua-language-server' },
      settings = {
        Lua = {
          diagnostics = {
            globals = {
              'vim',
              'use', -- packer
              'xplr', -- xplr
              'version', -- xplr
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
  nvim_lsp.sumneko_lua.setup(luadev)

  nvim_lsp.eslint.setup {
    settings = {
      packageManager = 'pnpm',
    },
  }

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
      b.code_actions.refactoring,
      b.formatting.fish_indent,
      -- b.diagnostics.markdownlint,
      -- b.diagnostics.selene,
    },
  }
  nvim_lsp['null-ls'].setup { on_attach = format_on_attach, debounce = 500 }

  -- FIXME: trigger text is not deleted
  -- TODO: wait for jsx support
  -- nvim_lsp.emmet_ls.setup {}

  -- require('grammar-guard').init()
  -- nvim_lsp.grammar_guard.setup {}
end

return M
