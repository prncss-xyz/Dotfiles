local group = vim.api.nvim_create_augroup('MyAutoSave', { clear = true })

vim.api.nvim_create_autocmd(
  { 'TabLeave', 'FocusLost', 'BufLeave', 'VimLeavePre' },
  {
    pattern = '*?', -- do not match buffers with no name
    group = group,
    callback = function()
      if not vim.api.nvim_buf_is_valid(0) then
        return
      end
      if vim.bo.buftype ~= '' then
        return
      end
      if not vim.bo.modifiable then
        return
      end
      if not vim.bo.modified then
        return
      end
      local fname = vim.api.nvim_buf_get_name(0)
      if vim.fn.isdirectory(fname) == 1 then
        return
      end
      if require('my.utils.std').file_exists(fname) then
        vim.cmd 'update'
      else
        vim.cmd 'silent :w!'
      end
      if vim.g.watch_test then
        require('my.utils.relative_files').test_current_file()
      end
    end,
  }
)
