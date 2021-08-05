local M = {}
local wk = require 'which-key'
local invert = require('utils').invert

M.plugins = {}

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- https://github.com/folke/dot/blob/master/config/nvim/lua/config/compe.lua
function _G.confirm()
  if vim.fn.pumvisible() == 1 then
    return vim.fn['compe#confirm'] { keys = '<cr>', select = true }
  else
    return require('nvim-autopairs').autopairs_cr()
  end
end

-- should not call tabout in 's' mode, but seams harmless
--- <tab> to jump to next snippet's placeholder
function _G.tab_complete()
  return require('luasnip').jump(1) and '' or t '<Plug>(TaboutMulti)'
end

--- <s-tab> to jump to next snippet's placeholder
function _G.s_tab_complete()
  return require('luasnip').jump(-1) and '' or t '<Plug>(TaboutBackMulti)'
end

-- local function check_back_space()
--   local col = vim.fn.col '.' - 1
--   if col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' then
--     return true
--   else
--     return false
--   end
-- end
--
-- function _G.tab_complete()
--   local ls = require 'luasnip'
--   if vim.fn.pumvisible() == 1 then
--     return t '<C-n>'
--   elseif ls.jumpable(1) == true then
--     return t "<cmd>lua require'luasnip'.expand_or_jump(1)<cr>"
--     -- elseif check_back_space() then
--     --   return t '<Tab>'
--   else
--     return t '<Plug>(Tabout)'
--     -- return t '<cmd>call emmet#moveNextPrev(1)<cr>'
--     -- return vim.fn["compe#complete"]()
--   end
-- end

-- function _G.s_tab_complete()
--   local ls = require 'luasnip'
--   if vim.fn.pumvisible() == 1 then
--     return t '<C-p>'
--   elseif ls.jumpable(-1) == true then
--     return t "<cmd>lua require'luasnip'.expand_or_jump(-1)<cr>"
--   else
--     return t '<Plug>(TaboutBack)'
--     -- If <S-Tab> is not working in your terminal, change it to <C-h>
--     -- return t("<cmd>call emmet#moveNextPrev(0)<cr>")
--     -- return t '<S-Tab>'
--   end
-- end

local function map(modes, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  if modes == '' then
    vim.api.nvim_set_keymap('', lhs, rhs, options)
    return
  end
  for mode in modes:gmatch '.' do
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
  end
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
        string.format('"zy<cmd>BrowserSearchZ %s<cr>', url),
        help,
      },
    }, {
      prefix = prefix,
      mode = 'v',
    })
  end
end

