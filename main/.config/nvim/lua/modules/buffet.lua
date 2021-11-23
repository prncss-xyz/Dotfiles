local M = {}

-- TODO: filetype specific

local conf = {
  previous = 'N',
  next = 'n',
  inner = 'i',
  outer = 'a',
  add_query = {
    w = 'iw',
    W = 'iW',
  },
  textojb_prefix = { 'n', 'N' },
  pairs = {
    { '(', ')' },
    { '{', '}' },
    { '[', ']' },
    { '<', '>' },
    { '[[', ']]' },
  },
  add = {
    q = "'",
    Q = '`',
    ['('] = { '(', ')' },
    [')'] = { '(', ')' },
    b = { '(', ')' },
    B = { '[[', ']]' },
    ['{'] = { '{', '}' },
    ['}'] = { '{', '}' },
    ['['] = { '[', ']' },
    [']'] = { '[', ']' },
    ['<'] = { '<', '>' },
    ['>'] = { '<', '>' },
    a = ',',
    -- i = 'i', -- interactive (prompt left then right char)
    -- t = 't', -- xml tag
    -- k = 'f', -- function call
  },
}

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function includes(a, t)
  for _, v in ipairs(a) do
    if v == t then
      return true
    end
  end
end

local function input_char(msg)
  M.needs_help_msg = true
  vim.defer_fn(function()
    if not M.needs_help_msg then
      return
    end
    vim.notify(msg)
  end, 1000)
  local char = vim.fn.getchar()
  M.needs_help_msg = false

  -- Terminate if input is `<Esc>`
  if char == 27 then
    return nil
  end

  if type(char) == 'number' then
    char = vim.fn.nr2char(char)
  end
  if char:find '^[%w%p%s]$' == nil then
    vim.notify 'Input must be single character: alphanumeric, punctuation, or space.'
    return nil
  end

  return char
end

---- Work with operator marks
local function get_marks_pos(mode)
  -- Region is inclusive on both ends
  local mark1, mark2
  if mode == 'visual' then
    mark1, mark2 = '<', '>'
  else
    mark1, mark2 = '[', ']'
  end

  local pos1 = vim.api.nvim_buf_get_mark(0, mark1)
  local pos2 = vim.api.nvim_buf_get_mark(0, mark2)

  -- Tweak position in linewise mode as marks are placed on the first column
  local is_linewise = (mode == 'line')
    or (mode == 'visual' and vim.fn.visualmode() == 'V')
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

  return {
    first = { line = pos1[1], col = pos1[2] },
    second = { line = pos2[1], col = pos2[2] },
  }
end

---- Work with cursor
local function cursor_adjust(line, col)
  local cur_pos = vim.api.nvim_win_get_cursor(0)

  -- Only adjust cursor if it is on the same line
  if cur_pos[1] ~= line then
    return
  end

  vim.api.nvim_win_set_cursor(0, { line, col - 1 })
end

local function delete_linepart(linepart)
  local line = vim.fn.getline(linepart.line)
  local new_line = line:sub(1, linepart.from - 1) .. line:sub(linepart.to + 1)
  vim.fn.setline(linepart.line, new_line)
end

local function insert_into_line(line_num, col, text)
  -- Important to remember when working with multibyte characters: `col` here
  -- represents byte index, not character
  local line = vim.fn.getline(line_num)
  local new_line = line:sub(1, col - 1) .. text .. line:sub(col)
  vim.fn.setline(line_num, new_line)
end

