local M = {}

local function f1()
  print 'A'
end

local function f2()
  print 'b'
end

local function map_ist()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local modes = binder.modes
  local util = require 'plugins.binder.util'
  local lazy_req = util.lazy_req
  binder.bind(modes {
    t = keys {
      ['<c-w>n'] = b {
        '<C-\\><C-n>',
      },
    },
    is = keys {
      ['<c-space>'] = b { '<space><left>' },
      ['<s-space>'] = b { '<space><left>' },
      ['<s-tab>'] = b { require('plugins.binder.actions').s_tab },
      ['<tab>'] = b { require('plugins.binder.actions').tab },
      ['<c-e>'] = b { lazy_req('plugins.cmp', 'utils.toggle') },
      ['<c-p>'] = b { require('plugins.binder.actions').cmd_previous },
      ['<c-n>'] = b { require('plugins.binder.actions').cmd_next },
      ['<c-v>'] = b { '<c-r>"' },
      ['<c-r>r'] = b {
        '<c-r>+',
      },
    },
  })

  -- prevent s-mode text to overwrite clipboard
  -- Add a map for every printable character to copy to black hole register
  local t = require('plugins.binder.util').t
  for char_nr = 33, 126 do
    local char = vim.fn.nr2char(char_nr)
    vim.api.nvim_set_keymap(
      's',
      char,
      '<c-o>"_c' .. t(char),
      { noremap = true, silent = true }
    )
  end
  vim.api.nvim_set_keymap(
    's',
    '<bs>',
    '<c-o>"_c',
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    's',
    '<space>',
    '<c-o>"_c<space>',
    { noremap = true, silent = true }
  )
  return t
end

