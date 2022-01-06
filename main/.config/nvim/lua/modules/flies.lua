local M = {}

-- TODO: line numbers

local nop = function() end
local rep = {
  previous = nop,
  next = nop,
}

local conf
local queries
local qualifiers

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function pre_jump()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_set_mark(0, "'", pos[1], pos[2], {})
end

local function set_selection(start, ending, selection_type)
  vim.fn.setpos('.', { 0, start[1], start[2] + 1, 0 })
  vim.cmd('normal! ' .. selection_type)
  vim.fn.setpos('.', { 0, ending[1], ending[2] + 1, 0 })
end

function M.repeater_expr(bwd, fwd, noremap)
  return M.repeater(function(b)
    if b then
      vim.fn.feedkeys(bwd, noremap and 'n' or '')
    else
      vim.fn.feedkeys(fwd, noremap and 'n' or '')
    end
  end)
end

function M.repeater(cb)
  return function(mode)
    rep.previous = function(mode0)
      cb(true, true, mode0)
    end
    rep.next = function(mode0)
      cb(false, true, mode0)
    end
    cb(true, false, mode)
  end, function(mode)
    rep.previous = function(mode0)
      cb(true, true, mode0)
    end
    rep.next = function(mode0)
      cb(false, true, mode0)
    end
    cb(false, false, mode)
  end
end

function M.repeat_register(previous, next)
  rep.previous = previous
  rep.next = next
end

function M.repeat_previous(mode)
  if rep.previous then
    rep.previous(mode)
  end
end

function M.repeat_next(mode)
  if rep.next then
    rep.next(mode)
  end
end

local function treesitter_move(domain, query, qualifier, _)
  local query_string = string.format('@%s.%s', query, domain)
  if qualifier == 'previous' then
    require('nvim-treesitter.textobjects.move').goto_previous_start(
      query_string
    )
    return
  end
  if qualifier == 'next' then
    require('nvim-treesitter.textobjects.move').goto_next_start(query_string)
    return
  end
  if qualifier == 'plain' then
    require('nvim-treesitter.textobjects.move').goto_next_start(query_string)
    return
  end
  if qualifier == 'hint' then
    require('hop-extensions').hint_textobjects(
      string.format('%s.%s', query, domain)
    )
    return
  end
end

local function treesitter_select(domain, query, qualifier, mode)
  local query_string = string.format('@%s.%s', query, domain)
  local count1 = vim.v.count1
  if qualifier == 'next' then
    for _ = 1, count1 do
      require('nvim-treesitter.textobjects.move').goto_next_start(query_string)
    end
  elseif qualifier == 'previous' then
    for _ = 1, count1 do
      require('nvim-treesitter.textobjects.move').goto_previous_end(
        query_string
      )
    end
  elseif qualifier == 'hint' then
    require('hop-extensions').hint_textobjects(
      string.format('%s.%s', query, domain)
    )
  end
  require('nvim-treesitter.textobjects.select').select_textobject(
    query_string,
    mode
  )
end

function M.treesitter_select_outer(query, qualifier, mode)
  treesitter_select('outer', query, qualifier, mode)
end

local function treesitter_exchange(query, qualifier, _)
  vim.api.nvim_feedkeys(t '<Plug>(Exchange)', '', false)
  vim.api.nvim_feedkeys(
    t(
      string.format(
        '<cmd>lua require"modules.flies".treesitter_select_outer(%q, %q, "o")<cr>',
        query,
        qualifier
      )
    ),
    '',
    false
  )
  vim.api.nvim_feedkeys(t '<Plug>(Exchange)', '', false)
  vim.api.nvim_feedkeys(
    t(
      string.format(
        '<cmd>lua require"modules.flies".treesitter_select_outer(%q, "hint", "o")<cr>',
        query
      )
    ),
    '',
    false
  )
end

-- inspired by https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/jump.lua
---@param target string: The regex pattern to jump to.
---@param backward boolean: Whether to jump backward. Default: latest used value or `false`.
---@param till boolean: Whether to jump just before/after the match instead of exactly on target. Also ignore matches that don't have anything before/after them. Default: latest used value or `false`.
---@param n_times number: Number of times to perform a jump. Default: latest used value or 1.
local function jump(target, backward, till, n_times)
  -- Construct search and highlight patterns
  local flags = backward and 'Wb' or 'W'
  if till then
    if backward then
      target = target .. '.'
    else
      target = '.' .. target
    end
  end
  if backward and till then
    flags = flags .. 'e'
  end
  -- TODO: highlights

  -- Make jump(s)
  for _ = 1, n_times do
    vim.fn.search(target, flags)
  end

  -- Open enough folds to show jump
  vim.cmd [[normal! zv]]
end

local function char_move(domain, left, right, qualifier, mode)
  if qualifier == 'previous' then
    jump(left, true, domain == 'inner', vim.v.count1)
    return
  end
  if qualifier == 'plain' then
    jump(left, false, domain == 'inner', vim.v.count1)
    return
  end
  if qualifier == 'hint' then
    require('hop').hint_patterns({}, left)
    return
  end
