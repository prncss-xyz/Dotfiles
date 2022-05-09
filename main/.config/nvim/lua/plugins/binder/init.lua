local M = {}

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
    prefix = 'plugins.binder.',
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
      t = keys {
        desc = 'quickfix',
        register = 'quickfix',
      },
    },
    z = keys {
      register = 'bigmove',
    },
  })

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
  })
  binder.with_labels('symbol', 's', {
    editor = b {
      desc = 'outliner',
      require('modules.toggler').cb(
        'SymbolsOutlineOpen',
        'SymbolsOutlineClose'
      ),
    },
    quickfix = b {
      desc = 'lsp references',
      require('modules.toggler').cb('Trouble lps_references', 'TroubleClose'),
    },
    bigmove = b { lazy_req('telescope.builtin', 'lsp_definitions') },
    extra = b {
      desc = 'show line',
      lazy('vim.diagnostic.open_float', nil, { source = 'always' }),
    },
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
    binder.with_labels('dap', 'b', {
      editor = b {
        desc = 'ui',
        require('modules.toggler').cb(
          lazy_req('dapui', 'open'),
          lazy_req('dapui', 'close')
        ),
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
    'reg',
  } do
    require('legendary').bind_keymap { string.format(':%s<cr>', v) }
  end
  for _, v in ipairs {
    'help_tags',
    'search_history',
    'jumplist',
    'marks',
    'man_pages',
    'highlights',
    'register',
    'lsp_references',
    'lsp_workspace_symbols',
  } do
    local lhs = string.format(':Telescope' .. v:sub(1, 1):upper() .. v:sub(2))
    require('legendary').bind_keymap {
      lhs,
      function()
        require('telescope.builtin')[v]()
      end,
      description = 'telescope ' .. v,
    }
  end
  local v = 'symbols'
  local lhs = string.format(':Telescope' .. v:sub(1, 1):upper() .. v:sub(2))
  require('legendary').bind_keymap {
    lhs,
    function()
      require('telescope.builtin')[v] { 'emoji', 'gitmoji', 'math', 'nerd' }
    end,
    description = 'telescope ' .. v,
  }

  map_ist()
  binder.extend_with 'basic'
  binder.extend_with 'editor'
  binder.extend_with 'edit'
  binder.extend_with 'move'
  binder.extend_with 'bigmove'
end

return M
