-- small commands directly meant for bindings
local M = {}

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- FIXME:
-- https://github.com/neovim/neovim/pull/12368

local function pre_jump()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_set_mark(0, "'", pos[1], pos[2], {})
end

local qualifiers = { 'p', 'n', 'h' }
for i, v in ipairs(qualifiers) do
  qualifiers[i] = t(v)
end

local cache

local function meta_move(char, qualifier, mode)
  print(char, qualifier, mode)
  if mode == 'n' then
    require('flies').move(char, qualifier, 'outer', true, mode)
    return
  end
  if mode == 'o' then
    require('flies').move(char, qualifier, 'outer', qualifier == 'next', mode)
    return
  end
  if mode == 'x' then
    require('flies').move(
      char,
      qualifier,
      'outer',
      qualifier == 'previous',
      mode
    )
    return
  end
end

function M.meta_move(mode)
  local qualifier, char = require('flies').query_obj()
  if not qualifier then
    return
  end
  if qualifier == 'plain' then
    qualifier = 'next'
  end
  require('flies').repeat_register(function(mode0)
    meta_move(char, 'previous', mode0)
  end, function(mode0)
    meta_move(char, 'next', mode0)
  end)
  meta_move(char, qualifier, mode)
end

local function query_obj()
  local qualifier
  while true do
    local char = vim.fn.getchar()
    char = vim.fn.nr2char(char)
    if not qualifier and vim.tbl_contains(qualifiers, char) then
      qualifier = char
    elseif char == t '<esc>' then
      return false
    else
      qualifier = qualifier or ''
      cache = { query = char, qualifier = qualifier }
      return true
    end
  end
end

function M.tobj_extreme()
  if not query_obj() then
    return
  end
  local query = cache.query
  local outer
  if vim.tbl_contains({ t '<cr>', 'e' }, query) then
    outer = 'i'
  else
    outer = 'a'
  end
  pre_jump()
  local r = cache.qualifier == 'p' and 'o' or ''
  if outer == 'i' then
    vim.api.nvim_feedkeys('va' .. query .. 'o' .. t '<esc>', '', false)
  end
  vim.api.nvim_feedkeys('v' .. outer .. query .. r .. t '<esc>', '', false)
end

function M.pre()
  local prefix = ''
  local p0 = vim.fn.getpos 'v'
  local p1 = vim.fn.getpos '.'
  if p0[2] < p1[2] or p0[2] == p1[2] and p0[3] < p1[3] then
    prefix = 'o'
  end
  local postfix = true and 'i' or 'I' -- TODO: detect selection module
  vim.fn.feedkeys(t(prefix .. '<esc>' .. postfix))
end

function M.post()
  local prefix = ''
  local p0 = vim.fn.getpos 'v'
  local p1 = vim.fn.getpos '.'
  local postfix = true and 'a' or 'A' -- TODO: detect selection mode
  if p0[2] > p1[2] or p0[2] == p1[2] and p0[3] > p1[3] then
    prefix = 'o'
  end
  vim.fn.feedkeys(t(prefix .. '<esc>' .. postfix))
end

local search_forward

function M.search(forward)
  search_forward = forward
  require('flies').repeat_register(function()
    M.n(false)
  end, function()
    M.n(true)
  end)
  if forward then
    vim.fn.feedkeys('/', 'n')
  else
    vim.fn.feedkeys('?', 'n')
  end
end

function M.search_asterisk(exact)
  search_forward = true
  require('flies').repeat_register(function()
    M.n(false)
  end, function()
    M.n(true)
  end)
  if exact then
    vim.fn.feedkeys(t '<plug>(asterisk-z*)')
  else
    vim.fn.feedkeys(t '<plug>(asterisk-gz*)')
  end
  require('hlslens').start()
end

function M.n(forward)
  require('flies').repeat_register(function()
    M.n(false)
  end, function()
    M.n(true)
  end)
  if forward == search_forward then
    vim.fn.feedkeys(vim.v.count1 .. 'n', 'n')
  else
    vim.fn.feedkeys(vim.v.count1 .. 'N', 'n')
  end
  require('hlslens').start()
end

local repeatable = require('flies').repeatable

M.scroll_up, M.scroll_down = repeatable(function()
  require('neoscroll').scroll(-0.9, true, 250)
end, function()
  require('neoscroll').scroll(0.9, true, 250)
end)

M.previous_reference, M.next_reference = repeatable(function()
  require('illuminate').next_reference { wrap = true, reverse = true }
end, function()
  require('illuminate').next_reference { wrap = true }
end)

M.mark_previous, M.mark_next = repeatable(function()
  require('marks').bookmark_state:previous()
end, function()
  require('marks').bookmark_state:next()
end)

local function mv_bookmark(i)
  return repeatable(function()
    require('marks').bookmark_state:previous(i)
  end, function()
    require('marks').bookmark_state:next(i)
  end)
