local M = {}

local extract_nvim_hl = require('utils').extract_nvim_hl

function M.config()
  vim.o.showtabline = 2 -- always show tabline
  local default = extract_nvim_hl 'lualine_b_normal'
  local active = extract_nvim_hl 'lualine_a_normal'
  local buffstory = require 'buffstory'
  local render = function(f)
    f.set_colors(default)
    local function format_buf(info)
      if info.current then
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