local function starts_with(str, start)
  return str:sub(1, #start) == start
end

local function ends_with(str, ending)
  return ending == '' or str:sub(-#ending) == ending
end


function M.sandwich_add(mode, char)
  char = conf.add[char] or char
  local surr_info
  if type(char) == 'table' then
    surr_info = { left = char[1], right = char[2] }
  end
  if type(char) == 'string' then
    surr_info = { left = char, right = char }
  end
  local marks = get_marks_pos(mode)
  -- Add surrounding. Begin insert with 'end' to not break column numbers
  ---- Insert after the right mark (`+ 1` is for that)

  if true then
    insert_into_line(marks.second.line, marks.second.col + 1, surr_info.right)
    insert_into_line(marks.first.line, marks.first.col, surr_info.left)
    --
    -- -- Tweak cursor position
    cursor_adjust(marks.first.line, marks.first.col + surr_info.left:len())
  end
end

-- TODO: understand why it works fine with right to left selection
function M.sandwich_delete(mode)
  local marks = get_marks_pos(mode)
  local line_left = vim.fn.getline(marks.first.line)
  local line_right = vim.fn.getline(marks.second.line)
  local chars_left = line_left:sub(marks.first.col)
  local chars_right = line_right:sub(1, marks.second.col)
  local char_left = chars_left:sub(1, 1)
  local char_right = chars_right:sub(chars_right:len(), chars_right:len())
  local len_right = 0
  local len_left = 1
  if char_right == char_left then
    len_right = 1
  end
  for _, p in ipairs(conf.pairs) do
    if starts_with(chars_left, p[1]) and ends_with(chars_right, p[2]) then
      len_left = p[1]:len()
      len_right = p[2]:len()
      break
    end
  end
  local right = {
    line = marks.second.line,
    from = marks.second.col - len_right + 1,
    to = marks.second.col,
  }
  local left = {
    line = marks.first.line,
    from = marks.first.col,
    to = marks.first.col + len_left - 1,
  }
  delete_linepart(right)
  delete_linepart(left)
  cursor_adjust(left.right, left.from)
end

local last_char
function M.sandwich_add_char(mode)
  local char
  if last_char and mode ~= 'visual' then
    char = last_char
  else
    char = input_char '[buffet] enter char: '
    if not char then
      return
    end
    last_char = char
  end
  sandwich_add(mode, char)
end

function M.sandwich_add_query()
  local char = input_char '[buffet] enter query: '
  if not char then
    return
  end
  -- todo: count, multiple char textojb
  local res
  if conf.add_query[char] then
    res = conf.add_query[char]
  elseif includes(conf.textojb_prefix, char) then
    res = conf.outer .. char
    char = input_char '[buffet] enter query: '
    if not char then
      return
    end
    res = res .. char
  else
    res = conf.outer .. char
  end
  last_char = nil
  vim.cmd(string.format 'set operatorfunc=v:lua.SandwichAddChar')
  return 'g@' .. res
end

-- [sad]

function M.sandwich_delete_query()
  local char = input_char '[buffet] enter query: '
  if not char then
    return
  end
  -- TODO: count, multiple char textojb
  local res
  if conf.add_query[char] then
    res = conf.add_query[char]
  elseif includes(conf.textojb_prefix, char) then
    res = conf.outer .. char
    char = input_char '[buffet] enter query: '
    if not char then
      return
    end
    res = res .. char
  else
    res = conf.outer .. char
  end
  last_char = nil
  vim.cmd(string.format 'set operatorfunc=v:lua.SandwichDelete')
  return 'g@' .. res
end

-- [ sdf ]

function M.setup()
  _G.SandwichAddChar = M.sandwich_add_char
  _G.SandwichAddQuery = M.sandwich_add_query
  _G.SandwichDelete = M.sandwich_delete
  _G.SandwichDeleteQuery = M.sandwich_delete_query
  vim.api.nvim_set_keymap(
    'n',
    '<Plug>(u-sandwich-operator-add)',
    'v:lua.SandwichAddQuery()',
    { noremap = false, expr = true }
  )
  vim.api.nvim_set_keymap(
    'x',
    '<Plug>(u-sandwich-operator-add)',
    ':<c-u>lua require"modules.buffet".sandwich_add_char"visual"<cr>',
    {}
  )
  vim.api.nvim_set_keymap(
    'n',
    '<Plug>(u-sandwich-operator-delete)',
    'v:lua.SandwichDeleteQuery()',
    { noremap = false, expr = true }
  )
  vim.api.nvim_set_keymap(
    'x',
    '<Plug>(u-sandwich-operator-delete)',
    ':<c-u>lua require"modules.buffet".sandwich_delete_char"visual"<cr>',
    {}
  )
  vim.api.nvim_set_keymap(
    'n',
    ' x',
    '<Plug>(u-sandwich-operator-add)',
    { noremap = false }
  )
  vim.api.nvim_set_keymap(
    'x',
    '<Plug>(u-sandwich-operator-delete)',
    ':<c-u>lua require"modules.buffet".sandwich_delete"visual"<cr>',
    {}
  )
  vim.api.nvim_set_keymap(
    'x',
    ' x',
    '<Plug>(u-sandwich-operator-delete)',
    { noremap = false }
  )
  vim.api.nvim_set_keymap(
    'n',
    ' y',
    '<Plug>(u-sandwich-operator-delete)',
    { noremap = false }
  )
  vim.api.nvim_set_keymap(
    'x',
    ' y',
    '<Plug>(u-sandwich-operator-delete)',
    { noremap = false }
  )
end

M.setup()

return M
