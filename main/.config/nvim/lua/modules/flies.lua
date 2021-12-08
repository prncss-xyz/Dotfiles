local M = {}

-- TODO: cancelation mechanisme for hinted textobjects
-- TODO: linewiseness workaround (cf. anywise_reg)

local conf = {
  domains = {
    i = 'inner',
    a = 'outer',
  },
}

local outer_char
local hint_char
local previous_char

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function find(a, val)
  for k, v in pairs(a) do
    if v == val then
      return k
    end
  end
end

-- FIXME: not working at all
local function string_innerise(qualifier, mode)
  -- FIXME: get only cursor position before selection
  M.tobj('outer', qualifier, 'string', mode)
  local pos = vim.api.nvim_buf_get_mark(0, '[')
  -- require('modules.utils').dump(pos)
  local line_left = vim.fn.getline(pos[1])
  print(line_left)
  local char_left = line_left:sub(pos[2] + 1, pos[2] + 1)
  local len
  if char_left == '[[' then
    len = 2
  else
    len = 1
  end
  print(len)
end

local rep = {}

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

function M.move(domain, query, direction)
  M.repeat_register(function()
    M.move(domain, query, -1)
  end, function()
    M.move(domain, query, 1)
  end)
  local query_string = string.format('@%s.%s', query, domain)
  if direction == -1 then
    require('nvim-treesitter.textobjects.move').goto_previous_start(
      query_string
    )
    return
  end
  if direction == 1 then
    require('nvim-treesitter.textobjects.move').goto_next_end(query_string)
    return
  end
  if direction == 0 then
    require('hop-extensions').hint_textobjects(
      string.format('%s.%s', query, domain)
    )
    return
  end
end

function M.tobj(domain, qualifier, query, mode)
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

function M.exchange()
  local res = ''
  local res2 = ''
  while true do
    local char = vim.fn.getchar()
    -- Terminate if input is `<Esc>`
    if char == 27 then
      return
    end
    if type(char) == 'number' then
      char = vim.fn.nr2char(char)
    end
    print(char)
    if conf.domains[char] then
      if res:len() > 0 then
        return ''
      end
      res = res .. char
      res2 = res2 .. char
    elseif conf.qualifiers[char] then
      if res == '' then
        res = outer_char
        res2 = outer_char
        res = res .. char
      end
    elseif conf.queries[char] then
      if res == '' then
        res = outer_char
        res2 = outer_char
      end
      res = res .. char
      res2 = res2 .. hint_char .. char
      return t(string.format('<Plug>(Exchange)%s<Plug>(Exchange)%s', res, res2))
    else
      return ''
    end
  end
end

function M.lightspeed_F()
  require('modules.flies').repeat_register(function()
    require('lightspeed').ft:go(true, false, 'cold')
  end, function()
    require('lightspeed').ft:go(false, false, 'cold')
  end)
  require('lightspeed').ft:go(true, false)
end

function M.lightspeed_f()
  require('modules.flies').repeat_register(function()
    require('lightspeed').ft:go(true, false, 'cold')
  end, function()
    require('lightspeed').ft:go(false, false, 'cold')
  end)
  require('lightspeed').ft:go(false, false)
end

function M.lightspeed_T()
  require('modules.flies').repeat_register(function()
    require('lightspeed').ft:go(true, true, 'cold')
  end, function()
    require('lightspeed').ft:go(false, true, 'cold')
  end)
  require('lightspeed').ft:go(true, true)
end

function M.lightspeed_t()
  require('modules.flies').repeat_register(function()
    require('lightspeed').ft:go(true, true, 'cold')
  end, function()
    require('lightspeed').ft:go(false, true, 'cold')
  end)
  require('lightspeed').ft:go(false, true)
end

local fwd_last_dir

function M.fwd(backwards, before, cl, cr, repeating)
  require('modules.flies').repeat_register(function()
    M.fwd(true, before, cl, cr, true)
  end, function()
    M.fwd(false, before, cl, cr, true)
  end)
  print(repeating, fwd_last_dir, backwards)
  if repeating and (fwd_last_dir == backwards) then
    require('lightspeed').ft:go(false, before, 'cold')
    return
  end
  local char = backwards and cl or cr
  vim.fn.feedkeys(
    t(
      string.format(
        "<cmd>lua require('lightspeed').ft:go(%s, %s)<cr>%s",
        backwards,
        before,
        char
      )
    )
  )
  fwd_last_dir = backwards
end

