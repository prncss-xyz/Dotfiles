-- small commands directly meant for bindings

local M = {}

local get_visual_selection = require('modules.utils').get_visual_selection

-- FIXME:
-- https://github.com/neovim/neovim/pull/12368

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

function M.peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(
    0,
    'textDocument/definition',
    params,
    preview_location_callback
  )
end

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
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

function M.tab()
  local r = require('luasnip').jump(1)
  if r then
    return
  end
  local neogen = require 'neogen'
  if neogen.jumpable() then
    -- there is no correspondig "jump_previous"
    neogen.jump_next()
    return
  end
  vim.fn.feedkeys(t '<Plug>(TaboutMulti)', '')
end

--- <s-tab> to jump to next snippet's placeholder
function M.s_tab()
  local r = require('luasnip').jump(-1)
  if r then
    return
  end
  vim.fn.feedkeys(t '<Plug>(TaboutBackMulti)', '')
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

function M.term_launch(args0)
  local args = { '-e', unpack(args0) }
  require('plenary.job')
    :new({
      command = vim.env.TERMINAL,
      args = args,
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
  -- needs this delay for proper display; is it dued to sway or foot
  M.term_launch { 'sh', '-c', 'sleep 0.1; nvim', current }
end

function M.searchCword(base)
  local word = vim.fn.expand '<cword>'
  local qs = require('modules.utils').encode_uri(word)
  M.open(base .. qs)
end

return M
