--[[ Troubleshouting

:LspInfo

:checkhealth

Attempt to run the language server, and open the log with:
:lua vim.cmd('e'..vim.lsp.get_log_path())

--]]
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
  if err ~= nil or result == nil then
    return
  end
  if not vim.api.nvim_buf_get_option(bufnr, "modified") then
    local view = vim.fn.winsaveview()
    vim.lsp.util.apply_text_edits(result, bufnr)
    vim.fn.winrestview(view)
    if bufnr == vim.api.nvim_get_current_buf() then
      vim.api.nvim_command("noautocmd :update")
    end
  end
end

local nvim_lsp = require "lspconfig"

local function on_attach(fmt)
  return function(client, bufnr)
    local function buf_set_keymap(...)
      vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
      vim.api.nvim_buf_set_option(bufnr, ...)
    end
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    if fmt then
      client.resolved_capabilities.document_formatting = true
      client.resolved_capabilities.goto_definition = false
      vim.api.nvim_command [[augroup Format]]
      vim.api.nvim_command [[autocmd! * <buffer>]]
      vim.api.nvim_command [[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()]]
      vim.api.nvim_command [[augroup END]]
    else
      if client.config.flags then
        client.config.flags.allow_incremental_sync = true
        client.resolved_capabilities.document_formatting = false
      end

      -- Set autocommands conditional on server_capabilities
      if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec(
          [[
          hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
          hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
          hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
          augroup lsp_document_highlight
            autocmd! * <buffer>
            "autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
          augroup END
          ]],
          false
        )
      end
    end
  end
end

local servers = {
  "bashls",
  "cssls",
  "html",
  "jsonls",
  "vimls",
  "yamlls",
  "pyls",
  "tsserver"
  --"sumneko_lua"
}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach(false),
    capabilities = capabilities
  }
end

-- nvim_lsp.tsserver.setup {
--   on_attach = function(client, buffnr)
--     on_attach(client, buffnr)
--     local ts_utils = require("nvim-lsp-ts-utils")
--     vim.lsp.handlers["textDocument/codeAction"] = ts_utils.code_action_handler
--     require("nvim-lsp-ts-utils").setup {
--       -- defaults
--       disable_commands = false,
--       enable_import_on_completion = true,
--       import_on_completion_timeout = 5000,
--       eslint_bin = "eslint_d",
--       eslint_fix_current = false,
--       eslint_enable_disable_comments = true
--     }
--   end,
--   capabilities = capabilities
-- }

nvim_lsp.sumneko_lua.setup {
  on_attach = on_attach(false),
  capabilities = capabilities,
  cmd = {"/usr/bin/lua-language-server"},
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        path = vim.split(package.path, ";")
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          "vim", -- nvim
          "use" -- packer
        }
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
        }
      }
    }
  }
}

local prettier = {
  formatcommand = ([[
      prettier
      ${--config-precedence:configprecedence}
      ${--tab-width:tabwidth}
      ${--single-quote:singlequote}
      ${--trailing-comma:trailingcomma}
  ]]):gsub(
    "\n",
    ""
  )
}

local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true
}

local luafmt = {
  formatCommand = "luafmt --indent-count=2 --stdin",
  formatStdin = true
}
-- option "quotemark", "single" exists but is not implemented
-- https://github.com/trixnz/lua-fmt/blob/master/test/quotes/quotes.test.ts

local vint = {
  lintCommand = "vint -",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"}
}

local rustfmt = {
  formatCommand = "rustfmt --emit=stdout",
  formatStdin = true
}

local shellcheck = {
  lintCommand = "shellcheck -f gcc -x -",
  lintStdin = true,
  lintFormats = {"%f=%l:%c: %trror: %m", "%f=%l:%c: %tarning: %m", "%f=%l:%c: %tote: %m"}
}

local shfmt = {
  formatCommand = "shfmt -ci -s -bn",
  formatStdin = true
}

nvim_lsp.efm.setup {
  on_attach = on_attach(true),
  init_options = {documentFormatting = true},
  settings = {
    languages = {
      vim = {vint},
      lua = {luafmt},
      typescript = {prettier, eslint}, -- calling prettier through eslint; else use {prettier, eslint}
      javascript = {prettier, eslint},
      typescriptreact = {prettier, eslint},
      javascriptreact = {prettier, eslint},
      yaml = {prettier},
      json = {prettier},
      html = {prettier},
      scss = {prettier},
      css = {prettier},
      markdown = {prettier},
      sh = {shellcheck},
      toml = {prettier}
    }
  }
}
