local M = {}

local function hl(name)
  local succ, res = pcall(require('my.utils').extract_nvim_hl, name)
  if succ then return res end
end

function M.config()
  vim.o.showtabline = 2 -- always show tabline
  local default = hl 'lualine_b_normal'
  local active = hl 'lualine_a_normal'
  local buffstory = require 'buffstory'
  local render = function(f)
    if default then f.set_colors(default) end
    local function format_buf(info)
      if info.current and active then
        f.set_fg(active.fg)
        f.set_bg(active.bg)
      end
      f.add ' '
      f.add(f.icon(info.filename))
      f.add ' '

      local succ, title = pcall(vim.api.nvim_buf_get_var, info.buf, 'title')
      f.add(succ and title or info.filename)
      f.add ' '
    end
    f.make_bufs(format_buf, buffstory.display_list)
  end

  require('tabline_framework').setup { render = render }
end

return M