end

function M.bookmark_previous(i)
  local cb, _ = mv_bookmark(i)
  return cb
end

function M.bookmark_next(i)
  local _, cb = mv_bookmark(i)
  return cb
end

M.all_bookmarks_previous, M.all_bookmarks_next = repeatable(function()
  require('marks').prev_bookmark()
end, function()
  require('marks').next_bookmark()
end)

local function preview_location_callback(_, method, result)
  if result == nil or vim.tbl_isempty(result) then
    vim.lsp.log.info(method, 'No location found')
    return nil
  end
  if vim.tbl_islist(result) then
    vim.lsp.util.preview_location(result[1])
  else
    vim.lsp.util.preview_location(result)
  end
end

function M.ro_quit_else(lhs, mode)
  if vim.bo.readonly then
    vim.cmd ':q'
  else
    vim.fn.feedkeys(lhs, mode)
  end
end

function M.repeatable(rhs)
  return string.format('%s<cmd>call repeat#set(%q, v:count)<cr>', rhs, t(rhs))
end

function M.outliner()
  if vim.bo.filetype == 'markdown' then
    require('modules.toggler').open('Toc', nil)
    vim.cmd 'Toc'
  else
    require('modules.toggler').open('SymbolsOutlineOpen', 'SymbolsOutlineClose')
  end
end

function M.project_files()
  if vim.fn.getcwd() == os.getenv 'HOME' .. '/Personal/neuron' then
    require('nononotes').prompt('edit', false, 'all')
    return
  end
  local ok = pcall(require('telescope.builtin').git_files)
  if ok then
    return
  end
  require('telescope.builtin').find_files()
end

function M.cmp_toggle()
  local cmp = require 'cmp'
  if cmp.visible() then
    cmp.close()
  else
    cmp.complete() -- not working
  end
end

function M.up()
  local cmp = require 'cmp'
  if cmp.visible() then
    cmp.select_prev_item()
    return
  end
  vim.fn.feedkeys(t '<up>', '')
end

function M.cmp_confirm()
  local cmp = require 'cmp'
  if cmp.visible() then
    cmp.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }
    return
  end
end

--- <s-tab> to jump to next snippet's placeholder
function M.s_tab()
  local r = require('luasnip').jump(-1)
  if r then
    return
  end
  -- vim.fn.feedkeys(t '<Plug>(TaboutBackMulti)', '')
  vim.fn.feedkeys(t '<Plug>(TaboutBack)', '')
end

function M.tab()
  local r = require('luasnip').jump(1)
  if r then
    return
  end
  -- vim.fn.feedkeys(t '<Plug>(TaboutMulti)', '')
  vim.fn.feedkeys(t '<Plug>(Tabout)', '')
end

function M.spell_next(dir)
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

function M.onlyBuffer()
  local cur_buf = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if cur_buf ~= buf then
      pcall(vim.cmd, 'bd ' .. buf)
    end
  end
end

local alt_patterns = {
  { '(.+)_spec.lua$', '%1.lua' },
  { '(.+).lua$', '%1_spec.lua' },
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

function M.edit_alt()
  local alt = get_alt(vim.fn.expand '%')
  if alt then
    vim.cmd('e ' .. alt)
  end
end

function M.term()
  require('plenary.job')
    :new({
      command = vim.env.TERMINAL,
      args = {},
    })
    :start()
end

function M.open_current()
  require('plenary.job')
    :new({
      command = 'xdg-open',
      args = { vim.fn.expand '%' },
    })
    :start()
end

function M.xplr_launch()
  require('plenary.job')
    :new({
      command = vim.env.TERMINAL,
      args = { 'xplr', vim.fn.expand '%' },
    })
    :start()
end

function M.dotfiles()
  require('telescope.builtin').git_files { cwd = os.getenv 'DOTFILES' }
end

function M.docu_current()
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

function M.edit_current()
  local current = vim.fn.expand '%'
  require('plenary.job')
    :new({
      command = vim.env.TERMINAL,
      -- args = {'-e', 'nvim', current},
      -- without sh, nvim occupies only small portion of terminal
      args = { '-e', 'sh', '-c', 'nvim ' .. current },
    })
    :start()
end

function M.reset_editor()
  local current = vim.fn.expand '%'
  require('plenary.job')
    :new({
      command = 'swaymsg',
      -- args = {'-e', 'nvim', current},
      -- without sh, nvim occupies only small portion of terminal
      args = { 'exec', vim.env.TERMINAL, ' -e', 'sh -c nvim' },
    })
    :sync()
  vim.cmd 'quitall'
end

function M.searchCword(base)
  local word = vim.fn.expand '<cword>'
  local qs = require('modules.utils').encode_uri(word)
  M.open(base .. qs)
end

return M
