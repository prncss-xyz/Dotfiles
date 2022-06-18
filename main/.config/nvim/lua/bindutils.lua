-- small commands directly meant for bindings
local M = {}

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

-- https://vim.fandom.com/wiki/Unconditional_linewise_or_characterwise_paste
function M.paste(regname, paste_type, paste_cmd)
  local reg_type = vim.fn.getregtype(regname)
  vim.fn.setreg(regname, vim.fn.getreg(regname, nil, nil), paste_type)
  vim.cmd('normal! ' .. '"' .. regname .. paste_cmd)
  vim.fn.setreg(regname, vim.fn.getreg(regname, nil, nil), reg_type)
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
    vim.lsp.buf.formatting_sync(nil, nil)
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
      args = { vim.fn.expand('%', nil, nil) },
    })
    :start()
end

function M.xplr_launch()
  require('plenary').job
    :new({
      command = vim.env.TERMINAL,
      args = { 'xplr', vim.fn.expand('%', nil, nil) },
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
  local current = vim.fn.expand('%', nil, nil)
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
  local word = vim.fn.expand('<cword>', nil, nil)
  local qs = require('utils').encode_uri(word)
  M.open(base .. qs)
end

return M