function M.setup()
  -- compe
  map('i', '<c-space>', 'compe#complete()', { expr = true })
  map('i', '<cr>', 'v:lua.confirm()', { expr = true })
  map('i', '<c-e>', "compe#close('<c-e>')", { expr = true, silent = true })
  -- needed for tab-completion
  map('c', '<c-n>', '<down>')
  map('c', '<c-p>', '<up>')

  -- luasnip
  map(
    'is',
    '<c-o>',
    "luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'",
    { expr = true, noremap = false }
  )
  map(
    'is',
    '<c-i>',
    "luasnip#choice_active() ? '<Plug>luasnip-previous-choice' : '<C-E>'",
    { expr = true, noremap = false }
  )

  -- eft
  map('nx', ';', '<plug>(eft-repeat)', { noremap = false })
  map('nxo', 'f', '<plug>(eft-f)', { noremap = false })
  map('nxo', 'F', '<plug>(eft-F)', { noremap = false })
  map('nxo', 't', '<plug>(eft-t)', { noremap = false })
  map('nxo', 'T', '<plug>(eft-T)', { noremap = false })

  -- -- nohl on insert
  -- -- https://vi.stackexchange.com/questions/10407/stop-highlighting-when-entering-insert-mode
  -- breaks operators in expressions such as `daw`
  -- for _, cmd in ipairs { 'a', 'A', '<Insert>', 'i', 'I', 'gI', 'gi', 'o', 'O' } do
  --   map(
  --     '',
  --     cmd,
  --     "<cmd>nohlsearch<cr><cmd>lua require('hlslens.main').cmdl_search_leave()<cr>"
  --       .. cmd
  --   )
  -- end

  -- Tabout + Compe
  map(
    'is',
    '<tab>',
    'v:lua.tab_complete()',
    { expr = true, silent = true, noremap = false }
  )
  map(
    'is',
    '<s-tab>',
    'v:lua.s_tab_complete()',
    { expr = true, silent = true, noremap = false }
  )
  map(
    '',
    'n',
    "<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>"
  )
  map(
    '',
    'N',
    "<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>"
  )
  map(
    '',
    '*',
    '<plug>(asterisk-z*)<cmd>lua require"hlslens".start()<cr>',
    { noremap = false }
  )
  map(
    '',
    '#',
    '<plug>(asterisk-z#)<cmd>lua require"hlslens".start()<cr>',
    { noremap = false }
  )
  map(
    '',
    'g*',
    '<plug>(asterisk-gz*)<cmd>lua require"hlslens".start()<cr>',
    { noremap = false }
  )
  map(
    '',
    'g#',
    '<plug>(asterisk-gz#)<cmd>lua require"hlslens".start()<cr>',
    { noremap = false }
  )

  -- nv mappings
  for mode in string.gmatch('nv', '.') do
    wk.register({
      -- plugin's documentation specifies to use 's' instead of '<cmd>, which indeed do not produce expected results
      ['<m-v>'] = { '<c-v>', 'square selection' },
    }, {
      mode = mode,
    })
  end
  -- nvi mappings
  for mode in string.gmatch('nvi', '.') do
    wk.register({
      ['<c-l>'] = { '<cmd>nohlsearch<cr>', 'nohlsearch' },
      ['<c-a>'] = { '<cmd>b#<cr>' }, -- FIXME
      ['<c-s>'] = { '<cmd>w!<cr>', 'save' },
      ['<a-r>'] = { '<cmd>BufferNext<cr>', 'focus next buffer' },
      ['<a-e>'] = { '<cmd>BufferPrevious<cr>', 'focus previous buffer' },
      ['<a-s-r>'] = { '<cmd>BufferMoveNext<cr>', 'move buffer next' },
      ['<a-s-e>'] = { '<cmd>BufferMovePrevious<cr>', 'move buffer previous' },
      ['<a-c>'] = { '<cmd>BufferClose!<cr>', 'close buffer' },
      ['<c-g>'] = {
        "<cmd>lua require'nononotes'.prompt('edit', false, 'all')<cr>",
        'pick note',
      },
      -- ['<c-w>'] = {
      --   L = { '<cmd>vsplit<cr>', 'split left' },
      --   J = { '<cmd>split<cr>', 'split down' },
      -- },
      ['<a-o>'] = {
        '<cmd>BufferCloseBuffersRight<cr><cmd>BufferCloseBuffersLeft<cr><c-w>o',
        -- '<cmd>BufferCloseBuffersRight|BufferCloseBuffersLeft<cr>',
        'buffer only',
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

  -- x mappings
  wk.register({
    ['<leader>d'] = { '<Plug>(operator-sandwich-delete)', 'sandwich delete' },
    ['<leader>c'] = { '<Plug>(operator-sandwich-replace)', 'sandwich replace' },
    ['<leader>y'] = { '<Plug>(operator-sandwich-add)', 'sandwich replace' },
  }, {
    mode = 'x',
  })

  -- n mappings
  wk.register {
    --FIXME: is something else remapping it
    ys = { '<Plug>(operator-sandwich-add)', 'sandwich make' },
    g = {
      b = {
        '<Cmd>call jobstart(["opener", expand("<cfile>")], {"detach": v:true})<cr>',
        'open current url',
      },
      D = { '<cmd>lua vim.lsp.buf.declaration()<cr>', 'go declaration' },
      d = { '<cmd>lua vim.lsp.buf.definition()<cr>', 'go definition' },
      i = { '<cmd>lua vim.lsp.buf.implementation()<cr>', 'go implementation' },
      m = { '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', 'go next diagnostic' },
      M = {
        '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>',
        'go previous diagnostic',
      },
      -- t = {'<cmd>require("trouble").next({skip_groups = true, jump = true})<cr>', 'trouble, next'},
      -- T = {'<cmd>require("trouble").previous({skip_groups = true, jump = true})<cr>', 'trouble, previous'},
    },
    ['<leader>'] = {
      ['<leader>'] = {
        "<cmd>lua require'setup/telescope'.project_files()<cr>",
        'project file',
      },
      ['*'] = { '<cmd>Rg <cword><cr>', 'rg current word' },
      zz = { '<cmd>ZenMode<cr>', 'zen mode' },
      m = {
        ":<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>",
        'macro edition',
      },
      p = {
        name = '+panel',
        t = { '<cmd>TroubleToggle<cr>', 'toggle' },
        m = {
          '<cmd>TroubleToggle lsp_workspace_diagnostics<cr>',
          'lsp diagnostics',
        },
        M = {
          '<cmd>TroubleToggle lsp_document_diagnostics<cr>',
          'lsp document diagnostics',
        },
        q = { '<cmd>TroubleToggle quickfix<cr>', 'quickfix' },
        l = { '<cmd>TroubleToggle loclist<cr>', 'loclist' },
        r = { '<cmd>TroubleToggle lsp_references<cr>', 'lsp reference' },
      },
      o = {
        name = '+outline',
        v = { '<cmd>SymbolsOutlineClose<cr><cmd>VoomToggle markdown<cr>', 'voom' },
        s = {
          '<cmd>SymbolsOutline<cr><cmd>Voomquit<cr>',
          'symbols',
        },
        x = { '<cmd>SymbolsOutlineClose<cr><cmd>Voomquit<cr>', 'close' },
      },
      f = {
        name = '+picker',
        b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", 'buffers' },
        o = { "<cmd>lua require('telescope.builtin').oldfiles()<cr>", 'oldfiles' },
        l = { "<cmd>lua require('telescope.builtin').loclist()<cr>", 'loclist' },
        g = {
          "<cmd>lua require('telescope.builtin').live_grep()<cr>",
          'live grep',
        },
        r = {
          "<cmd>lua require('telescope.builtin').lsp_references()<cr>",
          'lsp references',
        },
        a = {
          "<cmd>lua require('telescope.builtin').lsp_code_actions()<cr>",
          'code actions',
        },
        A = {
          "<cmd>lua require('telescope.builtin').lsp_range_code_actions()<cr>",
          'range code actions',
        },
        t = {
          "<cmd>lua require('telescope.builtin').treesitter()<cr>",
          'treesitter',
        },
        p = { '<cmd>SearchSession<cr>', 'sessions' },
        s = { '<cmd>Telescope symbols<cr>', 'symbols' },
        c = { '<cmd>Cheatsheet<cr>', 'cheatsheet' },
        h = { '<cmd>Telescope heading<cr>', 'heading' },
        m = { '<cmd>Mdhelp<cr>', 'md help' },
        ['.'] = {
          "<cmd>lua require('telescope.builtin').find_files({find_command={'ls-dots'}, })<cr>",
          'dofiles',
        },
        [';'] = {
          "<cmd>lua require('telescope.builtin').commands()<cr>",
          'commands',
        },
        ['?'] = {
          "<cmd>lua require('telescope.builtin').help_tags()<cr>",
          'help tags',
        },
        ['/'] = {
          "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>",
          'current buffer fuzzy find',
        },
      },
      n = {
        name = '+notes',
        i = {
          "<cmd>lua require'nononotes'.prompt('insert', false, 'all')<cr>",
          'insert note id',
        },
        n = { "<cmd>lua require'nononotes'.new_note()<cr>", 'new note' },
        s = { "<cmd>lua require'nononotes'.prompt_step()<cr>", 'pick step id' },
        S = { "<cmd>lua require'nononotes'.new_step()<cr>", 'new step' },
        t = { "<cmd>lua require'nononotes'.prompt_thread()<cr>", 'prick step id' },
      },
      l = {
        name = '+LSP',
        k = { '<cmd>lua vim.lsp.buf.hover()<cr>', 'hover' },
        t = {
          '<cmd>lua vim.lsp.buf.type_definition()<cr>',
          'hover type definition',
        },
        d = { '<cmd>lua PeekDefinition()<cr>', 'hover definition' },
        s = { '<cmd>lua vim.lsp.buf.signature_help()<cr>', 'signature help' },
        wa = {
          '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>',
          'add workspace folder',
        },
        wr = {
          '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>',
          'rm workspace folder',
        },
        wl = {
          '<cmd>lua vim.lsp.buf.list_workspace_folder()<cr>',
          'rm workspace folder',
        },
        r = { '<cmd>lua vim.lsp.buf.rename()<cr>', 'rename' },
        x = {
          '<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<cr>',
          'stop active clients',
        },
        q = {
          '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>',
          'show line diagnostics',
        },
        m = { '<cmd>lua vim.lsp.buf.references()<cr>', 'references' },
        ['@'] = { '<cmd>ProDoc<cr>', 'prepare doc comment' },
        o = { '<cmd>SymbolsOutline<cr>', 'symbols outline' },
        ['?'] = { '<cmd>CheatDetect<cr>', 'Cheat' },
      },
      s = {
        name = '+Spell',
        e = { '<cmd>setlocal spell spelllang=en_us,cjk<cr>', 'en' },
        f = { '<cmd>setlocal spell spelllang=fr,cjk<cr>', 'fr' },
        b = { '<cmd>setlocal spell spelllang=en_us,fr,cjk<cr>', 'en fr' },
        x = { '<cmd>setlocal nospell spelllang=<cr>', 'none' },
        g = { '<cmd>LanguageToolCheck<cr>', 'language tools' },
        ['='] = { '<cmd>WhichKey z=<cr>', 'suggestions' },
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
        h = { "<cmd>lua require'dap.ui.widgets'.hover()<cr>", 'widgets' },
        H = { "<cmd>lua require'dap.ui.variables'.hover()<cr>", 'hover' },
        v = {
          "<cmd>lua require'dap.ui.variables'.visual_hover()<cr>",
          'visual hover',
        },
        ['?'] = {
          "<cmd>lua require'dap.ui.variables'.scopes()<cr>",
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
  vim = {
    -- options related to mapping
    g = {

      mapleader = ' ',
      user_emmet_leader_key = '<C-y>',
    },
  },
  nononotes = invert {
    ['<cr>'] = 'enter_link',
    ['<c-k>'] = 'print_hover_title',
  },
  telescope = function()
    local actions = require 'telescope.actions'
    -- local trouble = require 'trouble.providers.telescope'
    return {
      defaults = {
        mappings = {
          i = {
            ['<c-q>'] = actions.send_to_qflist,
            ['<c-l>'] = actions.send_to_loclist,
            -- ['<c-t>'] = trouble.open_with_trouble,
          },
          n = {
            ['<c-j>'] = actions.file_split,
            ['<c-l>'] = actions.file_vsplit,
            -- ['<c-t>'] = trouble.open_ith_trouble,
          },
        },
      },
    }
  end,
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
          ['aq'] = {
            lua = '@string.outer',
          },
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
  gitsigns = {
    keymaps = {
      noremap = true,
      buffer = true,
      ['n ]c'] = {
        expr = true,
        "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<cr>'",
      },
      ['n [c'] = {
        expr = true,
        "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<cr>'",
      },
      ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<cr>',
      ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<cr>',
      ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<cr>',
      ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<cr>',
      ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line()<cr>',
    },
  },
}

-- TODO
-- TODO
-- -- segment in camelCase etc words; changed bindings
-- -- ,w etc
-- '~/Media/Projects/vim-textobj-variable-segment',
-- -- same syntaxic group
-- -- ay, iy
-- ???
-- 'kana/vim-textobj-syntax',
-- -- remap vim, abbvr: numbers etc.
-- 'preservim/vim-textobj-sentence',
-- -- last pasted text
-- -- gb

-- 'saaguero/vim-textobj-pastedtext',
-- -- last searched pattern
-- -- a/ i/ a? i?
-- 'kana/vim-textobj-lastpat',
-- -- current line
-- -- al il
-- 'kana/vim-textobj-line',
-- -- TODO: smart quote navigation: ". ."
-- -- markdown
-- -- headers: 1) ]] [[ 2) ][ [] 3) ]} [{ x) ]h [h
-- --
-- 'coachshea/vim-textobj-markdown',
-- -- indent level
-- -- same) ai ii same or deaper) aI iI
-- -- text blocs
-- -- current or next) ]m [m
-- -- current or previous) ]n [n
-- 'michaeljsmith/vim-indent-object',
-- TODO

return M
