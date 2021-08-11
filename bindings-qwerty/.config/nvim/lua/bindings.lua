local M = {}
local map = require('utils').map
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
  map('n', 'q', '<nop>')
  map('n', 'Q', '<nop>')
  map('n', 'm', '<nop>')

  local edit = 'm'
  local jump = 'g'
  -- local mark = 'z'
  local move = 'q'
  local mark = 'M'
  local macro = 'Q'

  local left = 'h'
  local up = 'j'
  local down = 'k'
  local right = 'l'

  local uLeft = string.upper(left)
  local uUp = string.upper(up)
  local uDown = string.upper(down)
  local uRight = string.upper(right)

  local function remark(new, old)
    map('', mark .. new, '`' .. old)
    map('', mark .. new, "'" .. old)
  end
  remark('V', '<')
  remark('v', '>')
  remark('p', '[')
  remark('P', ']')
  map('n', 'Ms', 'm')
  map('n', 'Mm', "'")
  map('n', 'Mlm', '`') -- not working ?? whichkwey

  -- Small experiment...
  -- map('n', 'i', '<nop>')
  -- map('n', 'a', '<nop>')
  -- map('n', 'I', 'i')
  -- map('n', 'A', 'a')
  -- map('n', 'ii', 'i')
  -- map('n', 'aa', 'a')
  -- map('n', 'iI', 'I')
  -- map('n', 'aA', 'A')

  -- -- word
  -- --  'n', 'w', 'w'
  -- map('n', 'W', 'ge')
  -- map('o', 'w', 'iw')
  -- map('o', 'W', 'aw')
  -- map('n', 'iw', 'ea')
  -- map('n', 'iW', 'bi')

  -- -- WORD
  -- map('n', 'e', 'W')
  -- map('n', 'E', 'gE')
  -- map('o', 'e', 'iW')
  -- map('o', 'E', 'aW')
  -- map('n', 'ie', 'Ea')
  -- map('n', 'iE', 'Bi')
  -- ;q

  -- " Use <nowait> to override the default bindings which wait for another key press

  -- macrobatics
  map('n', macro .. macro, '<plug>(Mac_Play)', { noremap = false })
  map('n', macro .. 'r', '<plug>(Mac_RecordNew)', { noremap = false })
  map('n', macro .. 'n', '<plug>(Mac_RotateBack)', { noremap = false })
  map('n', macro .. 'N', '<plug>(Mac_RotateForward)', { noremap = false })
  map('n', macro .. 'a', '<plug>(Mac_Append)', { noremap = false })
  map('n', macro .. 'A', '<plug>(Mac_Prepend)', { noremap = false })
  map('n', macro .. 'w', '<plug>(Mac_NameCurrentMacro)', { noremap = false })
  map(
    'n',
    macro .. 'fw',
    '<plug>(Mac_NameCurrentMacroForFileType)',
    { noremap = false }
  )
  map(
    'n',
    macro .. 'sw',
    '<plug>(Mac_NameCurrentMacroForCurrentSession)',
    { noremap = false }
  )
  map(
    'n',
    macro .. 'ér',
    '<plug>(Mac_SearchForNamedMacroAndOverwrite)',
    { noremap = false }
  )
  map(
    'n',
    macro .. 'én',
    '<plug>(Mac_SearchForNamedMacroAndRename)',
    { noremap = false }
  )
  map(
    'n',
    macro .. 'éd',
    '<plug>(Mac_SearchForNamedMacroAndDelete)',
    { noremap = false }
  )
  map(
    'n',
    macro .. 'éq',
    '<plug>(Mac_SearchForNamedMacroAndPlay)',
    { noremap = false }
  )
  map('n', macro .. 'l', 'DisplayMacroHistory')

  -- matze move
  vim.cmd [[
	call submode#enter_with('move', 'n', 'r', 'mj', '<Plug>MoveLineDown')
	call submode#enter_with('move', 'n', 'r', 'mk', '<Plug>MoveLineUp')
  call submode#map('move', 'n', 'r', 'j', '<Plug>MoveLineDown')
  call submode#map('move', 'n', 'r', 'k', '<Plug>MoveLineUp')
	call submode#leave_with('move', 'n', '', '<Esc>')
  ]]
  map('v', 'mj', '<Plug>MoveBlockDown', { noremap = false })
  map('v', 'mk', '<Plug>MoveBlockUp', { noremap = false })
  map('v', 'mh', '<Plug>MoveBlockLeft', { noremap = false })
  map('v', 'ml', '<Plug>MoveBlockRight', { noremap = false })
  map('n', 'ml', '<Plug>MoveCharRight', { noremap = false })
  map('n', 'mh', '<Plug>MoveCharLeft', { noremap = false })

  -- sandwich
  map('', 'my', '<Plug>(operator-sandwich-add)', { noremap = false })
  map('', 'mr', '<Plug>(operator-sandwich-replace)', { noremap = false })
  map('', 'md', '<Plug>(operator-sandwich-delete)', { noremap = false })

  -- kommentary
  map('n', 'mcc', '<Plug>kommentary_line_default', { noremap = false })
  map('n', 'mc', '<Plug>kommentary_motion_default', { noremap = false })
  map('x', 'mc', '<Plug>kommentary_visual_default<esc>', { noremap = false })

  -- VSSPlit
  -- maybe not K... if visual only
  map('x', 'Kr', '<Plug>(Visual-Split-VSResize)', { noremap = false })
  map('x', 'KS', '<Plug>(Visual-Split-VSSplit)', { noremap = false })
  map('x', 'Kk', '<Plug>(Visual-Split-VSSplitAbove)', { noremap = false })
  map('x', 'Kj', '<Plug>(Visual-Split-VSSplitBelow)', { noremap = false })

  -- luasnip + dia
  map(
    'nvi',
    '<c-a>',
    "luasnip#choice_active() ? '<plug>luasnip-next-choice' : '<plug>(dial-increment)'",
    { expr = true, noremap = false }
  )
  map(
    'nvi',
    '<c-x>',
    "luasnip#choice_active() ? '<plug>luasnip-previous-choice' : '<plug>(dial-decrement)'",
    { expr = true, noremap = false }
  )
  map(
    'v',
    'g<c-a>',
    '<Plug>(dial-increment-additional)',
    { silent = true, noremap = false }
  )
  map(
    'v',
    'g<c-x>',
    '<Plug>(dial-decrement-additional)',
    { silent = true, noremap = false }
  )

  -- compe
  map('i', '<c-space>', 'compe#complete()', { expr = true })
  map('i', '<cr>', 'v:lua.confirm()', { expr = true })
  map('i', '<c-e>', "compe#close('<c-e>')", { expr = true, silent = true })
  -- needed for tab-completion
  map('c', '<c-n>', '<down>')
  map('c', '<c-p>', '<up>')

  -- eft
  map('nx', ':', '<plug>(eft-repeat)', { noremap = false })
  map('nxo', 'f', '<plug>(eft-f)', { noremap = false })
  map('nxo', 'F', '<plug>(eft-F)', { noremap = false })
  map('nxo', 't', '<plug>(eft-t)', { noremap = false })
  map('nxo', 'T', '<plug>(eft-T)', { noremap = false })
  map('nx', ';', ':')

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
    "<cmd>execute('normal! ' . v:count1 . 'nzz')<cr><cmd>lua require('hlslens').start()<cr>"
  )
  map(
    '',
    'N',
    "<cmd>execute('normal! ' . v:count1 . 'Nzzt')<cr><cmd>lua require('hlslens').start()<cr>"
  )
  -- map(
  --   '',
  --   '*',
  --   '<plug>(asterisk-z*)<cmd>lua require"hlslens".start()<cr>',
  --   { noremap = false }
  -- )
  -- map(
  --   '',
  --   '#',
  --   '<plug>(asterisk-z#)<cmd>lua require"hlslens".start()<cr>',
  --   { noremap = false }
  -- )
  -- map(
  --   '',
  --   'g*',
  --   '<plug>(asterisk-gz*)<cmd>lua require"hlslens".start()<cr>',
  --   { noremap = false }
  -- )
  -- map(
  --   '',
  --   'g#',
  --   '<plug>(asterisk-gz#)<cmd>lua require"hlslens".start()<cr>',
  --   { noremap = false }
  -- )
  map(
    '',
    'gw',
    '<plug>(asterisk-z*)<cmd>lua require"hlslens".start()<cr>',
    { noremap = false }
  )
  map(
    '',
    'gW',
    '<plug>(asterisk-gz*)<cmd>lua require"hlslens".start()<cr>',
    { noremap = false }
  )

  -- nvi mappings
  for mode in string.gmatch('nvi', '.') do
    wk.register({
      ['<a-p>'] = { '<cmd>BufferPrevious<cr>', 'focus previous buffer' },
      ['<a-n>'] = { '<cmd>BufferNext<cr>', 'focus next buffer' },
      ['<a-h>'] = { "<cmd>lua require('Navigator').left()<cr>", 'window left' },
      ['<a-j>'] = { "<cmd>lua require('Navigator').down()<cr>", 'window down' },
      ['<a-k>'] = { "<cmd>lua require('Navigator').up()<cr>", 'window up' },
      ['<a-l>'] = { "<cmd>lua require('Navigator').right()<cr>", 'window right' },
      ['<a-b>'] = {
        "<cmd>lua require('Navigator').previous()<cr>",
        'window back',
      },
      ['<a-c>'] = { '<cmd>BufferClose!<cr>', 'close buffer' },
      ['<a-o>'] = {
        '<cmd>BufferCloseBuffersRight<cr><cmd>BufferCloseBuffersLeft<cr><c-w>o',
        'buffer only',
      },
      ['<a-m>'] = {
        '<cmd>TroubleToggle lsp_workspace_diagnostics<cr>',
        'lsp diagnostics',
      },
      ['<a-M>'] = {
        '<cmd>TroubleToggle lsp_document_diagnostics<cr>',
        'lsp document diagnostics',
      },
      ['<a-q>'] = { '<cmd>TroubleToggle quickfix<cr>', 'quickfix' },
      ['<a-u>'] = { '<cmd>TroubleToggle loclist<cr>', 'loclist' },
      ['<a-r>'] = { '<cmd>TroubleToggle lsp_references<cr>', 'lsp reference' },
      ['<a-s>'] = {
        '<cmd>SymbolsOutline<cr>',
        'symbols',
      },
      ['<a-x>'] = { '<cmd>q<cr>', 'close window' },
      ['<a-z>'] = { '<cmd>ZenMode<cr>', 'zen mode' },
      ['<c-l>'] = {
        "<cmd>nohlsearch<cr><cmd>lua require('hlslens.main').cmdl_search_leave()<cr>",
        'nohlsearch',
      },
      ['<c-n>'] = {
        '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>',
        'next occurence',
      },
      ['<c-p>'] = {
        '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>',
        'previous occurence',
      },
      ['<a-s-r>'] = { '<cmd>BufferMoveNext<cr>', 'move buffer next' },
      ['<a-s-e>'] = { '<cmd>BufferMovePrevious<cr>', 'move buffer previous' },
      ['<c-a>'] = { '<cmd>b#<cr>' }, -- FIXME
      ['<c-s>'] = { '<cmd>w!<cr>', 'save' },
      ['<c-g>'] = {
        "<cmd>lua require'nononotes'.prompt('edit', false, 'all')<cr>",
        'pick note',
      },
      -- ['<c-w>'] = {
      --   L = { '<cmd>vsplit<cr>', 'split left' },
      --   J = { '<cmd>split<cr>', 'split down' },
      -- },
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

  -- for mode in string.gmatch('nx', '.') do
  --   wk.register({}, {mode = mode})
  -- end

  -- nvo mappings
  for mode in string.gmatch('nvo', '.') do
    wk.register({
      -- local movements
      g = {
        name = '+local movements',
        h = { '<cmd>Telescope heading<cr>', 'heading' }, --
        ['é'] = {
          "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>",
          'current buffer fuzzy find',
        },
        S = {
          "<cmd>lua require('telescope.builtin').treesitter()<cr>",
          'treesitter',
        },
        L = { "<cmd>lua require('telescope.builtin').loclist()<cr>", 'loclist' },
        -- i = { "]'", 'next lowercase mark' },
        -- I = { "['", 'previous lowercase mark' },
        -- u = { ']`', "next lowercase mark's line" },
        -- U = { '[`', "previous lowercase mark's line" },
        a = { '%', 'cycle matching elements' },
      },
    }, {
      mode = mode,
    })
  end

  -- visual selection
  for mode in string.gmatch('nx', '.') do
    wk.register({
      ['é'] = { '/', 'search' },
      ['É'] = { '?', 'backward' },
      K = {
        name = '+visual selection',
        s = { '<c-v>', 'square selection' },
        K = { 'gv', 'reselect' },
      },
      m = {
        name = '+edit',
        J = { 'gJ' },
        n = { '<cmd>lua vim.lsp.buf.rename()<cr>', 'rename' },
        s = {
          "<cmd>lua require('telescope.builtin').spell_suggest(require('telescope.themes').get_cursor{})<cr>",
          'spell suggest',
        },
        u = { 'gu', 'uppercase' },
        U = { 'gU', 'uppercase' },
        ['~'] = { 'g~', 'toggle case' },
        t = { '>>', 'indent' },
        T = { '<<', 'dedent' },
        a = {
          "<cmd>lua require('telescope.builtin').lsp_code_actions(require('telescope.themes').get_cursor{})<cr>",
          'code actions',
        },
        A = {
          "<cmd>lua require('telescope.builtin').lsp_range_code_actions(require('telescope.themes').get_cursor{})<cr>",
          'range code actions',
        },
        S = {
          "<cmd>lua require'telescope.builtin'.symbols{ sources = {'math', 'emoji'} }<cr>",
          'symbols',
        },
      },
    }, {
      mode = mode,
    })
  end

  -- n mappings
  wk.register {
    Y = {
      b = {
        "<cmd>lua require('telescope').extensions.bookmarks.bookmarks()<cr>",
        'bookmarks',
      },
      u = {
        '<Cmd>call jobstart(["opener", expand("<cfile>")], {"detach": v:true})<cr>',
        'open current url',
      },
      gr = { '<cmd>BrowserSearchGh<cr>', 'github repo' },
      man = { '<cmd>BrowserMan<cr>', 'man page' },
    },
    -- global movements
    g = {
      m = { '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', 'go next diagnostic' },
      M = {
        '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>',
        'go previous diagnostic',
      },
    },
    q = {
      name = '+global movements',
      -- n = { '<cmd>Telescope node_modules list<cr>', 'node modules' },
      e = { 'm', 'set mark' },
      E = { '<esc>:delmarks ', 'del mark' },
      D = { '<cmd>lua vim.lsp.buf.declaration()<cr>', 'go declaration' },
      i = {
        '<cmd>require("telescope.").builtin.lsp_implementations()<cr>',
        'go implementation',
      },
      d = {
        '<cmd>require("telescope.builtin").lsp_definitions()<cr>',
        'go definition',
      },
      ['é'] = {
        "<cmd>lua require('telescope.builtin').live_grep()<cr>",
        'live grep',
      },
      r = {
        "<cmd>lua require('telescope.builtin').lsp_references()<cr>",
        'lsp references',
      },
      t = {
        '<cmd>lua require("trouble").next({skip_groups = true, jump = true})<cr>',
        'trouble, next',
      },
      T = {
        '<cmd>lua require("trouble").previous({skip_groups = true, jump = true})<cr>',
        'trouble, previous',
      },
      ['.'] = {
        "<cmd>lua require('telescope.builtin').find_files({find_command={'ls-dots'}, })<cr>",
        'dofiles',
      },
      o = { "<cmd>lua require('telescope.builtin').oldfiles()<cr>", 'oldfiles' },
      [' '] = {
        "<cmd>lua require'plugins.telescope'.project_files()<cr>",
        'project file',
      },
      w = { '<cmd>Rg <cword><cr>', 'rg current word' },
      b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", 'buffers' },
    },
    H = {
      name = '+help',

      m = {
        "<cmd>lua require('telescope.builtin').man_pages()<cr>",
        'man pages',
      },
      c = { '<cmd>Cheatsheet<cr>', 'cheatsheet' },
      p = { '<cmd>Mdhelp<cr>', 'md help' },
      v = {
        "<cmd>lua require('telescope.builtin').help_tags()<cr>",
        'help tags',
      },
    },
    ['<leader>'] = {
      p = {
        name = '+picker',
        -- telescope.load_extension 'node_modules'
        p = { '<cmd>SearchSession<cr>', 'sessions' },
        [';'] = {
          "<cmd>lua require('telescope.builtin').commands()<cr>",
          'commands',
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
        x = {
          '<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<cr>',
          'stop active clients',
        },
        m = {
          '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>',
          'show line diagnostics',
        },
        r = { '<cmd>lua vim.lsp.buf.references()<cr>', 'references' },
        h = { '<cmd>ProDoc<cr>', 'prepare doc comment' },
        H = { '<cmd>CheatDetect<cr>', 'Cheat' },
      },
      s = {
        name = '+Spell',
        e = { '<cmd>setlocal spell spelllang=en_us,cjk<cr>', 'en' },
        f = { '<cmd>setlocal spell spelllang=fr,cjk<cr>', 'fr' },
        b = { '<cmd>setlocal spell spelllang=en_us,fr,cjk<cr>', 'en fr' },
        x = { '<cmd>setlocal nospell spelllang=<cr>', 'none' },
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
        l = { "<cmd>lua require'plugins.dap'.launch()<cr>", 'launch' },
        r = { "<cmd>lua require'dap'.repl.open()<cr>", 'repl' },
        a = { "<cmd>lua require'plugins.dap'.attach()<cr>", 'attach' },
        A = {
          "<cmd>lua require'plugins.dap'.attachToRemote()<cr>",
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
    },
  }

  mapBrowserSearch('Y', '+browser search', {
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
    local trouble = require 'trouble.providers.telescope'
    return {
      defaults = {
        mappings = {
          i = {
            ['<c-q>'] = actions.send_to_qflist,
            ['<c-l>'] = actions.send_to_loclist,
            ['<c-t>'] = trouble.open_with_trouble,
          },
          n = {
            ['<c-j>'] = actions.file_split,
            ['<c-l>'] = actions.file_vsplit,
            ['<c-t>'] = trouble.open_ith_trouble,
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
        [','] = 'textsubjects-big',
      },
    },
  },
  gitsigns = {
    keymaps = {
      name = 'git',
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
