--[[ Troubleshouting

:LspInfo

:checkhealth

Attempt to run the language server, and open the log with:
:lua vim.cmd('e'..vim.lsp.get_log_path())

--]]
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local nvim_lsp = require "lspconfig"
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
end

local servers = {
  "bashls",
  "cssls",
  "tsserver",
  "html",
  "jsonls",
  "vimls",
  "yamlls",
  "pyls"
  --"sumneko_lua"
}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end

nvim_lsp.sumneko_lua.setup {
  on_attach = on_attach,
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
        library = {[vim.fn.expand("$VIMRUNTIME/lua")] = true, [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true}
      }
    }
  }
}
--[[
local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true
}

nvim.efm.setup {
  init_options = {documentFormatting = true},
  settings = {
    rootMarkers = {".eslintrc.js", ".git/"},
    languages = {
      lua = {
        {formatCommand = "lua-format -i", formatStdin = true}
      },
      javascript = {eslint},
      typescript = {eslint}
    }
  }
}
]]--


--[[
--

JavaScript · TypeScript · Flow · JSX · JSON
CSS · SCSS · Less
HTML · Vue · Angular
GraphQL · Markdown · YAML 

https://prettier.io/docs/en/plugins.html

https://phelipetls.github.io/posts/configuring-eslint-to-work-with-neovim-lsp/
https://github.com/mattn/efm-langserver/blob/master/README.md

  vim-vint: &vim-vint
    lint-command: 'vint -'
    lint-stdin: true
    lint-formats:
      - '%f:%l:%c: %m'

  markdown-markdownlint: &markdown-markdownlint
    lint-command: 'markdownlint -s -c %USERPROFILE%\.markdownlintrc'
    lint-stdin: true
    lint-formats:
      - '%f:%l %m'
      - '%f:%l:%c %m'
      - '%f: %l: %m'

  markdown-pandoc: &markdown-pandoc
    format-command: 'pandoc -f markdown -t gfm -sp --tab-stop=2'

      sh-shellcheck: &sh-shellcheck
    lint-command: 'shellcheck -f gcc -x'
    lint-source: 'shellcheck'
    lint-formats:
      - '%f:%l:%c: %trror: %m'
      - '%f:%l:%c: %tarning: %m'
      - '%f:%l:%c: %tote: %m'

  sh-shfmt: &sh-shfmt
    format-command: 'shfmt -ci -s -bn'
    format-stdin: true

     html-prettier: &html-prettier
    format-command: './node_modules/.bin/prettier ${--tab-width:tabWidth} ${--single-quote:singleQuote} --parser html'

  css-prettier: &css-prettier
    format-command: './node_modules/.bin/prettier ${--tab-width:tabWidth} ${--single-quote:singleQuote} --parser css'

  json-prettier: &json-prettier
    format-command: './node_modules/.bin/prettier ${--tab-width:tabWidth} --parser json'


  lua-lua-format: &lua-lua-format
    format-command: 'lua-format -i'
    format-stdin: true


  markdown:
    - <<: *markdown-markdownlint
    - <<: *markdown-pandoc

  rst:
    - <<: *rst-lint
    - <<: *rst-pandoc

  yaml:
    - <<: *yaml-yamllint


  json:
    - <<: *json-jq
    - <<: *json-fixjson
    # - <<: *json-prettier

  csv:
    - <<: *csv-csvlint

https://dev.to/robertcoopercode/using-eslint-and-prettier-in-a-typescript-project-53jb

--]]
