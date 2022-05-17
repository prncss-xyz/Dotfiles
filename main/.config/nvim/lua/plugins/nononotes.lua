local M = {}

function M.setup()
  require('nononotes').setup {
    on_ready = function()
      vim.cmd(
        string.format(
          'autocmd bufread,bufnewfile '
            .. "/*.md nnoremap <buffer> %s <cmd>lua require'nononotes'.print_hover_title()<cr>",
          '<c-k>'
        )
      )
    end,
  }
end

return M
