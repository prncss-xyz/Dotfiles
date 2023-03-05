local M = {}

local i = 0

function M.config()
  print 'starting'
  -- require('hclipboard').start()
  require('hclipboard').setup {
    should_bypass_cb = function(regname, ev)
      local ret = false
      i = i + 1
      if ev.visual and (ev.operator == 'd' or ev.operator == 'c') then
        if ev.regname ~= '+' then
          ret = true
        end
      end
      return ret
    end,
  }
  require('hclipboard').start()
end

return M