function M.config()
  local binder = require 'binder'
  binder.setup {
    dual_key = require('binder/util').prepend 'p',
    bind_keymap = require('binder/util').bind_keymap_legendary,
    prefix = 'plugins.',
  }
  local keys = binder.keys
  local b = binder.b
  local modes = binder.modes
  local util = require 'plugins.binder.util'
  local lazy = util.lazy
  local lazy_req = util.lazy_req

  binder.bind(keys {
    register = 'basic',
    g = keys {
      desc = 'move',
      register = 'move',
    },
    h = keys {
      desc = 'edit',
      register = 'edit',
    },
    o = keys {
      register = 'extra',
    },
    q = keys {
      register = 'editor',
      j = keys {
        desc = 'peek',
        register = 'peek',
      },
    },
    z = keys {
      register = 'bigmove',
    },
  })
  binder.bind(keys {
    q = keys {
      desc = 'quickfix',
      register = 'quickfix',
    },
  })
  binder.extend(
    'basic',
    keys {
      C = b { '<nop>', modes = 'nx' },
      -- c = b { '"_c', modes = 'nx' },
      c = modes {
        n = b { lazy_req('flies.actions', 'op_insert', '"_c', 'inner', true) },
        x = b { '"_c' },
      },
      -- cc = b { '"_cc', modes = 'n' },
      cc = b { '<nop>', modes = 'n' },
      D = b { '<nop>', modes = 'nx' },
      d = modes {
        n = b { lazy_req('flies.actions', 'op', '"_d', 'outer', true) },
        x = b { '"_d' },
      },
      dd = b { '<nop>', modes = 'n' },
      -- dd = b { '"_dd', modes = 'n' },
      rr = b { '"+', modes = 'nx' },
      r = b { '"', modes = 'nx' },
      ['<space>'] = b {
        desc = 'legendary find',
        lazy_req('legendary', 'find'),
      },
      ['<c-n>'] = b { lazy_req('bufjump', 'forward') },
      ['<c-o>'] = b { '<c-o>' },
      ['<c-p>'] = b { lazy_req('bufjump', 'backward') },
      ['<c-q>'] = b { '<cmd>qall!<cr>', 'quit' },
    }
  )
  binder.extend(
    'peek',
    keys {
      d = b {
        desc = 'definition',
        lazy_req('goto-preview', 'goto_preview_definition'),
      },
      r = b {
        desc = 'definition',
        lazy_req('goto-preview', 'goto_preview_references'),
      },
      t = b { 'UltestOutput', cmd = true },
    }
  )
  binder.extend(
    'extra',
    keys {
      t = b { desc = 'test file', '<Plug>PlenaryTestFile' },
    }
  )
  binder.with_labels('todo', 'w', {
    quickfix = b {
      require('modules.toggler').cb('TodoTrouble', 'TroubleClose'),
    },
  })
  binder.with_labels('git', 'u', {
    peek = b {
      lazy_req('gitsigns', 'blame_line', { full = true }),
    },
    editor = keys {
      prev = b {
        desc = 'diffview',
        require('modules.toggler').cb('DiffviewOpen', 'DiffviewClose'),
      },
      next = b {
        desc = 'hunks',
        require('modules.toggler').cb('Gitsigns setqflist', 'TroubleClose'),
      },
    },
  })
  binder.extend(
    'basic',
    keys {
      m = keys {
        b = keys {
          prev = b { '<Plug>(Marks-next-bookmark)' },
          next = b {
            function()
              require('marks').bookmark_state:all_to_list 'quickfixlist'
              require('telescope.builtin').quickfix()
            end,
          },
        },
        l = keys {
          prev = b {
            '<Plug>(Marks-next)',
          },
          next = b {
            function()
              require('marks').mark_state:all_to_list 'quickfixlist'
              require('telescope.builtin').quickfix()
            end,
          },
        },
      },
    }
  )
  binder.with_labels('marks', 'l', {
    peek = b {
      '<Plug>(Marks-preview)',
    },
    quickfix = b {
      require('modules.toggler').cb(function()
        require('marks').mark_state:all_to_list 'quickfixlist'
        vim.cmd 'Trouble quickfix'
      end, 'TroubleClose'),
    },
  })
  binder.with_labels('bookmarks', 'b', {
    quickfix = b {
      require('modules.toggler').cb(function()
        require('marks').bookmark_state:all_to_list 'quickfixlist'
        vim.cmd 'Trouble quickfix'
      end, 'TroubleClose'),
    },
    binder.with_labels('symbol', 's', {
      editor = b {
        desc = 'outliner',
        require('modules.toggler').cb(
          'SymbolsOutlineOpen',
          'SymbolsOutlineClose'
        ),
      },
      quickfix = keys {
        prev = b {
          desc = 'lsp references',
          require('modules.toggler').cb(
            'TroubleToggle references',
            'TroubleClose'
          ),
        },
      },
      bigmove = b { lazy_req('telescope.builtin', 'lsp_definitions') },
      extra = b {
        desc = 'show line',
        lazy('vim.diagnostic.open_float', nil, { source = 'always' }),
      },
    }),
  })
  binder.with_labels('diagnostic', 'd', {
    editor = keys {
      desc = 'trouble',
      prev = b {
        require('modules.toggler').cb(
          'Trouble document_diagnostics',
          'TroubleClose'
        ),
        desc = 'document',
      },
      next = b {
        require('modules.toggler').cb(
          'Trouble workspace_diagnostics',
          'TroubleClose'
        ),
        desc = 'workspace',
      },
    },
    extra = keys {
      c = keys {
        prev = b { desc = 'incoming calls', vim.lsp.buf.incoming_call },
        next = b { desc = 'outgoing calls', vim.lsp.buf.outgoing_calls },
      },
      d = b { desc = 'definition', vim.lsp.buf.definition },
      k = b { desc = 'hover', vim.lsp.buf.hover, 'hover' },
      r = b { desc = 'references', vim.lsp.buf.references },
      s = b { desc = 'signature help', vim.lsp.buf.signature_help },
      t = b { desc = 'go to type definition', vim.lsp.buf.type_definition },
      w = keys {
        desc = 'worspace folder',
        a = b {
          desc = 'add workspace folder',
          vim.lsp.buf.add_workspace_folder,
        },
        l = b {
          desc = 'ls workspace folder',
          vim.lsp.buf.list_workspace_folder,
        },
        d = b {
          desc = 'rm workspace folder',
          vim.lsp.buf.remove_workspace_folder,
        },
      },
      x = b {
        desc = 'stop active clients',
        function()
          vim.lsp.stop_client(vim.lsp.get_active_clients())
        end,
      },
    },
  })
  if false then
    print(
      b { lazy_req('telescope.builtin', 'lsp_references') },
      b { lazy_req('telescope.builtin', 'lsp_workspace_symbols') }
    )
    binder.with_labels('dap', 'b', {
      editor = b {
        desc = 'ui',
        require('modules.toggler').cb(
          lazy_req('dapui', 'open'),
          lazy_req('dapui', 'close')
        ),
      },
    })
    binder.with_labels('todo', 'w', {
      quickfix = b {
        require('modules.toggler').cb('TodoTrouble', 'TroubleClose'),
      },
    })
  end
  binder.with_labels('harpoon', 'x', require('plugins.harpoon').bindings())

  -- Commands
  for _, v in ipairs {
    'imap',
    'vmap',
    'cmap',
    'nmap',
    'xmap',
    'omap',
    'lua=',
  } do
    require('legendary').bind_keymap { string.format(':%s ', v) }
  end
  for _, v in ipairs {
    'update|so %',
    'messages',
    'PackerCompile',
    'PackerClean',
    'PackerInstall',
    'PackerUpdate',
    'PackerSync',
    'PackerLoad',
    'PackerProfile',
    'StartupTime',
    'LspInfo',
    'Neogit',
    'reg',
    'lua require"telescope.builtin".help_tags()',
    'lua require"telescope.builtin".search_history()',
    'lua require"telescope.builtin".jumplist()',
    'lua require"telescope.builtin".marks()',
    'lua require"telescope.builtin".man_pages()',
    'lua require"telescope.builtin".highlights()',
    'lua require"telescope.builtin".symbols{"emoji", "gitmoji", "math", "nerd"}',
    'lua require"telescope.builtin".register()',
  } do
    require('legendary').bind_keymap { string.format(':%s<cr>', v) }
  end

  map_ist()
  binder.extend('editor', require('plugins.binder.editor').extend())
  binder.extend('edit', require('plugins.binder.edit').extend())
  binder.extend('move', require('plugins.binder.move').extend())
  binder.extend('bigmove', require('plugins.binder.bigmove').extend())
end

return M
