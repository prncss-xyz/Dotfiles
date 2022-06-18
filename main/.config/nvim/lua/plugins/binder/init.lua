local M = {}

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.config()
  local binder = require 'binder'
  binder.setup {
    dual_key = require('binder.utils').prepend 'p',
    bind_keymap = require('binder.utils').bind_keymap_legendary,
    prefix = 'plugins.binder.',
  }
  local keys = binder.keys
  local b = binder.b
  local modes = binder.modes
  local util = require 'plugins.binder.utils'
  local repeatable = util.repeatable
  local lazy = util.lazy
  local lazy_req = util.lazy_req

  binder.bind(keys {
    register = 'basic',
    g = keys {
      desc = 'go',
      register = 'move',
      next = b { '<nop>' },
    },
    h = keys {
      desc = 'edit',
      register = 'edit',
      next = b { '<nop>' },
    },
    m = keys {
      register = 'mark',
      next = b { '<nop>' },
    },
    o = keys {
      register = 'extra',
      next = b { '<nop>' },
    },
    q = keys {
      register = 'editor',
      next = b { '<nop>' },
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
      next = b { '<nop>' },
    },
  })
  require('key-menu').set('n', 'g')
  require('key-menu').set('n', 'h')
  require('key-menu').set('n', 'm')
  require('key-menu').set('n', 'o')
  require('key-menu').set('n', 'q')
  require('key-menu').set('n', 'qj')
  require('key-menu').set('n', 'qt')
  require('key-menu').set('n', 'z')

  binder.extend(
    'peek',
    keys {
      redup = b {
        desc = 'focus',
        '<c-w>w',
      },
      d = b {
        desc = 'definition',
        lazy_req('goto-preview', 'goto_preview_definition'),
      },
      r = b {
        desc = 'reference',
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
      require('utils.toggler').cb('TodoTrouble', 'TroubleClose'),
    },
  })
  binder.with_labels('git', 'g', {
    peek = b {
      desc = 'peek',
      lazy_req('gitsigns', 'blame_line', { full = true }),
    },
    quickfix = b {
      desc = 'hunks',
      require('utils.toggler').cb('Gitsigns setqflist', 'TroubleClose'),
    },
    editor = keys {
      redup = b {
        desc = 'neogit',
        require('utils.toggler').cb('Neogit', ':q'),
      },
      b = b {
        desc = 'branch',
        lazy_req('neogit', 'open'), -- split, vsplit
      },
      c = b {
        desc = 'commit',
        lazy_req('neogit', 'open'), -- split, vsplit
      },
      d = keys {
        desc = 'diffview',
        prev = b {
          desc = 'diffview',
          require('utils.toggler').cb('DiffviewOpen', 'DiffviewClose'),
        },
        next = b {
          desc = 'diffview',
          require('utils.toggler').cb('DiffviewFileHistory', 'DiffviewClose'),
        },
      },
      H = b {
        desc = 'help',
        lazy_req('neogit', 'open'), -- split, vsplit
      },
      l = b {
        desc = 'log',
        lazy_req('neogit', 'open'), -- split, vsplit
      },
      p = keys {
        prev = b {
          desc = 'push',
          lazy_req('neogit', 'open'), -- split, vsplit
        },
        next = b {
          desc = 'pull',
          lazy_req('neogit', 'open'), -- split, vsplit
        },
      },
      r = b {
        desc = 'rebase',
        lazy_req('neogit', 'open'), -- split, vsplit
      },
      z = b {
        desc = 'stash',
        lazy_req('neogit', 'open'), -- split, vsplit
      },
      ['<cr>'] = b {
        desc = 'blame toggle',
        lazy_req('gitsigns', 'toggle_current_line_blame', { full = true }),
      },
    },
  })
  binder.extend(
    'mark',
    keys {
      redup = b {
        function()
          if not vim.g.secret then
            vim.fn.feedkeys(
              t '<cmd>rshada<cr><Plug>(Marks-toggle)<cmd>wshada!<cr>',
              'm'
            )
          end
        end,
        desc = 'toggle next available mark at cursor',
      },
    }
  )
  --[[
        '<Plug>(Marks-next)',
      pl = plug {
        '(Marks-delete)',
        desc = 'Delete a letter mark (will wait for input).',
      },
      l = plug {
        '(Marks-set)',
        desc = 'Sets a letter mark (will wait for input).',
      },
      prev = b {
        '<Plug>(Marks-set)',
      },
      next = b {
        function()
          require('marks').mark_state:all_to_list 'quickfixlist'
          require('telescope.builtin').quickfix()
        end,
      },
        l = plug { '(Marks-prev)', name = 'Goes to previous mark in buffer.' },
  --]]
  binder.with_labels('marks', 'l', {
    peek = b {
      '<Plug>(Marks-preview)',
    },
    quickfix = b {
      require('utils.toggler').cb(function()
        require('marks').mark_state:all_to_list 'quickfixlist'
        vim.cmd 'Trouble quickfix'
      end, 'TroubleClose'),
    },
  })
  binder.with_labels('bookmarks', 'b', {
    mark = keys {
      -- prev = b { '<Plug>(Marks-next-bookmark)' },
      -- next = b {
      --   function()
      --     require('marks').bookmark_state:all_to_list 'quickfixlist'
      --     require('telescope.builtin').quickfix()
      --   end,
      -- },
      -- [a.mark] = {
      --   ['pp' .. a.mark] = plug {
      --     '(Marks-deletebuf)',
      --     name = 'Deletes all marks in current buffer.',
      --   },
      --   ['p' .. a.mark] = plug {
      --     '(Marks-deleteline)',
      --     name = 'Deletes all marks on current line.',
      --   },
      -- },
      -- a = require('bindutils').bookmark_next(0),
      -- s = require('bindutils').bookmark_next(1),
      -- d = require('bindutils').bookmark_next(2),
      -- f = require('bindutils').bookmark_next(3),
      -- b = plug '(Marks-prev-bookmark)',
      next = b {
        b = {
          '<cmd>rshada<cr><Plug>(Marks-delete-bookmark)<cmd>wshada!<cr>',
        },
      },
      a = b { '<Plug>(Marks-set-bookmark0)' },
      s = b { '<Plug>(Marks-set-bookmark1)' },
      d = b { '<Plug>(Marks-set-bookmark2)' },
      f = b { '<Plug>(Marks-set-bookmark3)' },
    },
    quickfix = b {
      require('utils.toggler').cb(function()
        require('marks').bookmark_state:all_to_list 'quickfixlist'
        vim.cmd 'Trouble quickfix'
      end, 'TroubleClose'),
    },
  })
  binder.with_labels('symbol', 's', {
    editor = b {
      desc = 'aerial',
      require('utils.toggler').cb(
        'AerialOpen',
        'AerialClose'
      ),
      -- desc = 'outliner',
      -- require('utils.toggler').cb(
      --   'SymbolsOutlineOpen',
      --   'SymbolsOutlineClose'
      -- ),
    },
    quickfix = b {
      desc = 'lsp references',
      require('utils.toggler').cb('Trouble lps_references', 'TroubleClose'),
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
        require('utils.toggler').cb(
          'Trouble document_diagnostics',
          'TroubleClose'
        ),
        desc = 'document',
      },
      next = b {
        require('utils.toggler').cb(
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
      k = b { desc = 'hover', vim.lsp.buf.hover },
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
    },
  })
  if true then
    binder.with_labels('dap', 'a', {
      editor = b {
        desc = 'ui',
        require('utils.toggler').cb(
          lazy_req('dapui', 'open'),
          lazy_req('dapui', 'close')
        ),
      },
      extra = keys {
        b = keys {
          prev = b {
            desc = 'clear breakpoints',
            lazy_req('dap', 'clear_breakpoints'),
          },
          next = b {
            desc = 'toggle breakpoints',
            lazy_req('dap', 'toggle_breakpoint'),
          },
        },
        c = repeatable { desc = 'continue', lazy_req('dap', 'continue') },
        i = repeatable { desc = 'step into', lazy_req('dap', 'step_into') },
        o = keys {
          prev = repeatable { desc = 'step out', lazy_req('dap', 'step_out') },
          next = repeatable {
            desc = 'step over',
            lazy_req('dap', 'step_over'),
          },
        },
        x = keys {
          prev = b { desc = 'disconnect', lazy_req('dap', 'disconnect') },
          next = b { desc = 'terminate', lazy_req('dap', 'terminate') },
        },
        ['.'] = b { desc = 'run last', lazy_req('dap', 'run_last') },
        k = b { desc = 'up', lazy_req('dap', 'up') },
        j = b { desc = 'down', lazy_req('dap', 'down') },
        l = b { desc = 'launch', lazy_req('dap', 'launch') },
        r = b { desc = 'repl open', lazy_req('dap', 'repl.open') },
        h = keys {
          prev = b {
            "<cmd>lua require'dap.ui.variables'.hover()<cr>",
            desc = 'hover',
          },
          next = b {
            "<cmd>lua require'dap.ui.widgets'.hover()<cr>",
            desc = 'widgets',
          },
        },
        v = b {
          "<cmd>lua require'dap.ui.variables'.visual_hover()<cr>",
          desc = 'visual hover',
        },
        ['?'] = b {
          "<cmd>lua require'dap.ui.variables'.scopes()<cr>",
          desc = 'variables scopes',
        },
        tc = b {
          "<cmd>lua require'telescope'.extensions.dap.commands{}<cr>",
          desc = 'commands',
        },
        ['t,'] = b {
          "<cmd>lua require'telescope'.extensions.dap.configurations{}<cr>",
          desc = 'configurations',
        },
        tb = b {
          "<cmd>lua require'telescope'.extensions.dap.list_breakpoints{}<cr>",
          desc = 'list breakpoints',
        },
        tv = b {
          "<cmd>lua require'telescope'.extensions.dap.variables{}<cr>",
          desc = 'dap variables',
        },
        tf = b {
          "<cmd>lua require'telescope'.extensions.dap.frames{}<cr>",
          desc = 'dap frames',
        },
        ['<cr>'] = repeatable {
          desc = 'run to cursor',
          lazy_req('dap', 'run_to_cursor'),
        },
      },
    })
  end
  require('plugins.binder.commands').setup()
  require('plugins.binder.lang').setup()
  binder.extend_with 'basic'
  binder.extend_with 'editor'
  binder.extend_with 'edit'
  binder.extend_with 'move'
  binder.extend_with 'bigmove'
  binder.extend_with 'extra'
  require('plugins.binder.textobjects').setup()
end

--[[

local function map_basic()
  -- TODO:
  local reg = require('modules.binder').reg
  reg {
    [','] = {
      name = 'hint',
      modes = {
        n = '`',
        x = ':lua require("tsht").nodes()<CR>',
        o = function()
          require('tsht').nodes()
        end,
      },
    },
    [a.edit] = {
      w = {
        function()
          require('telescope.builtin').symbols {
            sources = { 'math', 'emoji' },
          }
        end,
        'symbols',
        modes = 'n',
      },
      [d.spell] = {
        function()
          require('telescope.builtin').spell_suggest(
            require('telescope.themes').get_cursor {}
          )
        end,
        'spell suggest',
        modes = 'nx',
      },
    },
  }
end

00 1247 LOC
--]]

return M