end

M.Base = {}

function M.Base.new()
  return setmetatable({}, { __index = M.Base })
end

function M.Base:move_inner_inclusive(qualifier, mode)
  self:move_inner(qualifier, mode)
end

function M.Base:move_inner_exclusive(qualifier, mode)
  self:move_inner(qualifier, mode)
end
function M.Base:move_outer_inclusive(qualifier, mode)
  self:move_outer(qualifier, mode)
end

function M.Base:move_outer_exclusive(qualifier, mode)
  self:move_outer(qualifier, mode)
end

M.Char = M.Base.new()

function M.Char.new(char)
  return setmetatable({ char = char }, { __index = M.Char })
end

function M.Char:move_outer(qualifier, mode)
  local pattern = '[' .. self.char .. ']'
  char_move('outer', pattern, pattern, qualifier, mode)
end

function M.Char:move_inner(qualifier, mode)
  local pattern = '[' .. self.char .. ']'
  char_move('inner', pattern, pattern, qualifier, mode)
end

M.Pair = M.Base.new()

function M.Pair.new(left, right)
  return setmetatable(
    { left = left, right = right or left },
    { __index = M.Pair }
  )
end

function M.Pair:move_outer(qualifier, mode)
  char_move('outer', self.left, self.right, qualifier, mode)
end

function M.Pair:move_inner(qualifier, mode)
  char_move('inner', self.left, self.right, qualifier, mode)
end

M.Treesitter = M.Base.new()

function M.Treesitter.new(query)
  return setmetatable({ query = query }, { __index = M.Treesitter })
end

function M.Treesitter:move_outer(qualifier, mode)
  treesitter_move('outer', self.query, qualifier, mode)
end

function M.Treesitter:move_inner(qualifier, mode)
  treesitter_move('inner', self.query, qualifier, mode)
end

function M.Treesitter:select_outer(qualifier, mode)
  treesitter_select('outer', self.query, qualifier, mode)
end

function M.Treesitter:select_inner(qualifier, mode)
  treesitter_select('inner', self.query, qualifier, mode)
end

function M.Treesitter:exchange(qualifier, mode)
  treesitter_exchange(self.query, qualifier, mode)
end

M.Bigword = { __index = M.Base }
-- B, E

-- Bifword.select.outer.next
function M.Bigword:select_outer(qualifier, mode)
  if mode == 'x' then
    vim.fn.feedkeys(t '<esc>', 'n')
  end
  if qualifier == 'next' then
    vim.fn.feedkeys('E', 'n')
  elseif qualifier == 'previous' then
    vim.fn.feedkeys('B', 'n')
  elseif qualifier == 'hint' then
    -- TODO:
    -- require'hop-extensions'.hint_lines()
  end
  vim.fn.feedkeys('voW', 'n')
end

function M.Bigword:select_inner(qualifier, mode)
  if mode == 'x' then
    vim.fn.feedkeys(t '<esc>', 'n')
  end
  if qualifier == 'next' then
    vim.fn.feedkeys('E', 'n')
  elseif qualifier == 'previous' then
    vim.fn.feedkeys('B', 'n')
  elseif qualifier == 'hint' then
    -- TODO:
    -- require'hop-extensions'.hint_lines()
  end
  vim.fn.feedkeys('viW', 'n')
end

function M.Bigword:move_outer(qualifier, _)
  if qualifier == 'plain' then
    vim.fn.feedkeys('W', 'n')
    return
  end
  if qualifier == 'previous' then
    vim.fn.feedkeys('B', 'n')
    return
  end
  if qualifier == 'next' then
    vim.fn.feedkeys('W', 'n')
    return
  end
  if qualifier == 'hint' then
    require('hop-extensions').hint_lines()
    return
  end
end

-- TODO:
function M.Bigword:move_inner(qualifier, _)
  if qualifier == 'plain' then
    vim.fn.feedkeys('E', 'n')
    return
  end
  if qualifier == 'previous' then
    vim.fn.feedkeys('B', 'n')
    return
  end
  if qualifier == 'next' then
    vim.fn.feedkeys('E', 'n')
    return
  end
  if qualifier == 'hint' then
    require('hop-extensions').hint_lines()
    return
  end
end

local function line_bounds(inner, row)
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]
  if line == '' then
    return { 1, 1 }
  end
  if inner then
    local col_s = string.find(line, '[%S]')
    local col_e = string.find(line, '.[%s]*$')
    return { col_s, col_e }
  end
  return { 1, line:len() }
end

local function to_pos(row, col)
  col = col and col - 1
  return { row, col }
end

local function line_coord(row, bounds, selection_type)
  return { to_pos(row, bounds[1]), to_pos(row, bounds[2]), selection_type }
end

local function from_pos(pos)
  local row = pos[1]
  local col = pos[2] and pos[2] + 1
  return row, col
end

