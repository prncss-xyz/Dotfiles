-- small commands directly meant for bindings
local M = {}

local utils = require 'utils'
local first_cb = utils.first_cb
local all_cb = utils.all_cb
local lazy = utils.lazy
local lazy_req = utils.lazy_req

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.keys(keys)
  vim.api.nvim_feedkeys(t(keys), 'n', true)
end

function M.normal(keys)
  vim.cmd('normal! ' .. keys)
end

function M.plug(name)
  local keys = '<Plug>' .. name
  vim.api.nvim_feedkeys(t(keys), 'm', true)
end


function M.static_yank(keys)
  local cursor = vim.fn.getpos '.'
  vim.defer_fn(function()
    M.keys(keys)
    vim.fn.setpos('.', cursor)
  end, 1)
end

function M.asterisk_z()
  M.plug '(asterisk-z*)'
  -- vim.fn.feedkeys(t '<plug>(asterisk-z*)')
  require('flies.objects.search').set_search(true)
  require('hlslens').start()
end

function M.asterisk_gz()
  M.plug '(asterisk_gz*)'
  require('flies.objects.search').set_search(true)
  require('hlslens').start()
end

vim.api.nvim_set_keymap(
  'n',
  '<Plug>(u-hop-char2)',
  '<cmd>lua require"hop".hint_char2()<cr>',
  { noremap = true }
)
vim.api.nvim_set_keymap(
  'n',
  '<Plug>(u-hop-char1)',
  '<cmd>lua require"hop".hint_char1()<cr>',
  { noremap = true }
)
vim.api.nvim_set_keymap(
  'o',
  '<Plug>(u-hop-char2)',
  ':<c-u>lua require"hop".hint_char2()<cr>',
  { noremap = true }
) -- FIXME:
vim.api.nvim_set_keymap(
  'o',
  '<Plug>(u-hop-char1)',
  ':<c-u>lua require"hop".hint_char1()<cr>',
  { noremap = true }
) -- FIXME:
vim.api.nvim_set_keymap(
  'x',
  '<Plug>(u-hop-char2)',
  '<cmd>lua require"hop".hint_char2()<cr>',
  { noremap = true }
)
vim.api.nvim_set_keymap(
  'x',
  '<Plug>(u-hop-char1)',
  '<cmd>lua require"hop".hint_char1()<cr>',
  { noremap = true }
)

function M.hop12()
  local char = vim.fn.getchar()
  char = vim.fn.nr2char(char)
  if char == t '<esc>' then
    return
  end
  local one_char = false
  if string.find(',=;+-*/_', char, 1, true) then
    one_char = true
  end
  if vim.bo.filetype == 'markdown' and string.find('.:', char, 1, true) then
    one_char = true
  end
  if one_char then
    vim.fn.feedkeys(t '<Plug>(u-hop-char1)' .. char, 'm')
  else
    vim.fn.feedkeys(t '<Plug>(u-hop-char2)' .. char, 'm')
  end
end

-- https://github.com/ibhagwan/fzf-lua/blob/f7f54dd685cfdf5469a763d3a00392b9291e75f2/lua/fzf-lua/utils.lua#L372-L404
function M.get_visual_selection()
  -- this will exit visual mode
  -- use 'gv' to reselect the text
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' or mode == '' then
    -- if we are in visual mode use the live position
    _, csrow, cscol, _ = unpack(vim.fn.getpos '.')
    _, cerow, cecol, _ = unpack(vim.fn.getpos 'v')
    if mode == 'V' then
      -- visual line doesn't provide columns
      cscol, cecol = 0, 999
    end
    -- exit visual mode
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes('<Esc>', true, false, true),
      'n',
      true
    )
  else
    -- otherwise, use the last known visual position
    _, csrow, cscol, _ = unpack(vim.fn.getpos "'<")
    _, cerow, cecol, _ = unpack(vim.fn.getpos "'>")
  end
  -- swap vars if needed
  if cerow < csrow then
    csrow, cerow = cerow, csrow
  end
  if cecol < cscol then
    cscol, cecol = cecol, cscol
  end
  local lines = vim.fn.getline(csrow, cerow)
  -- local n = cerow-csrow+1
  local n = M.tbl_length(lines)
  if n <= 0 then
    return ''
  end
  lines[n] = string.sub(lines[n], 1, cecol)
  lines[1] = string.sub(lines[1], cscol)
  return table.concat(lines, '\n')
end

-- https://vim.fandom.com/wiki/Unconditional_linewise_or_characterwise_paste
function M.paste(regname, paste_type, paste_cmd)
  local reg_type = vim.fn.getregtype(regname)
  vim.fn.setreg(regname, vim.fn.getreg(regname), paste_type)
  vim.cmd('normal! ' .. '"' .. regname .. paste_cmd)
  vim.fn.setreg(regname, vim.fn.getreg(regname), reg_type)
end

function M.telescope_symbols_md_lsp()
  if vim.bo.filetype == 'markdown' then
    require('telescope').extensions.heading.heading()
  else
    require('telescope.builtin').lsp_document_symbols()
  end
end

function M.lsp_format()
  if false then
    local format = vim.b.format
    if format then
      format()
    end
  else
    vim.lsp.buf.formatting_sync()
  end
end

local recompose = require('flies.move_again').recompose

M.scroll_up, M.scroll_down = recompose(function()
  require('neoscroll').scroll(-0.9, true, 250)
end, function()
  require('neoscroll').scroll(0.9, true, 250)
end)

M.previous_reference, M.next_reference = recompose(function()
  require('illuminate').next_reference { wrap = true, reverse = true }
end, function()
  require('illuminate').next_reference { wrap = true }
end)

M.mark_previous, M.mark_next = recompose(function()
  require('marks').bookmark_state:previous()
end, function()
  require('marks').bookmark_state:next()
end)

local function mv_bookmark(i)
  return recompose(function()
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

M.all_bookmarks_previous, M.all_bookmarks_next = recompose(function()
  require('marks').prev_bookmark()
end, function()
  require('marks').next_bookmark()
end)

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

function M.repeatable_cmd(rhs) end

function M.outliner()
  if vim.bo.filetype == 'markdown' then
    require('modules.toggler').open('Toc', nil)
    vim.cmd 'Toc'
  else
    require('modules.toggler').cb('SymbolsOutlineOpen', 'SymbolsOutlineClose')
  end
end

function M.term()
  require('plenary').job
    :new({
      command = vim.env.TERMINAL,
      args = {},
    })
    :start()
end

function M.open_current()
  require('plenary').job
    :new({
      command = 'xdg-open',
      args = { vim.fn.expand '%' },
    })
    :start()
end

function M.xplr_launch()
  require('plenary').job
    :new({
      command = vim.env.TERMINAL,
      args = { 'xplr', vim.fn.expand '%' },
    })
    :start()
end

function M.docu_current()
  require('plenary').job
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
  require('plenary').job
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
  require('plenary').job
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
  local qs = require('utils').encode_uri(word)
  M.open(base .. qs)
end

return M
