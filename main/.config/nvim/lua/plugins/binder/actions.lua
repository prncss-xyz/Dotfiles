local M = {}

local utils = require 'plugins.binder.utils'

function M.asterisk_z()
  utils.plug '(asterisk-z*)'
  -- vim.fn.feedkeys(t '<plug>(asterisk-z*)')
  require('flies.objects.search').set_search(true)
  require('hlslens').start()
end

function M.asterisk_gz()
  utils.plug '(asterisk_gz*)'
  require('flies.objects.search').set_search(true)
  require('hlslens').start()
end

function M.menu_previous()
  local cmp = require 'cmp'
  if cmp.visible() then
    cmp.select_prev_item()
  else
    utils.keys '<up>'
  end
end

function M.menu_next()
  local cmp = require 'cmp'
  if cmp.visible() then
    cmp.select_next_item()
  else
    utils.keys '<down>'
  end
end

M.jump_previous = utils.first_cb(
  function()
    print 'previous'
  end,
  utils.lazy_req('luasnip', 'jump', -1),
  utils.lazy_req('tabout', 'taboutBack')
  -- util.lazy_req('tabout', 'taboutBackMulti')
)

M.jump_next = utils.first_cb(
  function()
    print 'next'
  end,
  utils.lazy_req('luasnip', 'jump', 1),
  utils.lazy_req('tabout', 'tabout')
  -- util.lazy_req('tabout', 'taboutMulti')
)

function M.hop12()
  local char = vim.fn.nr2char(vim.fn.getchar())
  if char == utils.t '<esc>' then
    return
  end
  if string.find(char, '[%p]') then
    vim.fn.feedkeys(
      utils.t('<cmd>lua require "hop".hint_char1()<cr>' .. char),
      'm'
    )
  else
    vim.fn.feedkeys(
      utils.t('<cmd>lua require "hop".hint_char2()<cr>' .. char),
      'm'
    )
  end
end

return M
