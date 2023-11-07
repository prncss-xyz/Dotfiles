local M = {}

function M.get_deduper()
  local current_bufnr = vim.api.nvim_get_current_buf()
  local buffs = {}
  buffs[current_bufnr] = true
  local filter = require('buffstory').get_win_filter()
  --[[ local cwd = vim.fn.getcwd() .. '/' ]]
  return function(v)
    local bufnr = v.buffer
    if buffs[bufnr] then
      return false
    else
      buffs[bufnr] = true
      return filter(bufnr)
      --[[ local bt = vim.api.nvim_buf_get_option(bufnr, 'buftype')
      if bt ~= '' then
        return
      end
      local name = vim.api.nvim_buf_get_name(bufnr)
      -- does not play well with toggleterm
      if vim.startswith(name, 'term://') then
        return false
      end
      -- only current project
      if not vim.startswith(name, cwd) then
        return false
      end
      return true ]]
    end
  end
end

function M.recent()
  require('portal.builtin').jumplist.tunnel_backward {
    filter = M.get_deduper(),
  }
end

return M
