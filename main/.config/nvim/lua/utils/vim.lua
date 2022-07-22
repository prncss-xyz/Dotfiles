local M = {}

function M.toggle_conceal()
  if vim.o.conceallevel > 0 then
    vim.o.conceallevel = 0
  else
    vim.o.conceallevel = 2
  end
end

function M.toggle_conceal_cursor()
  if vim.o.concealcursor == 'n' then
    vim.o.concealcursor = ''
  else
    vim.o.concealcursor = 'n'
  end
end

-- https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/surround.lua
function M.get_marks_pos(mode)
  -- Region is inclusive on both ends
  local mark1, mark2
  if mode == 'x' then
    mark1, mark2 = '<', '>'
  else
    mark1, mark2 = '[', ']'
  end

  local pos1 = vim.api.nvim_buf_get_mark(0, mark1)
  local pos2 = vim.api.nvim_buf_get_mark(0, mark2)

  -- Tweak position in linewise mode as marks are placed on the first column
  local is_linewise = (mode == 'x' and vim.fn.visualmode() == 'V')
  if is_linewise then
    -- Move start mark past the indent
    pos1[2] = vim.fn.indent(pos1[1])
    -- Move end mark to the last character (` - 2` here because `col()` returns
    -- column right after the last 1-based column)
    pos2[2] = vim.fn.col { pos2[1], '$' } - 2
  end

  -- Make columns 1-based instead of 0-based. This is needed because
  -- `nvim_buf_get_mark()` returns the first 0-based byte of mark symbol and
  -- all the following operations are done with Lua's 1-based indexing.
  pos1[2], pos2[2] = pos1[2] + 1, pos2[2] + 1

  -- Tweak second position to respect multibyte characters. Reasoning:
  -- - These positions will be used with 'insert_into_line(line, col, text)' to
  --   add some text. Its logic is `line[1:(col - 1)] + text + line[col:]`,
  --   where slicing is meant on byte level.
  -- - For the first mark we want the first byte of symbol, then text will be
  --   insert to the left of the mark.
  -- - For the second mark we want last byte of symbol. To add surrounding to
  --   the right, use `pos2[2] + 1`.
  local line2 = vim.fn.getline(pos2[1])
  ---- This returns the last byte inside character because
  ---- `vim.str_byteindex()` 'rounds upwards to the end of that sequence'.
  pos2[2] = vim.str_byteindex(
    line2,
    -- Use `math.min()` because it might lead to 'index out of range' error
    -- when mark is positioned at the end of line (that extra space which is
    -- selected when selecting with `v$`)
    vim.str_utfindex(line2, math.min(#line2, pos2[2]))
  )

  return pos1, pos2
end

function M.get_range_text(s, e)
  local start_row, start_col = unpack(s)
  start_row = start_row - 1
  local end_row, end_col = unpack(e)
  end_row = end_row - 1

  -- We have to remember that end_col is end-exclusive

  if start_row ~= end_row then
    local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)
    lines[1] = string.sub(lines[1], start_col)
    -- end_row might be just after the last line. In this case the last line is not truncated.
    if #lines == end_row - start_row + 1 then
      lines[#lines] = string.sub(lines[#lines], 1, end_col)
    end
    return lines
  else
    local line =
      vim.api.nvim_buf_get_lines(
        0,
        start_row,
        start_row + 1,
        false
      )[1]
    -- If line is nil then the line is empty
    return line and { string.sub(line, start_col, end_col) } or {}
  end
end

function M.get_selection()
  local s, e = M.get_marks_pos 'x'
  -- make sure the range is going forward
  if s[1] > e[1] or (s[1] == e[1] and s[2] > e[2]) then
    s, e = e, s
  end
  if vim.o.selection ~= 'exclusive' then
    e[2] = e[2] + 1
  end
  return M.get_range_text(s, e)
end

return M
