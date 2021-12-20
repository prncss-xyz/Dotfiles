local M = {}

local rep = {}

local conf

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
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

local function treesitter_move(domain, query, qualifier, mode)
  M.repeat_register(function()
    treesitter_move(domain, query, 'previous', mode)
  end, function()
    treesitter_move(domain, query, 'plain', mode)
  end)
  local query_string = string.format('@%s.%s', query, domain)
  if qualifier == 'previous' then
    require('nvim-treesitter.textobjects.move').goto_previous_start(
      query_string
    )
    return
  end
  if qualifier == 'plain' then
    require('nvim-treesitter.textobjects.move').goto_next_end(query_string)
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
local function jump(target, backward, till, n_times, mode)
  -- Construct search and highlight patterns
  local flags = backward and 'Wb' or 'W'
  if till then
    if backward then
      target = target .. '.'
    else
      target = '.' .. target
    end
  end
  if mode == 'o' and not backward then
    -- target = target .. '.'
  elseif not backward and till then
  else
    flags = flags .. 'e'
  end
  print('target: ', target)
  -- 00001111,aetsa

  -- TODO: highlights

  -- Make jump(s)
  for _ = 1, n_times do
    vim.fn.search(target, flags)
  end

  -- Open enough folds to show jump
  vim.cmd [[normal! zv]]
end

local function char_move(domain, left, right, qualifier, mode)
  M.repeat_register(function()
    char_move(domain, left, right, 'previous', mode)
  end, function()
    char_move(domain, left, right, 'plain', mode)
  end)
  if qualifier == 'previous' then
    jump(left, true, domain == 'inner', vim.v.count1, mode)
    return
  end
  if qualifier == 'plain' then
    jump(right, false, domain == 'inner', vim.v.count1, mode)
    return
  end
  if qualifier == 'hint' then
    require('hop').hint_patterns({}, left)
    return
  end
end

M.Char = {}

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

M.Pair = {}

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
  print 'caca'
  char_move('inner', self.left, self.right, qualifier, mode)
end

M.Treesitter = {}

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

M.commands_info = {
  select_inner = { modes = 'ox', call = ':' },
  select_outer = { modes = 'ox', call = ':' },
  move_inner = { modes = 'nox', callo = 'v<cmd>' },
  move_outer = { modes = 'nox', callo = 'v<cmd>' },
  exchange = { modes = 'n' },
}

function M.command(command_name, query_map, qualifier, mode)
  local query = conf.queries[query_map]
  query[command_name](query, qualifier, mode)
end

function M.setup(user_conf)
  conf = user_conf
  for command_map, command_name in pairs(conf.commands) do
    local command = M.commands_info[command_name]
    if command then
      for mode in string.gmatch(command.modes, '.') do
        for qualifier_map, qualifier in pairs(conf.qualifiers) do
          for query_map, query in pairs(conf.queries) do
            if query[command_name] then
              vim.api.nvim_set_keymap(
                mode,
                command_map .. qualifier_map .. query_map,
                string.format(
                  '%slua require("modules.flies").command(%q, %q, %q, %q)<cr>',
                  mode == 'o' and command.callo or command.call or '<cmd>',
                  command_name,
                  query_map,
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
  end
end

return M