local function query_obj()
  local qualifier
  while true do
    local char = vim.fn.getchar()
    char = vim.fn.nr2char(char)
    if not qualifier and qualifiers[char] then
      qualifier = qualifiers[char]
    elseif queries[char] then
      qualifier = qualifier or qualifiers['']
      if qualifier then
        M.cache = { query = queries[char], qualifier = qualifier }
        return true
      else
        return false
      end
    else
      return false
    end
  end
end

local function line_find(fwd, inner, pos)
  local row, col = from_pos(pos)
  local max = vim.api.nvim_buf_line_count(0)
  local col_s, col_e = unpack(line_bounds(inner, row))
  local selection_type = inner and 'v' or 'V'
  if fwd then
    if col > col_e then
      row = row + 1
      if row > max then
        row = max
      end
      return line_coord(row, line_bounds(inner, row), selection_type)
    end
  else
    if col < col_s then
      row = row - 1
      if row < 1 then
        row = 1
      end
      return line_coord(row, line_bounds(inner, row), selection_type)
    end
  end
  return line_coord(row, { col_s, col_e }, selection_type)
end

local function line_select(qualifier, inner)
  if qualifier == 'plain' then
    local max = vim.api.nvim_buf_line_count(0)
    if vim.v.count == 0 then
      local pos = vim.api.nvim_win_get_cursor(0)
      return line_find(true, inner, pos)
    else
      local row = vim.v.count1
      if row > max then
        row = max
      end
      return line_coord(row, line_bounds(inner, row), inner and 'v' or 'V')
    end
  end
  if qualifier == 'next' then
    local pos = vim.api.nvim_win_get_cursor(0)
    local row = pos[1] + vim.v.count1
    local max = vim.api.nvim_buf_line_count(0)
    if row > max then
      row = max
    end
    return line_coord(row, line_bounds(inner, row), inner and 'v' or 'V')
  end
  if qualifier == 'previous' then
    local pos = vim.api.nvim_win_get_cursor(0)
    local row = pos[1] - vim.v.count1
    if row < 1 then
      row = 1
    end
    return line_coord(row, line_bounds(inner, row), inner and 'v' or 'V')
  end
end

M.Line = M.Base.new()

function M.Line:select_outer(qualifier, _)
  set_selection(unpack(line_select(qualifier, false)))
end

function M.Line:select_inner(qualifier, _)
  set_selection(unpack(line_select(qualifier, true)))
end

function M.Line:move_inner(qualifier)
  local pos = line_select(qualifier, true)[1]
  vim.api.nvim_win_set_cursor(0, pos)
end

function M.Line:move_outer(qualifier)
  local pos = line_select(qualifier, false)[1]
  vim.api.nvim_win_set_cursor(0, pos)
end

M.move_info = {
  move_inner_inclusive = {
    n = '<cmd>',
    x = '<cmd>',
    o = '<cmd>',
  },
  move_outer_inclusive = {
    n = '<cmd>',
    x = '<cmd>',
    o = '<cmd>',
  },
  move_inner_exclusive = {
    n = '<cmd>',
    x = '<cmd>',
    o = 'v<cmd>',
  },
  move_outer_exclusive = {
    n = '<cmd>',
    x = '<cmd>',
    o = 'v<cmd>',
  },
  exchange = { n = '<cmd>' },
}

function M.textobject(command_name, query_map, qualifier, mode)
  local query = queries[t(query_map)]
  query[command_name](query, qualifier, mode)
end

function M.operator(command_name, mode)
  if not query_obj() then
    return
  end
  local query = M.cache.query
  if not query[command_name] then
    return
  end
  M.repeat_register(function(mode0)
    query[command_name](query, 'previous', mode0)
  end, function(mode0)
    query[command_name](query, 'next', mode0)
  end)
  query[command_name](query, M.cache.qualifier, mode)
end

function M.setup(user_conf)
  conf = user_conf
  queries = {}
  for k, v in pairs(conf.queries) do
    queries[t(k)] = v
  end
  qualifiers = {}
  for k, v in pairs(conf.qualifiers) do
    qualifiers[t(k)] = v
  end
  for command_map, domain in pairs(conf.textobjects) do
    for mode in string.gmatch('ox', '.') do
      for qualifier_map, qualifier in pairs(conf.qualifiers) do
        for query_map, query in pairs(conf.queries) do
          local command_name = 'select_' .. domain
          if query[command_name] then
            vim.api.nvim_set_keymap(
              mode,
              command_map .. qualifier_map .. query_map,
              string.format(
                ':lua require("modules.flies").textobject(%q, %q, %q, %q)<cr>',
                'select_' .. domain,
                t(query_map),
                qualifier,
                mode
              ),
              { noremap = true }
            )
          end
        end
      end
    end
  end
  for command_map, domain in pairs(conf.operators) do
    for mode in string.gmatch('nox', '.') do
      local info = M.move_info[domain]
      if info then
        local call = info[mode]
        vim.api.nvim_set_keymap(
          mode,
          command_map,
          string.format(
            '%slua require("modules.flies").operator(%q, %q)<cr>',
            call,
            domain,
            mode
          ),
          { noremap = true }
        )
      end
    end
  end
end

return M