function M.setup(user_conf)
  conf = vim.tbl_extend('force', conf, user_conf)
  hint_char = find(conf.qualifiers, 'hint')
  previous_char = find(conf.qualifiers, 'previous')
  outer_char = find(conf.domains, 'outer')

  for _, c in ipairs(conf.chars) do
    local cl, cr
    if type(c) == 'table' then
      cl, cr = unpack(c)
    else
      cl, cr = c, c
    end
    for mode in string.gmatch('nox', '.') do
      vim.api.nvim_set_keymap(
        mode,
        conf.move_outer .. cr,
        string.format(
          '<cmd>lua require"modules.flies".fwd(false, false, %q, %q)<cr>',
          cl,
          cr
        ),
        {}
      )
      vim.api.nvim_set_keymap(
        mode,
        conf.move_outer .. cl,
        string.format(
          '<cmd>lua require"modules.flies".fwd(false, false, %q, %q)<cr>',
          cr,
          cl
        ),
        {}
      )
      vim.api.nvim_set_keymap(
        mode,
        conf.move_inner .. cr,
        string.format(
          '<cmd>lua require"modules.flies".fwd(false, true, %q, %q)<cr>',
          cl,
          cr
        ),
        {}
      )
      vim.api.nvim_set_keymap(
        mode,
        conf.move_inner .. cl,
        string.format(
          '<cmd>lua require"modules.flies".fwd(false, true, %q, %q)<cr>',
          cr,
          cl
        ),
        {}
      )
      vim.api.nvim_set_keymap(
        mode,
        conf.move_outer .. hint_char .. cr,
        '<cmd>lua require"hop".hint_patterns({}, "[' .. cr .. ']")<cr>',
        {}
      )
      vim.api.nvim_set_keymap(
        mode,
        conf.move_inner .. hint_char .. cr,
        '<cmd>lua require"hop".hint_patterns({ direction = require"hop.hint".HintDirection.BEFORE_CURSOR}, "[' -- FIXME: `direction` has no effect
          .. cr
          .. ']")<cr>',
        {}
      )
      vim.api.nvim_set_keymap(
        mode,
        conf.move_outer .. hint_char .. cl,
        '<cmd>lua require"hop".hint_patterns({}, "[' .. cl .. ']")<cr>',
        {}
      )
      vim.api.nvim_set_keymap(
        mode,
        conf.move_inner .. hint_char .. cl,
        '<cmd>lua require"hop".hint_patterns({ direction = require"hop.hint".HintDirection.BEFORE_CURSOR}, "[' -- FIXME: `direction` has no effect
          .. cl
          .. ']")<cr>',
        {}
      )
    end
  end

  for k, v in pairs(conf.qualifiers) do
    if v == 'hint' then
      hint_char = k
      break
    end
  end
  for k, v in pairs(conf.qualifiers) do
    if v == 'previous' then
      previous_char = k
      break
    end
  end
  for k, v in pairs(conf.domains) do
    if v == 'outer' then
      outer_char = k
      break
    end
  end
  vim.api.nvim_set_keymap(
    'n',
    conf.exchange,
    "v:lua.require'modules.flies'.exchange()",
    { expr = true, noremap = false }
  )
  for query_char, query in pairs(conf.queries) do
    for domain_char, domain in pairs { [conf.move_outer] = 'outer', [conf.move_inner] = 'inner' } do
      for _, mode in ipairs { 'n', 'o', 'x' } do
        vim.api.nvim_set_keymap(
          mode,
          domain_char .. query_char,
          string.format(
            '<cmd>lua require("modules.flies").move(%q, %q, 1)<cr>',
            domain,
            query
          ),
          {}
        )
        vim.api.nvim_set_keymap(
          mode,
          domain_char .. previous_char .. query_char,
          string.format(
            '<cmd>lua require("modules.flies").move(%q, %q, -1)<cr>',
            domain,
            query
          ),
          {}
        )
        if hint_char then
          vim.api.nvim_set_keymap(
            mode,
            domain_char .. hint_char .. query_char,
            string.format(
              '<cmd>lua require("modules.flies").move(%q, %q, 0)<cr>',
              domain,
              query
            ),
            {}
          )
        end
      end
    end
    for domain_char, domain in pairs(conf.domains) do
      for _, mode in ipairs { 'o', 'x' } do
        for qualifier_char, qualifier in pairs(conf.qualifiers) do
          vim.api.nvim_set_keymap(
            mode,
            domain_char .. query_char,
            string.format(
              ':lua require"modules.flies".tobj(%q, %q, %q, %q)<cr>',
              domain,
              'plain',
              query,
              mode
            ),
            {}
          )
          vim.api.nvim_set_keymap(
            mode,
            domain_char .. qualifier_char .. query_char,
            string.format(
              ':lua require"modules.flies".tobj(%q, %q, %q, %q)<cr>',
              domain,
              qualifier,
              query,
              mode
            ),
            {}
          )
        end
      end
    end
  end
end

return M
