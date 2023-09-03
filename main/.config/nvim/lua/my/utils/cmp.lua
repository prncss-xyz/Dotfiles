local M = {}

function M.toggle()
  local cmp = require 'cmp'
  if cmp.visible() then
    cmp.close()
  else
    cmp.complete() -- not working
  end
end

-- function U.up()
--   local cmp = require 'cmp'
--   if cmp.visible() then
--     cmp.select_prev_item()
--     return
--   end
--   vim.fn.feedkeys(require('utils').t '<up>', '')
-- end

function M.confirm()
  local cmp = require 'cmp'
  if cmp.visible() then
    cmp.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }
    return true
  end
end

return M
