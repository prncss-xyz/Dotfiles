local M = {}

function M.setup()
  require('nononotes').setup {
    on_ready = function()
      vim.cmd(
        string.format(
          'autocmd bufread,bufnewfile '
            .. "*.md nnoremap <buffer> %s <cmd>lua require'nononotes'.enter_link()<cr>",
          require('bindings').plugins.nononotes.enter_link
        )
      )
      vim.cmd(
        string.format(
          'autocmd bufread,bufnewfile '
            .. "/*.md nnoremap <buffer> %s <cmd>lua require'nononotes'.print_hover_title()<cr>",
          require('bindings').plugins.nononotes.print_hover_title
        )
      )
    end,
  }
end

return M
