-- inner as it's own textobject
--[[
--available()`: return a table of all snippets defined for the current
    filetypes(s) (`{ft1={snip1, snip2}, ft2={snip3, snip4}}`).
lsp_expand(snip_string)`: expand the lsp-syntax-snippet defined via
    `snip_string` at the cursor
]]

-- TODO: linewise indent
-- TODO: user input register
-- TODO: refactor
local M = {}
local G = {}
local conf = {
  filetype = {
    javascriptreact = 'javascript',
    typescriptreact = 'javascript',
    typescript = 'javascript',
  },
  dot = '.',
  register = '+',
  query = {
    av = { 'av', 'iv' },
    aw = { 'aw', 'iw' },
    aW = { 'aW', 'iW' },
    f = { 'af', 'if' },
    Nf = { 'Naf', 'if' },
    nf = { 'naf', 'if' },
    w = 'iw',
    W = 'iW',
    q = 'aq',
    nq = 'anq',
    Nq = 'aNq',
    b = 'ab',
    nb = 'anb',
    Nb = 'aNb',
    l = 'il',
    nl = 'inl',
    Nl = 'iNl',
  },
  recipies = {
    { '', ' ', key = 'w' },
    { ', ', '', key = 'a' },
    { '', '_', key = 'v' },
    { '', '.', key = 's' },
    { '[[', ']]', key = 'B', filetype = 'lua' },
    { '(', ')', key = 'b' },
    { '{', '}', key = 'B' },
    { '[', ']' },
    { '<', '>' },
    { ',', key = 'a' },
    { '`', key = 'q' },
    -- regex = true,
    -- query = 'w',
    -- key = '',
  },
  add = {
    w = { '', ' ' },
    a = { ',', '' },
    v = { '', '_' },
    s = { '', '.' },
    q = "'",
    Q = '`',
    ['('] = { '(', ')' },
    [')'] = { '(', ')' },
    b = { '(', ')' },
    G = { '[[', ']]' },
    ['{'] = { '{', '}' },
    ['}'] = { '{', '}' },
    ['['] = { '[', ']' },
    [']'] = { '[', ']' },
    ['<'] = { '<', '>' },
    ['>'] = { '<', '>' },
    -- i = 'i', -- interactive (prompt left then right char)
    -- t = 't', -- xml tag
    -- k = 'f', -- function call
  },
}

local trigger_char = 'x'
local query
local last_char
local rep
local will_rep
local snips

local function load_snippets()
  if snips then
    return
  end
  local BUFFET = require 'plugins.luasnip.buffet'
  snips = {}
  local ls = require 'luasnip'
  for _, value in pairs(BUFFET) do
    snips[value.trigger] = value
    value.trigger = trigger_char
  end
end

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

