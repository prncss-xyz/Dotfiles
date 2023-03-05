local M = {}

M.config = function()
  local highlitght_list = { 'CursorLine', 'Function' }
  require('indent_blankline').setup {
    show_current_context = false,
    char = ' ',
    buftype_exclude = { 'terminal', 'help', 'nofile' },
    filetype_exclude = { 'help', 'packer' },
    char_highlight_list = highlitght_list,
    space_char_highlight_list = highlitght_list,
    space_char_blankline_highlight_list = highlitght_list,
  }
end

return M
