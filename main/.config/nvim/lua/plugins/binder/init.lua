local M = {}

local util = require 'plugins.binder.util'
local lazy = util.lazy
local lazy_req = util.lazy_req

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
      desc = 'bigmove',
    },
    [':'] = keys { register = 'command' },
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
      ['<space>'] = b {
        desc = 'legendary find',
        lazy_req('legendary', 'find'),
      },
    }
  )
  binder.extend(
    'command',
    keys {
      ['imap '] = b {},
      ['nmap '] = b {},
      ['xmap '] = b {},
      ['reg<cr>'] = b {},
      ['omap '] = b {},
      ['lua='] = b {},
      ['update|so %<cr>'] = b {},
      ['PackerCompile<cr>'] = b {},
      ['PackerClean<cr>'] = b {},
      ['PackerInstall<cr>'] = b {},
      ['PackerUpdate<cr>'] = b {},
      ['PackerSync<cr>'] = b {},
      ['PackerLoad '] = b {},
    }
  )
  binder.extend(
    'edit',
    keys {
      v = modes {
        n = keys {
          prev = b { 'P' },
          next = b { 'p' },
        },
        ox = keys {
          prev = b {
            function()
              local rs = '"' .. vim.v.register
              require('bindutils').keys('"_d' .. rs .. 'P')
            end,
          },
          next = b {
            function()
              local rs = '"' .. vim.v.register
              require('bindutils').keys('"_d' .. rs .. 'P')
            end,
          },
        },
      },
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

  require 'plugins.binder.editor'.bind()
end

return M
