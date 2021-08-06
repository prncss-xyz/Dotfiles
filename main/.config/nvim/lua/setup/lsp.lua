local M = {}

local servers = {
  'bashls',
  'cssls',
  'html',
  'jsonls',
  'vimls',
  'yamlls',
  'tsserver',
  -- 'pyls',
}

function M.setup()
  vim.api.nvim_command [[ hi def link LspReferenceText CursorLine ]]
  vim.api.nvim_command [[ hi def link LspReferenceWrite CursorLine ]]
  vim.api.nvim_command [[ hi def link LspReferenceRead CursorLine ]]
  local nvim_lsp = require 'lspconfig'
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    },
  }

  vim.lsp.handlers['textDocument/formatting'] =
    function(err, _, result, _, bufnr)
      if err ~= nil or result == nil then
        return
      end
      if not vim.api.nvim_buf_get_option(bufnr, 'modified') then
        local view = vim.fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, bufnr)
        vim.fn.winrestview(view)
        if bufnr == vim.api.nvim_get_current_buf() then
          vim.api.nvim_command 'noautocmd :update'
        end
      end
    end

  local mode = ''
  do
    local method = 'textDocument/publishDiagnostics'
    local default_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] =
      function(err, method0, result, client_id, bufnr, config)
        default_handler(err, method0, result, client_id, bufnr, config)
        if mode == 'lsp_diagnostic' then
          local diagnostics = vim.lsp.diagnostic.get_all()
          local qflist = {}
          for bufnr0, diagnostic in pairs(diagnostics) do
            for _, d in ipairs(diagnostic) do
              d.bufnr = bufnr0
              d.lnum = d.range.start.line + 1
              d.col = d.range.start.character + 1
              d.text = d.message
              table.insert(qflist, d)
            end
          end
          vim.lsp.util.set_qflist(qflist)
        end
      end
  end

  local function on_attach_format(client, _)
    client.resolved_capabilities.document_formatting = true
    client.resolved_capabilities.goto_definition = false
    vim.cmd 'autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()'

    -- silent is necessary for vim will complain about calling undojoin after undo
    -- vim.cmd 'autocmd CursorHold <buffer> silent! undojoin | lua vim.lsp.buf.formatting_sync()'
    vim.cmd 'autocmd BufWritePre <buffer> silent! lua vim.lsp.buf.formatting_sync()'
    -- vim.cmd 'autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()'
  end

  local function on_attach(client, _)
    client.resolved_capabilities.document_formatting = false
    if client.resolved_capabilities.document_highlight then
      vim.cmd [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]
    end
    require('illuminate').on_attach(client)
  end

  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 500,
        allow_incremental_sync = true,
      },
    }
  end

  -- ? https://github.com/folke/lua-dev.nvim/issues/21
  nvim_lsp.sumneko_lua.setup(require('lua-dev').setup {
    lspconfig = {
      on_attach = on_attach,
      cmd = { 'lua-language-server' },
      settings = {
        Lua = {
          diagnostics = {
            globals = {
              'use', -- packer
              'xplr', -- xplr
            },
          },
        },
      },
    },
  })

  local null_ls = require 'null-ls'
  local b = null_ls.builtins

  local sources = {
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
    -- b.diagnostics.selene,
    b.formatting.eslint_d,
    b.formatting.stylua,
    b.formatting.shfmt,
    -- b.diagnostics.vale,
    -- b.diagnostics.write_good,
    -- b.diagnostics.misspell, -- yay -S misspell
    b.diagnostics.shellcheck,
    b.code_actions.gitsigns,
    b.formatting.fish_indent,
  }

  null_ls.config {
    sources = sources,
  }
  require('lspconfig')['null-ls'].setup { on_attach = on_attach_format }

  -- does not work with jsx/tsx, will keep using emmet.vim
  -- local configs = require("lspconfig/configs")
  -- if not nvim_lsp.emmet_ls then
  -- 	configs.emmet_ls = {
  -- 		default_config = {
  -- 			cmd = { "emmet-ls", "--stdio" },
  -- 			filetypes = { "html", "css" },
  -- 			root_dir = function(fname)
  -- 				return vim.loop.cwd()
  -- 			end,
  -- 		},
  -- 	}
  -- end
  -- nvim_lsp.emmet_ls.setup({ capabilities = capabilities })

  local function preview_location_callback(_, _, result)
    if result == nil or vim.tbl_isempty(result) then
      return nil
    end
    vim.lsp.util.preview_location(result[1])
  end

  _G.PeekDefinition = function()
    local params = vim.lsp.util.make_position_params()
    return vim.lsp.buf_request(
      0,
      'textDocument/definition',
      params,
      preview_location_callback
    )
  end
end

return M
