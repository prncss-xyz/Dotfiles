local M = {}

function M.config()
  require('khutulun').setup {
    mv = function(source, target)
      local tsserver = require('utils.lsp').get_client 'tsserver'
      if tsserver then
        vim.cmd 'TypescriptRenameFile'
        require('typescript').renameFile(
          vim.fn.fnamemodify(source, ':h'),
          vim.fn.fnamemodify(target, ':h')
        )
        return true
      else
        return os.rename(source, target)
      end
    end,
    bdelete = function()
      require('bufdelete').bufdelete(0, true)
    end,
  }
end

return M
