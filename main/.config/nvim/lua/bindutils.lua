local m = {}

-- TODO: toggle side panel

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function m.ro_quit_else(lhs, mode)
  if vim.bo.readonly then
    vim.cmd ':q'
  else
    vim.fn.feedkeys(lhs, mode)
  end
end

function m.repeatable(rhs)
  return string.format('%s<cmd>call repeat#set(%q, v:count)<cr>', rhs, t(rhs))
end

-- TODO:
m.redo_or_repeat = string.format(
  '%s<cmd>silent! call repeat#set(%q, v:count)<cr>',
  'u',
  ':redo\\<cr>'
)

function m.outliner()
  if vim.bo.filetype == 'markdown' then
    vim.cmd 'Toc'
  else
    vim.cmd 'SymbolsOutline'
  end
end

function m.project_files()
  if vim.fn.getcwd() == os.getenv 'HOME' .. '/Personal/neuron' then
    require('nononotes').prompt('edit', false, 'all')
    return
  end
  local ok = pcall(require('telescope.builtin').git_files)
  if not ok then
    require('telescope.builtin').find_files()
  end
end

function m.toggle_cmp()
  local cmp = require 'cmp'
  if cmp.visible() then
    cmp.close()
  else
    cmp.complete() -- not working
  end
end

function m.up()
  local cmp = require 'cmp'
  if cmp.visible() then
    cmp.select_prev_item()
    return
  end
  vim.fn.feedkeys(t '<up>', '')
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

function m.open_current()
  require('plenary.job')
    :new({
      command = 'opener',
      args = { vim.fn.expand '%' },
    })
    :start()
end

function m.dotfiles()
  require('telescope.builtin').git_files { cwd = os.getenv 'DOTFILES' }
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
