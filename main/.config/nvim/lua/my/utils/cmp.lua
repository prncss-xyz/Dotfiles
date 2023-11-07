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

function M.confirm_c()
  local cmp = require 'cmp'
  if cmp.visible() then
    cmp.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }
    return true
  end
end

function M.confirm()
  if require('flies.actions.quickexpend').exec() then
    return
  end
  local cmp = require 'cmp'
  if cmp.visible() then
    cmp.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }
    return true
  end
end

function M.menu_previous_c()
  local cmp = require 'cmp'
  if cmp.visible() then
    cmp.select_prev_item()
  else
    cmp.complete()
  end
end

function M.menu_next_c()
  local cmp = require 'cmp'
  if cmp.visible() then
    pcall(cmp.select_next_item)
  else
    cmp.complete()
  end
end

return M
