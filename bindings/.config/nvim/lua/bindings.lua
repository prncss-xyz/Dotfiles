local M = {}
local wk = require 'which-key'
local invert = require('utils').invert

M.plugins = {}

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function mapBrowserSearch(prefix, help0, mappings)
  wk.register { [prefix] = { name = help0 } }
  for abbr, value in pairs(mappings) do
    local url, help = unpack(value)
    wk.register({
      [abbr] = { string.format('<cmd>BrowserSearchCword %s<cr>', url), help },
    }, {
      prefix = prefix,
    })
    wk.register({
      [abbr] = {
        string.format('<cmd>BrowserSearchVisualSelection %s<cr>', url),
        help,
      },
    }, {
      prefix = prefix,
      mode = 'v',
    })
  end
end

function M.setup()
  vim.g.mapleader = ' '
  vim.g.user_emmet_leader_key = '<C-y>'

  -- compe
  map('i', '<c-space>', 'compe#complete()', { expr = true })
  -- map("i", "<cr>", "compe#confirm('<cr>')", { expr = true })
  map('i', '<c-e>', "compe#close('<c-e>')", { expr = true })
  map('i', '<c-f>', "compe#scroll({ 'delta': +4 })", { expr = true })
  map('i', '<c-d>', "compe#scroll({ 'delta': -4 })", { expr = true })
  map('i', '<tab>', 'v:lua.tab_complete()', { expr = true, silent = true })
  map('s', '<tab>', 'v:lua.tab_complete()', { expr = true, silent = true })
  map('i', '<s-tab>', 'v:lua.s_tab_complete()', { expr = true, silent = true })
  map('s', '<s-tab>', 'v:lua.s_tab_complete()', { expr = true, silent = true })
  -- needed for tab-completion
  map('c', '<c-n>', '<down>')
  map('c', '<c-p>', '<up>')

  -- lightspeed: canceling "f" until it works better
  map('', 'f', 'f')
  map('', 'F', 'F')
  map('', 't', 't')
  map('', 'T', 'T')

  -- asterisk
  map('', '*', '<plug>(asterisk-*)', { noremap = false })
  map('', '#', '<plug>(asterisk-#)', { noremap = false })
  map('', 'g*', '<plug>(asterisk-g*)', { noremap = false })
  map('', 'g#', '<plug>(asterisk-g#)', { noremap = false })

  -- cutlass
  map('n', 'x', 'd')
  map('x', 'x', 'd')
  map('n', 'xx', 'dd')
  map('n', 'X', 'D')
  map('v', 'p', '"_dp')
  map('v', 'P', '"_dP')
  map('n', '<c-v>', 'p')
  map('v', '<c-v>', 'dp')
  map('i', '<c-v>', '<esc>pa')

  -- nv mappings
  map('', '<m-v>', '<c-v>')
  for mode in string.gmatch('nv', '.') do
    wk.register({
      ['<c-w>'] = {
        L = { '<cmd>vsplit<cr>' },
        J = { '<cmd>split<cr>' },
      },
    }, {
      mode = mode,
    })
  end
  -- nvi mappings
  map('', '<C-l>', ':noh<cr>')
  map('i', '<c-l>', '<esc>:noh<cr>a')
  map('', '<c-s>', ':w!<cr>')
  map('i', '<c-s>', '<esc>:w!<cr>a')
  for mode in string.gmatch('nvi', '.') do
    wk.register({
      ['c-l'] = { '<cmd>noh<cr>', 'noh' },
      ['c-s'] = { '<cmd>w!<cr>', 'save' },
      ['<f2>'] = { '<cmd>ToggleQuickFix<cr>', 'toggle quick fix' },
      ['<a-r>'] = { '<cmd>BufferNext<CR>', 'focus next buffer' },
      ['<a-e>'] = { '<cmd>BufferPrevious<CR>', 'focus previous buffer' },
      ['<a-s-r>'] = { '<cmd>BufferMoveNext<CR>', 'move buffer next' },
      ['<a-s-e>'] = { '<cmd>BufferMovePrevious<CR>', 'move buffer previous' },
      ['<a-c>'] = { '<cmd>BufferClose!<CR>', 'close buffer' },
      -- slowed by matchup ambiguous mapping
      ['<c-g>'] = {
        "<cmd>lua require'nononotes'.prompt('edit', false, 'all')<CR>",
        'pick note',
      },
    }, {
      mode = mode,
    })
    for i = 1, 9 do
      wk.register({
        [string.format('<a-%d>', i)] = {
          string.format('<cmd>BufferGoto %i<cr>', i),
          string.format('focus buffer %d', i),
        },
      }, {
        mode = mode,
      })
    end
  end
  wk.register {
    g = {
      x = {
        '<Cmd>call jobstart(["opener", expand("<cfile>")], {"detach": v:true})<CR>',
        'open current url',
      },
      D = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'go declaration' },
      d = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'go definition' },
      i = { '<cmd>lua vim.lsp.buf.implementation()<CR>', 'go implementation' },
      m = { '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', 'go next diagnostic' },
      M = {
        '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',
        'go previous diagnostic',
      },
    },
    ['<leader>'] = {
      ['<leader>'] = {
        '<cmd>lua Project_files()<CR>',
        'project file',
      },
      ['*'] = { '<cmd>Rg <cword><cr>', 'rg current word' },
      zz = { '<cmd>ZenMode<CR>', 'zen mode' },
      m = {
        ":<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>",
        'macro edition',
      },
      f = {
        name = '+picker',
        b = { "<cmd>lua require('telescope.builtin').buffers()<CR>", 'buffers' },
        o = { "<cmd>lua require('telescope.builtin').oldfiles()<CR>", 'oldfiles' },
        l = { "<cmd>lua require('telescope.builtin').loclist()<CR>", 'loclist' },
        g = {
          "<cmd>lua require('telescope.builtin').live_grep()<CR>",
          'live grep',
        },
        r = {
          "<cmd>lua require('telescope.builtin').lsp_references()<CR>",
          'lsp references',
        },
        a = {
          "<cmd>lua require('telescope.builtin').lsp_code_actions()<CR>",
          'code actions',
        },
        A = {
          "<cmd>lua require('telescope.builtin').lsp_range_code_actions()<CR>",
          'range code actions',
        },
        t = {
          "<cmd>lua require('telescope.builtin').treesitter()<CR>",
          'treesitter',
        },
        p = { '<cmd>SearchSession<CR>', 'sessions' },
        s = { '<cmd>Telescope symbols<cr>', 'symbols' },
        c = { '<cmd>Cheatsheet<cr>', 'cheatsheet' },
        h = { '<cmd>Telescope heading<cr>', 'heading' },
        m = { '<cmd>Mdhelp<cr>', 'md help' },
        ['.'] = {
          "<cmd>lua require('telescope.builtin').find_files({find_command={'ls-dots'}, })<CR>",
          'dofiles',
        },
        [';'] = {
          "<cmd>lua require('telescope.builtin').commands()<CR>",
          'commands',
        },
        ['?'] = {
          "<cmd>lua require('telescope.builtin').help_tags()<CR>",
          'help tags',
        },
        ['/'] = {
          "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>",
          'current buffer fuzzy find',
        },
      },
      n = {
        name = '+notes',
        i = {
          "<cmd>lua require'nononotes'.prompt('insert', false, 'all')<CR>",
          'insert note id',
        },
        n = { "<cmd>lua require'nononotes'.new_note()<CR>", 'new note' },
        s = { "<cmd>lua require'nononotes'.prompt_step()<CR>", 'pick step id' },
        S = { "<cmd>lua require'nononotes'.new_step()<CR>", 'new step' },
        t = { "<cmd>lua require'nononotes'.prompt_thread()<CR>", 'prick step id' },
      },
      l = {
        name = '+LSP',
        k = { '<cmd>lua vim.lsp.buf.hover()<CR>', 'hover' },
        t = {
          '<cmd>lua vim.lsp.buf.type_definition()<CR>',
          'hover type definition',
        },
        d = { '<cmd>lua PeekDefinition()<CR>', 'hover definition' },
        s = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'signature help' },
        wa = {
          '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',
          'add workspace folder',
        },
        wr = {
          '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
          'rm workspace folder',
        },
        wl = {
          '<cmd>lua vim.lsp.buf.list_workspace_folder()<CR>',
          'rm workspace folder',
        },
        r = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'rename' },
        x = {
          '<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<cr>',
          'stop active clients',
        },
        q = {
          '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
          'show line diagnostics',
        },
        m = { '<cmd>lua vim.lsp.buf.references()<CR>', 'references' },
        ['@'] = { '<cmd>ProDoc<cr>', 'prepare doc comment' },
        o = { '<cmd>SymbolsOutline<cr>', 'symbols outline' },
        ['?'] = { '<cmd>CheatDetect<cr>', 'Cheat' },
      },
      s = {
        name = '+Spell',
        e = { '<cmd>setlocal spell spelllang=en_us,cjk<cr>', 'en' },
        f = { '<cmd>setlocal spell spelllang=fr,cjk<cr>', 'fr' },
        b = { '<cmd>setlocal spell spelllang=en_us,fr,cjk<cr>', 'en fr' },
        x = { '<cmd>setlocal nospell | spelllang=<cr>', 'none' },
        g = { '<cmd>LanguageToolCheck<cr>', 'language tools' },
      },
      d = {
        name = '+DAP',
        b = {
          "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
          'toggle breakpoints',
        },
        c = { "<cmd>lua require'dap'.continue()<cr>", 'continue' },
        s = { "<cmd>lua require'dap'.stop()<cr>", 'stop' },
        o = { "<cmd>lua require'dap'.step_over()<cr>", 'step over' },
        O = { "<cmd>lua require'dap'.step_out()<cr>", 'step out' },
        i = { "<cmd>lua require'dap'.step_into()<cr>", 'step into' },
        ['.'] = { "<cmd>lua require'dap'.run_last()<cr>", 'run last' },
        u = { "<cmd>lua require'dapui'.toggle()<cr>", 'toggle dapui' },
        k = { "<cmd>lua require'dap'.up()<cr>", 'up' },
        j = { "<cmd>lua require'dap'.down()<cr>", 'down' },
        l = { "<cmd>lua require'setup.dap'.launch()<cr>", 'launch' },
        r = { "<cmd>lua require'dap'.repl.open()<cr>", 'repl' },
        a = { "<cmd>lua require'setup/dap'.attach()<cr>", 'attach' },
        A = {
          "<cmd>lua require'setup/dap'.attachToRemote()<cr>",
          'attach to remote',
        },
        h = { "<cmd>lua require'dap.ui.widgets'.hover()<CR>", 'widgets' },
        H = { "<cmd>lua require'dap.ui.variables'.hover()<CR>", 'hover' },
        v = {
          "<cmd>lua require'dap.ui.variables'.visual_hover()<CR>",
          'visual hover',
        },
        ['?'] = {
          "<cmd>lua require'dap.ui.variables'.scopes()<CR>",
          'variables scopes',
        },
        B = {
          "<cmd>lua require'dap'.set_exception_breakpoints({'all'})<cr>",
          'set exception breakoints',
        },
        tc = {
          "<cmd>lua require'telescope'.extensions.dap.commands{}<cr>",
          'commands',
        },
        ['t,'] = {
          "<cmd>lua require'telescope'.extensions.dap.configurations{}<cr>",
          'configurations',
        },
        tb = {
          "<cmd>lua require'telescope'.extensions.dap.list_breakpoints{}<cr>",
          'list breakpoints',
        },
        tv = {
          "<cmd>lua require'telescope'.extensions.dap.variables{}<cr>",
          'dap variables',
        },
        tf = {
          "<cmd>lua require'telescope'.extensions.dap.frames{}<cr>",
          'dap frames',
        },
      },
      b = {
        gr = { '<cmd>BrowserSearchGh<cr>', 'github repo' },
        man = { '<cmd>BrowserMan<cr>', 'man page' },
      },
    },
  }
  mapBrowserSearch('<leader>b', '+browser search', {
    go = { 'https://google.ca/search?q=', 'google' },
    d = { 'https://duckduckgo.com/?q=', 'duckduckgo' },
    y = { 'https://www.youtube.com/results?search_query=', 'youtube' },
    gh = { 'https://github.com/search?q=', 'github' },
    npm = { 'https://www.npmjs.com/search?q=', 'npm' },
    lh = { 'https://www.libhunt.com/search?query=', 'libhunt' },
    mdn = { 'https://developer.mozilla.org/en-US/search?q=', 'mdn' },
    pac = { 'https://archlinux.org/packages/?q=', 'arch packages' },
    aur = { 'https://aur.archlinux.org/packages/?K=', 'aur packages' },
    sea = { 'https://www.seriouseats.com/search?q=', 'seriouseats' },
    p = { 'https://www.persee.fr/search?ta=article&q=', 'persée' },
    sep = { 'https://plato.stanford.edu/search/searcher.py?query=', 'sep' },
    cn = { 'https://www.cnrtl.fr/definition/', 'cnrtl' },
    usi = { 'https://usito.usherbrooke.ca/d%C3%A9finitions/', 'usito' },
    arch = { 'https://wiki.archlinux.org/index.php?search=', 'archlinux wiki' },
    nell = {
      'https://nelligan.ville.montreal.qc.ca/search*frc/a?searchtype=Y&searcharg=',
      'nelligan',
    },
    ca = { 'https://www.cairn.info/resultats_recherche.php?searchTerm=', 'cairn' },
    fr = {
      'https://pascal-francis.inist.fr/vibad/index.php?action=search&terms=',
      'francis',
    },
    eru = {
      'https://www.erudit.org/fr/recherche/?funds=%C3%89rudit&funds=UNB&basic_search_term=',
      'erudit',
    },
  })
end

M.plugins = {
  nononotes = invert {
    ['<cr>'] = 'enter_link',
    ['<c-k>'] = 'print_hover_title',
  },
  treesitter = {
    incremental_selection = {
      keymaps = invert {
        gnn = 'init_selection',
        grn = 'node_incremental',
        nrc = 'scope_incremental',
        grm = 'node_decremental',
      },
    },
    textobjects = {
      select = {
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ia'] = '@parameter.inner',
          ['a,'] = {
            javascript = '(pair) @object', -- not working
          },
        },
      },
      swap = {
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
      move = {
        goto_next_start = {
          [',f'] = '@function.outer',
        },
        goto_previous_end = {
          [',F'] = '@function.outer',
        },
      },
    },
    textsubjects = {
      keymaps = {
        ['.'] = 'textsubjects-smart',
        [';'] = 'textsubjects-big',
      },
    },
  },
}
return M
