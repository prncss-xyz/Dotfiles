local M = {}

local function map_lang()
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
    c = keys {
      ['<m-e>'] = b { '<c-f>' },
    },
    is = keys {
      ['<c-space>'] = b { '<space><left>' },
      ['<e-space>'] = b { '<space><left>' },
      ['<c-f>'] = b { util.lazy_req('plugins.cmp', 'utils.confirm') },
      ['<c-z>'] = b { lazy_req('plugins.cmp', 'utils.toggle') },
      ['<c-p>'] = b { require('plugins.binder.actions').menu_previous },
      ['<c-n>'] = b { require('plugins.binder.actions').menu_next },
      ['<s-tab>'] = b {
        require('plugins.binder.actions').jump_previous,
        desc = 'prev insert point',
      },
      ['<tab>'] = b {
        require('plugins.binder.actions').jump_next,
        desc = 'next insert point',
      },
      ['<c-v>'] = b { '<c-r>+' },
      ['<c-r>r'] = b {
        '<c-r>"',
      },
      -- TODO: <c-u> noreamp j
      -- prev next insert point
      ['<c-u>'] = b { lazy_req('readline', 'backward_kill_line') },
    },
    -- c-f to format
    isc = keys {
      ['<c-a>'] = b { lazy_req('readline', 'beginning_of_line') },
      ['<c-e>'] = b { lazy_req('readline', 'end_of_line') },
      ['<c-k>'] = b { lazy_req('readline', 'kill_line') },
      ['<c-w>'] = b { lazy_req('readline', 'backward_kill_word') },
      ['<m-f>'] = b { lazy_req('readline', 'forward_word') },
      ['<m-b>'] = b { lazy_req('readline', 'backward_word') },
      ['<m-d>'] = b { lazy_req('readline', 'kill_word') }, --
    },
    ni = keys {
      ['<c-s>'] = b {
        function()
          vim.cmd 'stopinsert'
          require('bindutils').lsp_format()
        end,
      },
      desc = 'format',
      ['<c-g>'] = b {
        lazy_req('telescope', 'extensions.luasnip.luasnip', {}),
        modes = 'ni',
      },
    },
    iv = keys {
      ['<c-f>'] = b {
        function()
          require('luasnip.extras.otf').on_the_fly 'f'
        end,
        modes = 'vi',
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
    'mark',
    keys {
      redup = b {
        '<cmd>rshada<cr><Plug>(Marks-toggle)<cmd>wshada!<cr>',
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
      require('modules.toggler').cb(function()
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
        b = { '<cmd>rshada<cr><Plug>(Marks-delete-bookmark)<cmd>wshada!<cr>' },
      },
      a = b { '<Plug>(Marks-set-bookmark0)' },
      s = b { '<Plug>(Marks-set-bookmark1)' },
      d = b { '<Plug>(Marks-set-bookmark2)' },
      f = b { '<Plug>(Marks-set-bookmark3)' },
    },
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
  if false then
    binder.with_labels('dap', 'b', {
      editor = b {
        desc = 'ui',
        require('modules.toggler').cb(
          lazy_req('dapui', 'open'),
          lazy_req('dapui', 'close')
        ),
      },
      extra = keys {
        a = keys {
          prev = b { lazy_req('dap', 'attachToRemote') },
          next = b { lazy_req('dap', 'attach') },
        },
        b = keys {
          prev = b { lazy_req('dap', 'clear_breakpoints') },
          next = b { lazy_req('dap', 'toggle_breakpoints') },
        },
        c = repeatable { lazy_req('dap', 'continue') },
        i = repeatable { lazy_req('dap', 'step_into') },
        o = keys {
          prev = repeatable { lazy_req('dap', 'step_out') },
          next = repeatable { lazy_req('dap', 'step_over') },
        },
        x = keys {
          prev = b { lazy_req('dap', 'disconnect') },
          next = b { lazy_req('dap', 'terminate') },
        },
        ['.'] = b { lazy_req('dap', 'run_last') },
        k = b { lazy_req('dap', 'up') },
        j = b { lazy_req('dap', 'down') },
        l = b { lazy_req('dap', 'launch') },
        r = b { lazy_req('dap', 'repl.open') },
        h = keys {
          prev = b {
            "<cmd>lua require'dap.ui.variables'.hover()<cr>",
            'hover',
          },
          next = b {
            "<cmd>lua require'dap.ui.widgets'.hover()<cr>",
            'widgets',
          },
        },
        v = b {
          "<cmd>lua require'dap.ui.variables'.visual_hover()<cr>",
          'visual hover',
        },
        ['?'] = b {
          "<cmd>lua require'dap.ui.variables'.scopes()<cr>",
          'variables scopes',
        },
        tc = b {
          "<cmd>lua require'telescope'.extensions.dap.commands{}<cr>",
          'commands',
        },
        ['t,'] = b {
          "<cmd>lua require'telescope'.extensions.dap.configurations{}<cr>",
          'configurations',
        },
        tb = b {
          "<cmd>lua require'telescope'.extensions.dap.list_breakpoints{}<cr>",
          'list breakpoints',
        },
        tv = b {
          "<cmd>lua require'telescope'.extensions.dap.variables{}<cr>",
          'dap variables',
        },
        tf = b {
          "<cmd>lua require'telescope'.extensions.dap.frames{}<cr>",
          'dap frames',
        },
        ['<cr>'] = repeatable { lazy_req('dap', 'run_to_cursor') },
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
  require('legendary').bind_keymap {
    ':TelescopeCheat',
    function()
      require('telescope').extensions.cheat.fd {}
    end,
    description = 'telescope cheat',
  }
  local v = 'symbols'
  local lhs = string.format(':Telescope' .. v:sub(1, 1):upper() .. v:sub(2))
  require('legendary').bind_keymap {
    lhs,
    function()
      require('telescope.builtin')[v] { 'emoji', 'gitmoji', 'math', 'nerd' }
    end,
    description = 'telescope ' .. v,
  }

  map_lang()
  binder.extend_with 'basic'
  binder.extend_with 'editor'
  binder.extend_with 'edit'
  binder.extend_with 'move'
  binder.extend_with 'bigmove'
  require 'plugins.binder.textobjects'.setup()
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
