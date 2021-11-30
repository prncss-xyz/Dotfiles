local M = {}

-- TODO: words, lines
-- TODO: exchange, visual mode

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

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

function M.tobj(domain, qualifier, query, mode)
  if domain == 'inner' and query == 'string' then
    string_innerise(qualifier, mode)
    return
  end
  local query_string = string.format('@%s.%s', query, domain)
  local count1 = vim.fn.eval 'v:count1'
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

local conf = {
  queries = {
    Q = 'string',
    f = 'function',
    k = 'call',
    j = 'block',
    y = 'conditional',
    z = 'loop',
    -- c = 'comment', -- not working
  },
  qualifiers = {
    N = 'previous',
    n = 'next',
    h = 'hint',
  },
  domains = {
    i = 'inner',
    a = 'outer',
  },
}

local outer
local hint

local function exchange()
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
        res = outer
        res2 = outer
      end
      res = res .. char
    elseif conf.queries[char] then
      if res == '' then
        res = outer
        res2 = outer
      end
      res = res .. char
      res2 = res2 .. hint .. char
      return t(string.format('<Plug>(Exchange)%s<Plug>(Exchange)%s', res, res2))
    else
      return ''
    end
  end
end

function M.setup()
  for k, v in pairs(conf.domains) do
    if v == 'outer' then
      outer = k
      break
    end
  end
  for k, v in pairs(conf.qualifiers) do
    if v == 'hint' then
      hint = k
      break
    end
  end
  _G.Flies = { exchange = exchange }
  vim.api.nvim_set_keymap(
    'n',
    'ox',
    'v:lua.Flies.exchange()',
    { expr = true, noremap = false }
  )
  for _, mode in ipairs { 'o', 'x' } do
    for query_char, query in pairs(conf.queries) do
      for qualifier_char, qualifier in pairs(conf.qualifiers) do
        for domain_char, domain in pairs(conf.domains) do
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
