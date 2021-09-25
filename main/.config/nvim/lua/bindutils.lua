local m = {}


function m.toggle_cmp()
  local cmp = require 'cmp'
  if vim.fn.pumvisible() == 1 then
    cmp.close()
  else
    cmp.complete() -- not working
  end
end

function m.tab_complete()
  local cmp = require 'cmp'
  if vim.fn.pumvisible() == 1 then
    cmp.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }
    return
  end
  local r = require('luasnip').jump(1)
  if r then
    return
  end
  vim.fn.feedkeys(t '<Plug>(TaboutMulti)', '')
  -- emmet#moveNextPrev(0)
end

--- <s-tab> to jump to next snippet's placeholder
function m.s_tab_complete()
  local r = require('luasnip').jump(-1)
  if r then
    return
  end
  vim.fn.feedkeys(t '<Plug>(TaboutBackMulti)', '')
  -- emmet#moveNextPrev(1)
end

function m.mapBrowserSearch(register, prefix, help0, mappings)
  register { [prefix] = { name = help0 } }
  for abbr, value in pairs(mappings) do
    local url, help = unpack(value)
    register({
      [abbr] = { string.format('<cmd>lua require"browser".searchCword(%q)<cr>', url), help },
    }, {
      prefix = prefix,
    })
    register({
      [abbr] = {
        string.format('"zy<cmd>lua require"browser".searchZ(%q)<cr>', url),
        help,
      },
    }, {
      prefix = prefix,
      mode = 'v',
    })
  end
end

function m.onlyBuffer()
  local cur_buf = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if cur_buf ~= buf then
      pcall(vim.cmd, 'bd ' .. buf)
    end
  end
end

local alt_patterns = {
  { '(.+)%.test(%.[%w%d]+)$', '%1%2' },
  { '(.+)(%.[%w%d]+)$', '%1.test%2' },
}

local function get_alt(file)
  for _, pattern in ipairs(alt_patterns) do
    if file:match(pattern[1]) then
      return file:gsub(pattern[1], pattern[2])
    end
  end
end

function m.edit_alt()
  local alt = get_alt(vim.fn.expand '%')
  if alt then
    vim.cmd('e ' .. alt)
  end
end

function m.term()
  require('plenary.job')
    :new({
      command = vim.env.TERMINAL,
      args = {},
    })
    :start()
end

return m
