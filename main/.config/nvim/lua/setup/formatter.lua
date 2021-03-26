local indent = 2

vim.api.nvim_exec(
  [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.jsx,*.ts,*.tsx,*.rs,*.lua FormatWrite
augroup END
]],
  true
)

local prettier = {
  function()
    return {
      exe = "prettier",
      args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"},
      stdin = true
    }
  end
}

-- :echo &filetype

require("formatter").setup(
  {
    logging = false,
    filetype = {
      javascript = prettier,
      typescript = prettier,
      javascriptreact = prettier,
      typescriptreact = prettier,
      rust = {
        -- Rustfmt
        function()
          return {
            exe = "rustfmt",
            args = {"--emit=stdout"},
            stdin = true
          }
        end
      },
      lua = {
        -- luafmt
        function()
          return {
            exe = "luafmt",
            args = {"--indent-count", indent, "--stdin"},
            -- option "quotemark", "single" exists but is not implemented
            -- https://github.com/trixnz/lua-fmt/blob/master/test/quotes/quotes.test.ts
            stdin = true
          }
        end
      }
    }
  }
)
