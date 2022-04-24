local legendary = require 'legendary'
local a = require('bindings.parameters').a -- actions: jump, editor etc
local d = require('bindings.parameters').d -- domains: diagnostic, git etc

local utils = require 'utils'
local feed_plug_cb = utils.feed_plug_cb
local feed_vim_cb = utils.feed_vim_cb
local first_cb = utils.first_cb
local all_cb = utils.all_cb
local lazy = utils.lazy
local lazy_req = utils.lazy_req

local count = 0

local rep = require('bindutils').repeatable

local function replug(t)
  if type(t) == 'string' then
    t = { t }
  end
  t.noremap = false
  t[1] = rep('<plug>' .. t[1])
  return t
end

local function repeatable_cmd(rhs, opts)
  count = count + 1
  local map = string.format('(u-%i)', count)
  vim.api.nvim_set_keymap(
    'n',
    '<Plug>' .. map,
    '<cmd>' .. rhs .. '<cr>',
    opts or {}
  )
  return replug(map)
end

local function dual_key(key)
  return 'p' .. key
end

local function insert_u(t1, v)
  local res = vim.tbl_extend('force', t1, {})
  table.insert(res, v)
  return res
end

local function chars(str)
  local res = {}
  for char in string.gmatch(str, '.') do
    table.insert(res, char)
  end
  return res
end

local dual_sym = {}
local desc_sym = {}

local function bind_keymap(acc, key)
  local opts = {}
  local desc_str = table.concat(acc.descs, ' ')
  if acc.cmd then
    if desc_str == '' then
      desc_str = acc[1]
    end
    acc[1] = string.format(':%s<cr>', acc[1])
  end
  local modes = acc.modes or acc.mode or 'n'
  legendary.bind_keymap {
    acc.keys .. key,
    acc[1],
    description = desc_str,
    mode = chars(modes),
    opts = opts,
  }
end

local function b(args)
  return function(acc, key)
    acc = vim.tbl_extend('force', acc, args)
    acc.descs = insert_u(acc.descs, acc.desc)
    bind_keymap(acc, key)
  end
end

local function dual(args)
  return function(acc, key)
    local desc_previous, desc_next
    if type(args.desc) == 'string' then
      desc_previous = 'previous ' .. args.desc
      desc_next = 'next ' .. args.desc
    elseif type(args.desc) == 'table' then
      desc_previous = args.desc[1]
      desc_next = args.desc[2]
    end

    local previous = vim.tbl_extend('force', args, acc)
    table.remove(previous, 2)
    previous.descs = insert_u(previous.descs, desc_previous)
    bind_keymap(previous, dual_key(key))

    local next = vim.tbl_extend('force', args, acc)
    table.remove(next, 1)
    next.descs = insert_u(next.descs, desc_next)
    bind_keymap(next, key)
  end
end

local function modes(args)
  return function(acc, key)
    local descs = insert_u(acc.descs, args[desc_sym])
    for k, v in pairs(args) do
      if type(k) == 'string' then
        local acc0 = vim.tbl_extend('force', acc, { mode = k, descs = descs })
        v(acc0, key)
      end
    end
  end
end

local function keys(args)
  return function(acc, key)
    local descs = insert_u(acc.descs, args[desc_sym])
    local acc0 = vim.tbl_extend(
      'force',
      acc,
      { descs = descs, keys = acc.keys .. key }
    )
    local s = args[dual_sym]
    if s then
      local acc1 = vim.tbl_extend('force', acc, { descs = descs })
      s(acc1, dual_key(key))
    end
    for k, v in pairs(args) do
      if type(k) == 'string' then
        v(acc0, k)
      end
    end
  end
end

local function bind(cb)
  cb({ keys = '', descs = {} }, '')
end

bind(keys {
  ['<c-space>'] = b {
    legendary.find,
    desc = 'legendary find',
  },
  [a.editor] = keys {
    [d.diagnostic] = dual {
      require('modules.toggler').cb(
        'Trouble document_diagnostics',
        'TroubleClose'
      ),
      require('modules.toggler').cb(
        'Trouble workspace_diagnostics',
        'TroubleClose'
      ),
      desc = {
        'trouble lsp document diagnostics',
        'trouble lsp workspace diagnostics',
      },
    },
    c = keys {
      [desc_sym] = 'split',
      [dual_sym] = b { lazy_req('split', 'close'), desc = 'close' },
      s = b { lazy_req('split', 'open_lsp'), desc = 'lsp' },
      q = b { lazy_req('split', 'open_lsp'), desc = 'caca', modes = 'nx' },
      r = modes {
        n = b { lazy_req('split', 'pop', { target = 'here' }, 'n') },
        x = b { lazy_req('split', 'pop', { target = 'here' }, 'x') },
        [desc_sym] = 'pop',
      },
      o = modes {
        n = b { lazy_req('split', 'open', {}, 'n') },
        x = b { lazy_req('split', 'open', {}, 'x') },
        [desc_sym] = 'open',
      },
    },
    [d.dap] = b {
      require('modules.toggler').cb(
        lazy_req('dapui', 'open'),
        lazy_req('dapui', 'close')
      ),
      'toggle dapui',
    },
    [d.bookmark] = b {
      require('modules.toggler').cb(function()
        require('marks').bookmark_state:all_to_list 'quickfixlist'
        vim.cmd 'Trouble quickfix'
      end, 'TroubleClose'),
      desc = 'quickfixlist',
    },
  },
})
