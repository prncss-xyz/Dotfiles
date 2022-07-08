local M = {}

local extract_nvim_hl = require('utils').extract_nvim_hl

function M.config()
  vim.o.showtabline = 2 -- always show tabline
  local diff_add = extract_nvim_hl 'DiffAdd'
  local diff_change = extract_nvim_hl 'DiffChange'
  local normal = extract_nvim_hl 'Normal'
  local buffstory = require 'buffstory'
  local render = function(f)
    local function format_buf(info)
      if info.index == 5 then
        f.add { '|', fg = diff_add.fg, bg = normal.bg }
      end
      if info.current then
        f.set_fg(normal.bg)
        f.set_bg(diff_add.fg)
      else
        f.set_fg(diff_change.fg)
        f.set_bg(normal.bg)
      end
      f.add ' '
      f.add(f.icon(info.filename))
      f.add ' '
      f.add(info.filename)
      f.add ' '
    end
    local buflist = {}
    for i = 1, 4 do
      buflist[i] = buffstory.buflist[i]
    end
    f.make_bufs(format_buf, buflist)
  end

  require('tabline_framework').setup { render = render }
end

return M