local function starts_with(str, start)
  return str:sub(1, #start) == start
end

local function ends_with(str, ending)
  return ending == '' or str:sub(-#ending) == ending
end

local needs_help_msg
local function input_char(msg)
  needs_help_msg = true
  vim.defer_fn(function()
    if not needs_help_msg then
      return
    end
    vim.notify(msg)
  end, 1000)
  local char = vim.fn.getchar()
  needs_help_msg = false

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

local function add(char, marks, line_wise)
  local filetype = conf.filetype[vim.bo.filetype] or vim.bo.filetype
  load_snippets()
  local snip = snips
    and (snips[filetype .. ':' .. char] or snips['all:' .. char])
  if snip then
    local lines = vim.api.nvim_buf_get_lines(
      0,
      marks.first.line - 1,
      marks.second.line,
      true
    )
    local trailing = lines[#lines]:len() == marks.second.col
    lines[#lines] = lines[#lines]:sub(1, marks.second.col)
    lines[1] = lines[1]:sub(marks.first.col)
    M.contents = lines
    -- trailing space is needed snippet's trigger is the last character of the line
    local chars = trigger_char
    if trailing then
      chars = chars .. ' '
    end
    vim.api.nvim_buf_set_text(
      0,
      marks.first.line - 1,
      marks.first.col - 1,
      marks.second.line - 1,
      marks.second.col,
      { chars }
    )
    -- print '--'
    -- require('modules.utils').dump(marks)
    vim.api.nvim_win_set_cursor(0, { marks.first.line, marks.first.col })
    local snippet = snip:copy()
    snippet:trigger_expand(
      require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
    )
    local cursor = vim.api.nvim_win_get_cursor(0)
    -- require('modules.utils').dump(cursor)
    -- require('modules.utils').dump(marks)
    local line = cursor[1]
    -- local len = cursor[2]
    -- local line = marks.second.line
    if trailing then
      local len = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:len()
      -- removing previously added trainling space
      -- print(len)
      vim.api.nvim_buf_set_text(0, line - 1, len - 1, line - 1, len, { '' })
    end
    return
  end
  local surr_info
  char = conf.add[char] or char
  if type(char) == 'table' then
    surr_info = { left = char[1], right = char[2] }
  end
  if type(char) == 'string' then
    surr_info = { left = char, right = char }
  end
  if line_wise then
    vim.api.nvim_buf_set_lines(
      0,
      marks.second.line,
      marks.second.line,
      true,
      { surr_info.right }
    )
    vim.api.nvim_buf_set_lines(
      0,
      marks.first.line - 1,
      marks.first.line - 1,
      true,
      { surr_info.left }
    )
    return
  end
  -- Add surrounding. Begin insert with 'end' to not break column numbers
  -- Insert after the right mark (`+ 1` is for that)
  insert_into_line(marks.second.line, marks.second.col + 1, surr_info.right)
  insert_into_line(marks.first.line, marks.first.col, surr_info.left)
  -- Tweak cursor position
  cursor_adjust(marks.first.line, marks.first.col + surr_info.left:len())
end

local function find_outer(mode)
  local marks = get_marks_pos(mode)
  local line_left = vim.fn.getline(marks.first.line)
  local line_right = vim.fn.getline(marks.second.line)
  local chars_left = line_left:sub(marks.first.col)
  local chars_right = line_right:sub(1, marks.second.col)
  -- local char_left = chars_left:sub(1, 1)
  -- local char_right = chars_right:sub(chars_right:len(), chars_right:len())
  local len_right = 0
  local len_left = 0
  -- local len_left = 1
  -- if char_right == char_left then
  --   len_right = 1
  -- end
  local filetype = conf.filetype[vim.bo.filetype] or vim.bo.filetype
  for _, p in ipairs(conf.recipies) do
    if #p == 2 then
      if not p.filetype or p.filetype == filetype then
        if starts_with(chars_left, p[1]) and ends_with(chars_right, p[2]) then
          len_left = p[1]:len()
          len_right = p[2]:len()
          break
        end
      end
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
  return left, right
end

local marks_a
function M.delete_query()
  local marks_i = get_marks_pos 'visual'
  vim.api.nvim_buf_set_text(
    0,
    marks_i.second.line - 1,
    marks_i.second.col,
    marks_a.second.line - 1,
    marks_a.second.col,
    { '' }
  )
  local line_wise = marks_a.first.line < marks_i.first.line
  vim.api.nvim_buf_set_text(
    0,
    marks_a.first.line - 1,
    marks_a.first.col - 1,
    marks_i.first.line - 1,
    line_wise and 0 or marks_i.first.col - 1,
    { '' }
  )
  -- calculates the position of the remaining text
  -- it starts where the outer textobject started, and keeps the dimensions of
  -- inner textobject
  local marks = {
    first = marks_a.first,
    second = {
      line = marks_a.first.line + marks_i.second.line - marks_i.first.line,
      col = line_wise
          and marks_a.first.col + marks_i.second.col - marks_i.first.col
        or marks_i.second.col,
    },
  }
  return marks, line_wise
end

function M.replace_query()
  loads_snippets()
  local snip = snips
    and (
      snips[vim.bo.filetype .. ':' .. last_char]
      or snips['all:' .. last_char]
    )
  if snip then
    local left, right = find_outer()
    local lines = vim.api.nvim_buf_get_lines(0, left.line - 1, right.line, true)
    lines[#lines] = lines[#lines]:sub(1, right.from - 1)
    lines[1] = lines[1]:sub(left.to + 1)
    M.contents = lines
    local marks = get_marks_pos()
    vim.api.nvim_buf_set_text(
      0,
      marks.first.line - 1,
      marks.first.col - 1,
      marks.second.line - 1,
      marks.second.col,
      { 'x ' }
    )
    local snippet = snip:copy()
    snippet:trigger_expand(
      require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
    )
    vim.api.nvim_buf_set_text(
      0,
      marks.second.line - 1,
      marks.second.col,
      marks.second.line - 1,
      marks.second.col + 1,
      { '' }
    )
    return
  end
  local marks, line_wise = M.delete_query()
  add(last_char, marks, line_wise)
end

local function delete(mode)
  local left, right = find_outer(mode)
  delete_linepart(right)
  -- TODO:
  delete_linepart(left)
  cursor_adjust(left.line, left.from)
end

-- TODO: get desired register
local function extract(mode)
  local left, right = find_outer(mode)
  local lines = vim.api.nvim_buf_get_lines(0, left.line - 1, right.line, true)
  lines[#lines] = lines[#lines]:sub(1, right.from - 1)
  lines[1] = lines[1]:sub(left.to + 1)
  vim.fn.setreg(conf.register, table.concat(lines, '\n'))
  local marks = get_marks_pos(mode)

  vim.api.nvim_buf_set_text(
    0,
    marks.first.line - 1,
    marks.first.col - 1,
    marks.second.line - 1,
    marks.second.col,
    { '' }
  )
end

function M.extract_query(reg)
  local marks_i = get_marks_pos 'visual'
  local left = marks_i.first
  local right = marks_i.second
  local line_wise = marks_a.first.line < marks_i.first.line
  local lines = vim.api.nvim_buf_get_lines(0, left.line - 1, right.line, true)
  if not line_wise then
    lines[#lines] = lines[#lines]:sub(1, right.col)
    lines[1] = lines[1]:sub(left.col)
  end
  vim.fn.setreg(reg or '+', table.concat(lines, '\n'))
  vim.api.nvim_buf_set_text(
    0,
    marks_a.first.line - 1,
    marks_a.first.col - 1,
    marks_a.second.line - 1,
    marks_a.second.col,
    { '' }
  )
end

local function ask_char()
  rep = will_rep
  will_rep = false
  if not (rep and last_char) then
    local char
    char = input_char '[buffet add] enter char: '
    if not char then
      return
    end
    last_char = char
  end
  return last_char
end

local opfunc = {}
G.opfunc = opfunc

function G.opfunc.add(mode)
  local char = ask_char()
  if not char then
    return
  end
  local marks = get_marks_pos(mode)
  add(char, marks)
end

function G.opfunc.delete(mode)
  if query then
    marks_a = get_marks_pos 'visual'
    vim.fn.feedkeys('v', 'n')
    vim.fn.feedkeys(query)
    vim.fn.feedkeys(t ':<c-u>lua require"modules.buffet".delete_query()<cr>')
    return
  end
  delete(mode)
end

function G.opfunc.extract(mode)
  if query then
    marks_a = get_marks_pos 'visual'
    vim.fn.feedkeys('v', 'n')
    vim.fn.feedkeys(query)
    vim.fn.feedkeys(t ':<c-u>lua require"modules.buffet".extract_query()<cr>')
    return
  end
  extract(mode)
end

function G.opfunc.replace(mode)
  local char = ask_char()
  if not char then
    return
  end
  if query then
    marks_a = get_marks_pos 'visual'
    vim.fn.feedkeys('v', 'n')
    vim.fn.feedkeys(query)
    vim.fn.feedkeys(t ':<c-u>lua require"modules.buffet".replace_query()<cr>')
    return
  end
  delete(mode)
  local marks = get_marks_pos(mode)
  add(char, marks)
end

local function is_ambiguous(t, k)
  for key in pairs(t) do
    if starts_with(key, k) then
      return true
    end
  end
end

-- TODO: count: currently you can enter count before operator; it would be nice to add it just before query
function G.query(operator)
  local res = ''
  query = nil
  while true do
    local char = input_char '[buffet add] enter query: '
    if not char then
      return
    end
    res = res .. char
    local val = conf.query[res]
    if val then
      if type(val) == 'table' then
        res = val[1]
        query = val[2]
      else
        res = val
      end
      break
    end
    if not is_ambiguous(conf.query, res) then
      break
    end
  end
  last_char = nil
  vim.cmd('set operatorfunc=v:lua.Buffet.opfunc.' .. operator)
  return 'g@' .. res
end

function G.predot()
  will_rep = true
  return conf.dot
end

function M.setup()
  _G.Buffet = G

  vim.api.nvim_set_keymap(
    'n',
    conf.dot,
    'v:lua.Buffet.predot()',
    { expr = true, noremap = false }
  )

  -- Add
  vim.api.nvim_set_keymap(
    'n',
    '<Plug>(buffet-operator-add)',
    'v:lua.Buffet.query("add")',
    { noremap = false, expr = true }
  )
  vim.api.nvim_set_keymap(
    'x',
    '<Plug>(buffet-operator-add)',
    ':<c-u>lua Buffet.opfunc.add("visual")<cr>',
    {}
  )

  -- Delete
  vim.api.nvim_set_keymap(
    'n',
    '<Plug>(buffet-operator-delete)',
    'v:lua.Buffet.query("delete")',
    { noremap = false, expr = true }
  )
  vim.api.nvim_set_keymap(
    'x',
    '<Plug>(buffet-operator-delete)',
    ':<c-u>lua Buffet.opfunc.delete("visual")<cr>',
    {}
  )

  -- Replace
  vim.api.nvim_set_keymap(
    'n',
    '<Plug>(buffet-operator-replace)',
    'v:lua.Buffet.query("replace")',
    { noremap = false, expr = true }
  )
  vim.api.nvim_set_keymap(
    'x',
    '<Plug>(buffet-operator-replace)',
    ':<c-u>lua Buffet.opfunc.replace("visual")<cr>',
    {}
  )

  -- Extract
  vim.api.nvim_set_keymap(
    'n',
    '<Plug>(buffet-operator-extract)',
    'v:lua.Buffet.query("extract")',
    { noremap = false, expr = true }
  )
  vim.api.nvim_set_keymap(
    'x',
    '<Plug>(buffet-operator-extract)',
    ':<c-u>lua Buffet.opfunc.extract("visual")<cr>',
    {}
  )
end

return M
