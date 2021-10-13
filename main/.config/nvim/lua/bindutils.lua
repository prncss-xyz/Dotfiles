local m = {}

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function m.toggle_cmp()
  local cmp = require 'cmp'
  if cmp.visible() then
    cmp.close()
  else
    cmp.complete() -- not working
  end
end

function m.tab_complete()
  local cmp = require 'cmp'
  if cmp.visible() then
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

function m.spell_next(dir)
  local word = vim.fn.expand '<cword>'
  local res = vim.fn.spellbadword(word)
  if dir == -1 then
    vim.cmd 'normal! [s'
  elseif res[1]:len() == 0 then
    vim.cmd 'normal! ]s'
  end
  require('telescope.builtin').spell_suggest(
    require('telescope.themes').get_cursor {}
  )
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

function m.term_launch(args)
  local args = { '-e', unpack(args) }
  require('plenary.job')
    :new({
      command = vim.env.TERMINAL,
      args = args,
    })
    :start()
end

function m.docu_current()
  require('plenary.job')
    :new({
      command = vim.env.TERMINAL,
      args = {
        '--class',
        'launcher',
        '-e',
        'fdocu',
        vim.bo.filetype,
      },
    })
    :start()
end

function m.edit_current()
  local current = vim.fn.expand '%'
  m.term_launch { 'nvim', current }
end

function m.searchCword(base)
  local word = vim.fn.expand '<cword>'
  local qs = require('utils').encode_uri(word)
  m.open(base .. qs)
end

return m
