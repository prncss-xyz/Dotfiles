local M = {}
local invert = require('modules.utils').invert

local function s(char)
  return '<s-' .. char .. '>'
end

local function alt(key)
  return string.format('<a-%s>', key)
end

local a = invert {
  g = 'jump',
  H = 'help',
  h = 'edit',
  z = 'move',
  m = 'mark',
  Q = 'macro',
  q = 'editor',
  o = 'various',
  [' '] = 'leader',
}
local dd = invert {
  a = 'diagnostic',
  b = 'join',
  c = 'comment',
  g = 'ninja',
  u = 'git',
  j = 'up',
  k = 'down',
  L = 'loclist',
  l = 'left',
  s = 'symbol',
  z = 'spell',
  [';'] = 'right',
  ['é'] = 'search',
  ['<c-j>'] = 'next_search',
  ['<c-x>'] = 'prev_search',
}
local qualifiers = {
  p = 'previous',
  n = 'next',
  h = 'hint',
}
local q = invert(qualifiers)

local function plug(t)
  if type(t) == 'string' then
    t = { t }
  end
  t.noremap = false
  t[1] = '<plug>' .. t[1]
  return t
end

local rep = require('bindutils').repeatable

local function replug(t)
  if type(t) == 'string' then
    t = { t }
  end
  t.noremap = false
  t[1] = rep('<plug>' .. t[1])
  return t
end

local function cmd(t)
  if type(t) == 'string' then
    t = { t }
  end
  t[1] = '<cmd>' .. t[1] .. '<cr>'
  return t
end

local function map_command_lang()
  -- TODO:
  -- - dedent
  -- - remap cmp c-e
  -- - map('i', '<a-t>', '<esc>"zdh"zpa') -- transpose
  local reg = require('modules.binder').reg
  reg {
    modes = {
      -- TODO: l is not what I thought
      nvoil = {
        ['<c-c>'] = '<esc>',
        ['<c-n>'] = { '<down>' }, -- FIXME: won't work line <down> in command mode
        ['<c-p>'] = { '<up>' }, -- FIXME: won't work line <down> in command mode
        ['<c-q>'] = { '<cmd>qall!<cr>', 'quit' },
      },
      l = {
        ['<c-a>'] = '<home>',
        ['<c-b>'] = '<left>',
        ['<c-d>'] = '<c-h>',
        ['<c-e>'] = '<end>',
        ['<c-f>'] = '<right>',
        ['<c-g>'] = '<c-right>',
        ['<c-h>'] = '<c-left>',
        ['<c-u>'] = '<c-u>',
        ['<c-w>'] = '<c-w>',
      },
    },
  }
  reg {
    modes = {
      i = {
        ['<c-k>'] = '<c-o>d$',
        ['<c-o>'] = '<c-o>',
        ['<c-v>'] = '<esc>pa',
      },
      is = {
        ['<Tab>'] = { require('bindutils').tab },
        ['<s-Tab>'] = { require('bindutils').s_tab },
        ['<c-e>'] = { require('bindutils').cmp_toggle },
        ['<c-f>'] = { require('bindutils').cmp_confirm },
      },
      c = {
        ['<c-s>'] = { '<c-f>', 'edit command line' },
        ['<c-v>'] = { '<c-r>+', 'paste to command line' },
      },
    },
    ['<c-a>'] = { modes = { i = '<c-o>^', nv = '^' } },
    ['<c-e>'] = { modes = { i = '<c-o>$', nv = '$' } },
  }
end

local function map_search(url, help)
  return {
    modes = {
      n = {
        function()
          require('modules.browser').search_cword(url)
        end,
        help,
      },
      x = {
        function()
          require('modules.browser').search_visual(url)
        end,
        help,
      },
    },
  }
end

local function map_basic()
  -- TODO:
  -- - map('n', '<a-t>', '"zdh"zp') -- transpose
  -- - map reselect "gv"
  -- al = { '<Plug>(textobj-line-a)', 'line' },
  -- il = { '<Plug>(textobj-line-i)', 'line' },
  local reg = require('modules.binder').reg
  reg {
    A = 'A',
    a = 'a',
    B = plug { '(matchup-g%)', 'matchup cycle backward', modes = 'nxo' },
    b = plug { '(matchup-%)', 'matchup cycle forward', modes = 'nxo' },
    C = { '<nop>', modes = 'nx' },
    c = { '""c', modes = 'nx' },
    D = { '<nop>', modes = 'nx' },
    d = { '""d', modes = 'nx' },
    E = { 'W', 'previous bigword', modes = 'nxo' },
    -- e = { 'w', 'next word ', modes = 'nxo' },
    e = plug { 'CamelCaseMotion_w', 'next subword ', modes = 'nxo' },
    f = { require('bindutils').meta_move, mode = true, modes = 'nxo' },
    I = 'I',
    i = 'i',
    p = {
      require('flies').repeat_previous,
      mode = true,
      modes = 'nxo',
    },
    n = { require('flies').repeat_next, mode = true, modes = 'nxo' },
    O = { '<nop>', modes = 'nx' },
    o = { '<nop>', modes = 'nx' },
    R = { 'R', modes = 'nx' },
    r = { 'r', modes = 'nx' },
    s = {
      function()
        require('hop').hint_char2 {
          char2_fallback_key = '<cr>',
        }
      end,
      'hop char2',
      modes = 'nxo',
    },
    T = {
      modes = {
        x = require('bindutils').pre,
        o = plug '(ninja-left-foot-inner)',
      },
    },
    t = {
      modes = {
        n = function()
          require('bindutils').tobj_extreme()
        end,
        x = require('bindutils').post,
        o = plug '(ninja-right-foot-inner)',
      },
    },
    ou = 'U',
    u = 'u',
    V = { '<c-v>', modes = 'nxo' },
    v = { modes = {
      x = 'V',
      n = 'v',
    } },
    W = '<nop>',
    -- W = { 'B', 'previous word', modes = 'nxo' },
    -- w = { 'b', 'next word', modes = 'nxo' },
    w = plug { 'CamelCaseMotion_b', 'previous subword ', modes = 'nxo' },
    X = { '"+d$', modes = 'nx' },
    x = { '"+d', modes = 'nx' },
    cc = '""S',
    dd = '""dd',
    xx = '"+dd',
    -- ['É'] = { '?', modes = 'nxo' },
    -- ['é'] = { '/', modes = 'nxo' },
    ['.'] = '.',
    ['!'] = { '!', modes = 'nx' },
    ['!!'] = { '!!', modes = 'nx' },
    ['='] = { '=', modes = 'nx' },
    ['=='] = { '==', modes = 'nx' },
    ['"'] = '"',
    ['<space>'] = { ':', modes = 'nx' },
    [','] = {
      name = 'hint',
      modes = {
        n = '`',
        x = ':lua require("tsht").nodes()<CR>',
        o = function()
          require('tsht').nodes()
        end,
      },
      [','] = { require('modules.alt-jump').toggle, 'alt-jump' },
    },
    ['<c-i>'] = '<c-i>',
    ['<c-n>'] = {
      function()
        require('bufjump').forward()
      end,
      'jump next buffer',
    },
    ['<c-o>'] = '<c-o>',
    ['<c-p>'] = {
      function()
        require('bufjump').backward()
      end,
      'jump previous buffer',
    },
    ['<c-r>'] = '<c-r>',
    ['<c-g>'] = cmd { 'Telescope luasnip', modes = 'ni' },
    ['<c-s>'] = {
      function()
        vim.lsp.buf.formatting_sync()
      end,
      modes = 'ni',
    },
    ['<c-v>'] = { 'gp', modes = 'nv' },
    ['<c-w>'] = {
      r = plug { '(Visual-Split-VSResize)', modes = 'x' },
      S = plug { '(Visual-Split-VSSplit)', modes = 'x' },
      [dd.up] = plug { '(Visual-Split-VSSplitAbove)', modes = 'x' },
      [dd.down] = plug { '(Visual-Split-VSSplitBelow)', modes = 'x' },
    },
    ['<a-a>'] = cmd { 'e#', 'previous buffer' },
    ['<a-b>'] = cmd { 'wincmd p', 'window back' },
    ['<a-w>'] = cmd { 'q', 'close window' },
    [dd.right] = { 'l', 'right', modes = 'nxo' },
    [dd.left] = { 'h', 'left', modes = 'nxo' },
    [dd.up] = { 'k', 'up', modes = 'nxo' },
    [dd.down] = { 'j', 'down', modes = 'nxo' },
    [dd.prev_search] = {
      "luasnip#choice_active() ? '<plug>luasnip-next-choice' : '<plug>(dial-increment)'",
      noremap = false,
      expr = true,
      modes = 'nx',
    },
    [dd.next_search] = {
      "luasnip#choice_active() ? '<plug>luasnip-previous-choice' : '<plug>(dial-decrement)'",
      noremap = false,
      expr = true,
      modes = 'nx',
    },
    [alt(dd.left)] = { require('modules.wrap_win').left, 'window left' },
    [alt(dd.down)] = { require('modules.wrap_win').down, 'window down' },
    [alt(dd.up)] = { require('modules.wrap_win').up, 'window up' },
    [alt(dd.right)] = { require('modules.wrap_win').right, 'window right' },
    -- normal mode only, because mapped to o
    [a.various] = {
      pb = function()
        require('neoscroll').zt(250)
      end,
      b = function()
        require('neoscroll').zb(250)
      end,
      c = function()
        require('neoscroll').zz(250)
      end,
      d = {
        name = '+DAP',
        b = {
          "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
          'toggle breakpoints',
        },
        c = { "<cmd>lua require'dap'.continue()<cr>", 'continue' },
        s = { "<cmd>lua require'dap'.stop()<cr>", 'stop' },
        o = { "<cmd>lua require'dap'.step_over()<cr>", 'step over' },
        po = { "<cmd>lua require'dap'.step_out()<cr>", 'step out' },
        i = { "<cmd>lua require'dap'.step_into()<cr>", 'step into' },
        ['.'] = { "<cmd>lua require'dap'.run_last()<cr>", 'run last' },
        -- u = { "<cmd>lua require'dapui'.eval()<cr>", 'toggle dapui' },
        k = { "<cmd>lua require'dap'.up()<cr>", 'up' },
        j = { "<cmd>lua require'dap'.down()<cr>", 'down' },
        l = { "<cmd>lua require'plugins.dap'.launch()<cr>", 'launch' },
        r = { "<cmd>lua require'dap'.repl.open()<cr>", 'repl' },
        a = { "<cmd>lua require'plugins.dap'.attach()<cr>", 'attach' },
        pa = {
          "<cmd>lua require'plugins.dap'.attachToRemote()<cr>",
          'attach to remote',
        },
        h = { "<cmd>lua require'dap.ui.widgets'.hover()<cr>", 'widgets' },
        ph = { "<cmd>lua require'dap.ui.variables'.hover()<cr>", 'hover' },
        v = {
          "<cmd>lua require'dap.ui.variables'.visual_hover()<cr>",
          'visual hover',
        },
        ['?'] = {
          "<cmd>lua require'dap.ui.variables'.scopes()<cr>",
          'variables scopes',
        },
        pb = {
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
      q = {
        r = plug '(Mac_RecordNew)',
        n = plug '(Mac_RotateBack)',
        pn = plug '(Mac_RotateForward)',
        a = plug '(Mac_Append)',
        pa = plug '(Mac_Prepend)',
        w = plug '(Mac_NameCurrentMacro)',
        fw = plug '(Mac_NameCurrentMacroForFileType)',
        sw = plug '(Mac_NameCurrentMacroForCurrentSession)',
        l = cmd 'DisplayMacroHistory',
        [a.macro] = { '<plug>(Mac_Play)', noremap = false },
        [dd.search] = {
          w = plug '(Mac_SearchForNamedMacroAndOverwrite)',
          r = plug '(Mac_SearchForNamedMacroAndRename)',
          d = plug '(Mac_SearchForNamedMacroAndDelete)',
          [a.macro] = plug '(Mac_SearchForNamedMacroAndPlay)',
        },
      },
      s = {
        name = '+LSP',
        a = {
          function()
            vim.diagnostic.open_float(nil, { source = 'always' })
          end,
          'show line diagnostics',
        },
        pc = { vim.lsp.buf.incoming_call, 'incoming calls' },
        c = { vim.lsp.buf.outgoing_calls, 'outgoing calls' },
        d = { require('bindutils').peek_definition, 'hover definition' }, -- FIXME:
        k = { vim.lsp.buf.hover, 'hover' },
        r = { vim.lsp.buf.references, 'references' },
        s = { vim.lsp.buf.signature_help, 'signature help' },
        t = { vim.lsp.buf.type_definition, 'go to type definition' },
        w = {
          name = 'worspace folder',
          a = { vim.lsp.buf.add_workspace_folder, 'add workspace folder' },
          l = { vim.lsp.buf.list_workspace_folder, 'rm workspace folder' },
          d = { vim.lsp.buf.remove_workspace_folder, 'rm workspace folder' },
        },
        x = {
          function()
            vim.lsp.stop_client(vim.lsp.get_active_clients())
          end,
          'stop active clients',
        },
      },
      v = 'gv',
      y = {
        arch = map_search(
          'https://wiki.archlinux.org/index.php?search=',
          'archlinux wiki'
        ),
        aur = map_search(
          'https://aur.archlinux.org/packages/?K=',
          'aur packages'
        ),
        ca = map_search(
          'https://www.cairn.info/resultats_recherche.php?searchTerm=',
          'cairn'
        ),
        cn = map_search('https://www.cnrtl.fr/definition/', 'cnrtl'),
        d = map_search('https://duckduckgo.com/?q=', 'duckduckgo'),
        eru = map_search(
          'https://www.erudit.org/fr/recherche/?funds=%C3%89rudit&funds=UNB&basic_search_term=',
          'erudit'
        ),
        fr = map_search(
          'https://pascal-francis.inist.fr/vibad/index.php?action=search&terms=',
          'francis'
        ),
        gh = map_search('https://github.com/search?q=', 'github'),
        go = map_search('https://google.ca/search?q=', 'google'),
        lh = map_search('https://www.libhunt.com/search?query=', 'libhunt'),
        man = { require('modules.browser').man, 'man page' },
        mdn = map_search(
          'https://developer.mozilla.org/en-US/search?q=',
          'mdn'
        ),
        nell = map_search(
          'https://nelligan.ville.montreal.qc.ca/search*frc/a?searchtype=Y&searcharg=',
          'nelligan'
        ),
        npm = map_search('https://www.npmjs.com/search?q=', 'npm'),
        o = {
          '<cmd>call jobstart(["xdg-open", expand("<cfile>")]<cr>, {"detach": v:true})<cr>',
          'open current file',
        },
        pp = { require('modules.setup-session').launch, 'session lauch' },
        pac = map_search('https://archlinux.org/packages/?q=', 'arch packages'),
        sea = map_search(
          'https://www.seriouseats.com/search?q=',
          'seriouseats'
        ),
        sep = map_search(
          'https://plato.stanford.edu/search/searcher.py?query=',
          'sep'
        ),
        sp = map_search(
          'https://www.persee.fr/search?ta=article&q=',
          'persée'
        ),
        st = map_search(
          'https://usito.usherbrooke.ca/d%C3%A9finitions/',
          'usito'
        ),
        u = {
          require('modules.browser').open_file,
          'open current file',
        },
        we = map_search('https://en.wikipedia.org/wiki/', 'wikipidia en'),
        wf = map_search('https://fr.wikipedia.org/wiki/', 'wikipidia fr'),
        y = map_search(
          'https://www.youtube.com/results?search_query=',
          'youtube'
        ),
      },
      z = {
        name = '+Spell',
        b = cmd { 'setlocal spell spelllang=en_us,fr,cjk', 'en fr' },
        e = cmd { 'setlocal spell spelllang=en_us,cjk', 'en' },
        f = cmd { 'setlocal spell spelllang=fr,cjk', 'fr' },
        g = cmd { 'zg', 'add to spellfile' },
        x = cmd { 'setlocal nospell spelllang=', 'none' },
      },
    },
    [a.jump] = {
      pa = {
        function()
          require('bindutils').search(false)
        end,
        modes = 'nxo',
      },
      a = {
        function()
          require('bindutils').search(true)
        end,
        modes = 'nxo',
      },
      pb = {
        a = function()
          require('marks').prev_bookmark0()
        end,
        s = function()
          require('marks').prev_bookmark1()
        end,
        d = function()
          require('marks').prev_bookmark2()
        end,
        f = function()
          require('marks').prev_bookmark3()
        end,
        b = plug '(Marks-prev-bookmark)',
      },
      b = {
        a = function()
          require('marks').next_bookmark0()
        end,
        s = function()
          require('marks').next_bookmark1()
        end,
        d = function()
          require('marks').next_bookmark2()
        end,
        f = function()
          require('marks').next_bookmark3()
        end,
        b = plug '(Marks-next-bookmark)',
      },
      pc = {
        function()
          require('bindutils').search_asterisk(false)
        end,
        noremap = false,
        modes = 'nx',
      },
      c = {
        function()
          require('bindutils').search_asterisk(true)
        end,
        noremap = false,
        modes = 'nx',
      },
      pd = { vim.diagnostic.goto_prev, 'go previous diagnostic' },
      d = { vim.diagnostic.goto_next, 'go next diagnostic' },
      h = { '(matchup-z%)', 'matchup inward', modes = 'nxo' },
      g = { '``', 'before last jump' },
      -- pn = {
      --   function()
      --     require('bindutils').n(false)
      --   end,
      --   modes = 'nxo',
      -- },
      -- n = {
      --   function()
      --     require('bindutils').n(true)
      --   end,
      --   modes = 'nxo',
      -- },
      o = { '`.', 'last change' },
      -- L = cmd 'Telescope loclist',
      pl = { '`[', 'start of last mod', modes = 'nxo' },
      l = { '`]', 'begin of last mod', modes = 'nxo' },
      pq = plug { '(Marks-prev)', name = 'Goes to previous mark in buffer.' },
      q = plug { '(Marks-next)', name = 'Goes to next mark in buffer.' },
      -- s = cmd 'Telescope treesitter',
      s = cmd 'Telescope lsp_document_symbols',
      pu = require('bindutils').scroll_up,
      u = require('bindutils').scroll_down,
      pv = { '`<', modes = 'nxo' },
      v = { '`>', modes = 'nxo' },
      Y = { '(matchup-[%)', 'matchup backward', modes = 'nxo' },
      y = { '(matchup-]%)', 'matchup forward', modes = 'nxo' },
      -- Z = { '<cmd>lua require"bindutils".spell_next(-1)<cr>', 'prevous misspelled' },
      -- z = { '<cmd>lua require"bindutils".spell_next()<cr>', 'next misspelled' },
      ['p;'] = { 'g,', 'newer change' },
      [';'] = { 'g;', 'older changer' },
      [q.previous .. dd.spell] = { '[s', 'prevous misspelled' },
      [dd.spell] = { ']s', 'next misspelled' },
      [dd.search] = cmd {
        'Telescope current_buffer_fuzzy_find',
        'Telescope current_buffer_fuzzy_find',
        modes = 'nxo',
      },
      [dd.up] = { 'gk', 'visual up', modes = 'nxo' },
      [dd.down] = { 'gj', 'visual down', modes = 'nxo' },
    },
    [a.edit] = {
      name = '+edit',
      a = {
        modes = {
          n = function()
            vim.lsp.buf.code_action()
          end,
          -- n = { '<cmd>lua vim.lsp.buf.code_action()<cr>' },
          v = { ":'<,'>lua vim.lsp.buf.range_code_action()<cr>" },
        },
      },
      -- a = cmd { 'CodeActionMenu', 'code action', modes = 'nx' },
      b = { 'gi', 'last insert point' },
      -- f = cmd { 'Telescope refactoring', 'refactoring', modes = 'nx' },
      h = {
        name = '+annotate',
        c = {
          function()
            require('neogen').generate { type = 'class' }
          end,
          'class',
        },
        f = {
          function()
            require('neogen').generate { type = 'func' }
          end,
          'function',
        },
        t = {
          function()
            require('neogen').generate { type = 'class' }
          end,
          'type',
        },
      },
      i = { '>>', 'indent', modes = 'nx' },
      po = 'O',
      o = 'o',
      pr = plug {
        '(buffet-operator-extract)',
        'buffet extract',
        modes = 'nx',
      },
      r = plug {
        '(buffet-operator-replace)',
        'buffet replace',
        modes = 'nx',
      },
      s = { vim.lsp.buf.rename, 'rename' },
      -- s = { vim.lsp.buf.rename, 'rename', modes = 'nx' },
      -- t = { '<<', 'dedent', modes = 'nx' },
      ppu = {
        rep [["zc<C-R>=casechange#next(@z)<CR><Esc>v`[']],
        'change case',
        modes = 'nx',
      }, -- FIXME: not repeatable
      pu = { 'gU', 'uppercase', modes = 'nx' },
      u = { 'gu', 'lowercase', modes = 'nx' },
      v = { 'p', modes = 'nx' },
      pv = { 'P', modes = 'nx' },
      -- v = { 'g~', 'toggle case', modes = 'nx' },
      w = {
        function()
          require('telescope.builtin').symbols {
            sources = { 'math', 'emoji' },
          }
        end,
        'symbols',
        modes = 'n',
      },
      px = plug {
        '(ExchangeClear)',
        modes = 'nx',
      },
      x = {
        name = 'exchange',
        modes = {
          x = plug '(Exchange)',
          n = plug '(Exchange)',
        },
      },
      py = plug { '(buffet-operator-delete)', modes = 'nx' },
      y = plug { '(buffet-operator-add)', modes = 'nx' },
      [','] = cmd 'ISwapWith',
      [dd.spell] = {
        function()
          require('telescope.builtin').spell_suggest(
            require('telescope.themes').get_cursor {}
          )
        end,
        'spell suggest',
        modes = 'nx',
      },
      ['p' .. dd.comment] = plug { '(u-comment-opleader-block)', modes = 'nx' },
      [dd.comment] = {
        modes = {
          n = {
            o = cmd 'lua ___comment_norm_o()',
            O = cmd 'lua ___comment_norm_O()',
            A = cmd 'lua ___comment_norm_A()',
          },
          nx = {
            [''] = plug '(u-comment-opleader-line)',
          },
        },
      },
      [dd.join] = { 'J', 'join', modes = 'nx' },
      ['p' .. dd.join] = {
        modes = {
          n = '<Plug>(u-revj-operator)',
          x = {
            function()
              require('revj').format_visual()
            end,
            'rev join',
          },
        },
      },
      [q.previous .. 't'] = {
        modes = {
          n = plug '(ninja-insert)i',
          x = require('bindutils').pre,
        },
      },
      t = {
        modes = {
          n = plug '(ninja-append)i',
          x = require('bindutils').post,
        },
      },
      [q.previous .. 'f'] = {
        modes = {
          n = plug '(ninja-insert)a',
          x = require('bindutils').pre,
        },
      },
      f = {
        modes = {
          n = plug '(ninja-append)a',
          x = require('bindutils').post,
        },
      },
      [dd.left] = {
        name = 'move left',
        modes = {
          n = replug 'MoveCharLeft',
          x = replug 'MoveBlockLeft',
        },
      },
      [dd.right] = {
        name = 'move right',
        modes = {
          n = replug 'MoveCharRight',
          x = replug 'MoveBlockRight',
        },
      },
      [dd.up] = {
        name = 'move up',
        modes = {
          n = replug 'MoveLineUp',
          x = replug 'MoveBlockUp',
        },
      },
      [dd.down] = {
        name = 'move down',
        modes = {
          n = replug 'MoveLineDown',
          x = replug 'MoveBlockDown',
        },
      },
      [dd.prev_search] = plug { '(dial-increment-additional)', modes = 'x' },
      [dd.next_search] = plug { '(dial-decrement-additional)', modes = 'x' },
      [a.edit] = {
        name = '+line',
        py = { '<Plug>(buffet-operator-delete)il', noremap = false },
        y = { '<Plug>(buffet-operator-add)il', noremap = false },
        pr = { '<Plug>(buffet-operator-extract)il', noremap = false },
        r = { '<Plug>(buffet-operator-replace)il', noremap = false },
        x = plug '(ExchangeLine)',
        [dd.join] = plug '(u-revj-line)',
        [s(dd.comment)] = plug '(u-comment-toggler-block)',
        [dd.comment] = plug '(u-comment-toggler-line)',
      },
    },
    [a.mark] = {
      pb = plug { '(Marks-delete-bookmark)' },
      ba = plug { '(Marks-set-bookmark0)' },
      bs = plug { '(Marks-set-bookmark1)' },
      bd = plug { '(Marks-set-bookmark2)' },
      bf = plug { '(Marks-set-bookmark3)' },
      pd = plug {
        '(Marks-deletebuf)',
        name = 'Deletes all marks in current buffer.',
      },
      d = plug {
        '(Marks-deleteline)',
        name = 'Deletes all marks on current line.',
      },
      ps = plug {
        '(Marks-delete)',
        name = 'Delete a letter mark (will wait for input).',
      },
      s = plug {
        '(Marks-set)',
        name = 'Sets a letter mark (will wait for input).',
      },
      v = plug {
        '(Marks-preview)',
        name = 'Previews mark (will wait for user input). press <cr> to just preview the next mark.',
      },
      [','] = { require('modules.alt-jump').reset, 'alt-jump reset' },
      [a.mark] = plug {
        '(Marks-toggle)',
        name = 'toggle next available mark at cursor',
      },
    },
    [a.move] = {
      name = '+move',
      a = require('bindutils').edit_alt,
      b = cmd 'Telescope buffers',
      pd = cmd 'Telescope lsp_type_definitions', -- also, trouble
      d = cmd 'Telescope lsp_definitions', -- also, trouble
      pi = { vim.lsp.buf.declaration, 'go declaration' }, -- FIXME:
      i = cmd 'Telescope lsp_implementations', -- also, trouble
      -- m = function()
      --   require('telescope.builtin').find_files {
      --     cwd = vim.fn.expand '%:p:h',
      --   }
      -- end,
      m = function()
        require('telescope.builtin').file_browser {
          cwd = vim.fn.expand '%:p:h',
          -- hidden = false,
        }
      end,
      pm = function()
        require('telescope.builtin').file_browser {
          cwd = vim.fn.expand '%:p:h',
          depth = 10,
        }
      end,
      o = cmd 'Telescope oldfiles only_cwd=true',
      -- "Telescope lsp_references"
      w = cmd 'TodoTrouble',
      pw = cmd 'TodoTelescope',
      pr = {
        function()
          require('modules.toggler').open(
            'Trouble lsp_references',
            'TroubleClose'
          )
        end,
        'lsp document diagnostics',
      },
      r = cmd 'Telescope lsp_references',
      pa = {
        function()
          require('modules.toggler').open(
            'Trouble lsp_document_diagnostics',
            'TroubleClose'
          )
        end,
        'lsp document diagnostics',
      },
      pt = {
        function()
          require('trouble').previous { skip_groups = true, jump = true }
        end,
        'trouble, previous',
      },
      t = {
        function()
          require('trouble').next { skip_groups = true, jump = true }
        end,
        'trouble, next',
      },
      [dd.search] = cmd { 'Telescope live_grep', 'live grep' },
      [a.move] = { require('bindutils').project_files, 'project file' },
    },
    [a.help] = {
      d = { require('bindutils').docu_current, 'filetype docu' },
      h = cmd {
        'e ~/Dotfiles/bindings-qwerty/.config/nvim/lua/bindings.lua',
        'bindings',
      }, -- FIXME: use `realpath` instead
      m = cmd { 'Telescope man_pages', 'man pages' },
      p = cmd { 'Telescope md_help', 'md help' },
      v = cmd { 'Telescope help_tags', 'help tags' },
    },
    [a.editor] = {
      pa = {
        function()
          require('modules.toggler').open(
            'Trouble lsp_document_diagnostics',
            'TroubleClose'
          )
        end,
        'lsp document diagnostics',
      },
      a = {
        function()
          require('modules.toggler').open(
            'Trouble lsp_workspace_diagnostics',
            'TroubleClose'
          )
        end,
        'lsp worspace diagnostics',
      },
      pb = { -- FIXME:
        function()
          require('bufjump').backward(require('bufjump').not_under_cwd)
        end,
        'previous workspace',
      },
      b = { -- FIXME:
        function()
          require('bufjump').forward(require('bufjump').not_under_cwd)
        end,
        'next workspace',
      },
      d = function()
        require('modules.toggler').open('DiffviewOpen', 'DiffviewClose')
      end,
      e = { require('bindutils').edit_current, 'current in new editor' },
      f = {
        function()
          require('modules.toggler').open('NvimTreeOpen', 'NvimTreeClose')
        end,
        'nvim tree',
      },
      g = function()
        require('modules.toggler').open('Neogit', ':q')
      end,
      ph = cmd { 'DiffviewClose', 'diffview close' },
      h = cmd { 'DiffviewFileHistory', 'diffview open' },
      i = {
        function()
          require('dapui').toggle()
        end,
        'toggle dapui',
      },
      k = {
        function()
          require('modules.toggler').open('Trouble quickfix', 'TroubleClose')
        end,
        'quickfix',
      },
      m = cmd { 'Telescope installed_plugins', 'plugins' },
      n = cmd { 'Telescope modules', 'node modules' },
      o = { require('bindutils').open_current, 'open current external' },
      pp = { require('modules.setup-session').develop, 'session develop' },
      r = { '<cmd>update<cr><cmd>luafile %<cr>', 'reload' },
      s = { require('bindutils').outliner, 'outliner' },
      ps = {
        function()
          require('modules.toggler').open(
            'TroubleToggle lsp_references',
            'TroubleClose'
          )
        end,
        'lsp references',
      },
      y = {
        function()
          require('modules.toggler').open('UndotreeToggle', 'UndotreeToggle')
        end,
        'undo tree',
      },
      t = { require('bindutils').term, 'new terminal' },
      pu = {
        function()
          require('modules.toggler').open('Gitsigns setqflist', 'TroubleClose')
        end,
        'hunks',
      },
      u = cmd { 'lua require"gitsigns".blame_line{full=true}' },
      w = cmd { 'Telescope my_projects', 'sessions' },
      pw = cmd { 'Telescope project_directory', 'projects' },
      x = {
        function()
          require('bindutils').term_launch { 'xplr', vim.fn.expand '%' }
        end,
        'xplr',
      },
      z = cmd 'ZenMode',
      ['.'] = { require('bindutils').dotfiles, 'dotfiles' },
      ['"'] = {
        function()
          require('nononotes').prompt('edit', false, 'all')
        end,
        'pick note',
      },
      [' '] = cmd { 'Telescope commands', 'commands' },
      [s(a.editor)] = { require('modules.toggler').back, 'toggle' },
      [a.editor] = { require('modules.toggler').toggle, 'toggle' },
    },
  }
end

local function map_textobj_add_name(t, name)
  if type(t) ~= 'table' then
    t = { t }
  end
  t.name = t.name or name
  return t
end

local function map_textobj(key, inner, outer, name)
  local reg = require('modules.binder').reg
  reg {
    modes = {
      ox = {
        ['i' .. key] = map_textobj_add_name(inner, name),
        ['a' .. key] = map_textobj_add_name(outer, name),
      },
    },
  }
end

-- FIXME: not working in visual mode: comment, ninja
-- a: argument (targets)
-- A: parameter (ts)
-- b: brackets (targets)
-- c: comment
-- d: datetime
-- e: entire buffer
-- f: funtion (ts)
-- i: indent
-- j: block (ts)
-- k: call (ts)
-- l: line
-- m: parameter (ts)
-- q: quotes (targets)
-- r: paragraph (builtin)
-- s: sentence
-- t: tag (targets)
-- u: hunk (gitsigns)
-- v: variable segment
-- y: conditional (ts)
-- é: detect (sandwich)
-- z: loop (ts)
-- wW: word (vim)
-- IA (targets)

-- ts: Ajktyz
-- h: gitsigns

-- nlh: next/last/hint (targets)
-- gG: ninja
-- [
-- , hint

local function map_textobjects()
  local map = require('modules.utils').map

  -- entire buffer
  -- map('n', 'fhe', '<cmd>Telescope buffers<cr>')
  -- map('n', 'fe', '<cmd>lua require("bufjump").forward()<cr>')
  -- map('n', 'fpe', '<cmd>lua require("bufjump").backward()<cr>')

  map('nox', 'gi', '<nop>', {})
  map('nox', 'ga', '<nop>', {})
  map('ox', 'ar', 'ap', {})
  map('ox', 'ir', 'ip', {})
  map('ox', 'a' .. dd.git, ':<c-u>Gitsigns select_hunk<cr>')
  -- map('nox', 'f' .. dd.git, '<cmd>Gitsigns next_hunk<cr>')
  -- map('nox', 'fp' .. dd.git, '<cmd>Gitsigns prev_hunk<cr>')
  -- map('nox', 'fhb', '<cmd>lua require"hop".hint_patterns({}, "[({[]")<cr>', {})
  -- map(
  --   'nox',
  --   'fhq',
  --   '<cmd>lua require"hop".hint_patterns({}, "[\'\\"`]")<cr>',
  --   {}
  -- )
  -- map('nox', 'fhl', '<cmd>lua require"hop".hint_lines()<cr>', {})

  vim.g.targets_nl = 'np'
  -- FIXME: targets only does omap (no xmap)
  require('modules.utils').augroup('targetsline', {
    {
      events = { 'user' },
      targets = { 'trgets#mappings#user' },
      command = function()
        vim.fn.call('targets#mappings#extend', {
          {
            ['-'] = { separator = { { d = '-' } } },
            -- a = { argument = { { o = '[([]', c = '[])]', s = ',' } } },
          },
        })
      end,
    },
  })
  -- map_textobj(
  --   q.previous .. dd.ninja,
  --   plug '(ninja-left-foot-inner)',
  --   plug '(ninja-left-foot-a)',
  --   'ninja left foot'
  -- )
  -- map_textobj(
  --   dd.ninja,
  --   plug '(ninja-right-foot-inner)',
  --   plug '(ninja-right-foot-a)',
  --   'ninja right foot'
  -- )
  -- local map = require('modules.binder').map
  -- not working
  -- map('ox', 'z', function()
  --   require('hop').hint_char2 {
  --     direction = require('hop.hint').hintdirection.before_cursor,
  -- end, { noremap = false })
  --   }
  -- local ts1 = require('modules.flies').Treesitter.new
  local p = require('modules.flies').Pair.new
  local queries = {
    q = p '[\'"`"]',
    b = p('[[({]', '[])}]'),
    -- b = p('=', ','),
    -- T = ts1 'tag',
    -- Q = ts1 'string',
    -- a = ts1 'parameter',
    -- f = ts1 'function',
    -- k = ts1 'call',
    -- j = ts1 'block',
    -- y = ts1 'conditional',
    -- z = ts1 'loop',
    -- c = ts1 'comment',
    [' '] = require('modules.flies').Bigword,
  }
  for c in string.gmatch('="\'`,.;:.?+-,*/\\()[]{}', '.') do
    queries[c] = require('modules.flies').Char.new(c)
  end
  require('modules.flies').setup {
    queries = queries,
    qualifiers = {
      p = 'previous',
      n = 'next',
      h = 'hint',
      [''] = 'plain',
    },
    textobjects = {
      i = 'inner',
      a = 'outer',
    },
    -- tobj_qualifier(domain,mode)
    moves = {
      -- f = { domain = 'inner', start = true, exclusive = true },
    },
    -- op_qualifier(domain, mode)
    -- move_next()
    operators = {
      f = 'move_inner_exclusive',
      ox = 'exchange',
    },
  }
  local ts = require('flies.objects.treesitter').new
  local buf = require('flies.objects.buffer').new()
  buf.move_outer_hint = function()
    require('telescope.builtin').buffers()
  end
  buf.move_outer_next = function()
    require('bufjump').forward()
  end
  buf.move_outer_previous = function()
    require('bufjump').backward()
  end
  require('flies').setup {
    queries = {
      ['<cr>'] = require('flies.objects.line').new(),
      e = buf,
      i = require('flies.objects.indent').new(),
      T = ts 'tag',
      Q = ts 'string',
      a = ts 'parameter',
      f = ts 'function',
      k = ts 'call',
      j = ts 'block',
      y = ts 'conditional',
      z = ts 'loop',
      c = ts 'comment',
    },
    qualifiers = {
      p = 'previous',
      n = 'next',
      h = 'hint',
      [''] = 'plain',
    },
    textobjects = {
      i = 'inner',
      a = 'outer',
    },
    maps = {
      F = {
        domain = 'inner',
        start = true,
      },
    },
  }
end

local function map_markdown()
  local reg = require('modules.binder').reg_local
  reg {
    ['<c-a>'] = { modes = { nvo = 'g^', i = '<c-o>g^' } },
    ['<c-e>'] = { modes = { nvo = 'g$', i = '<c-o>g$' } },
    [dd.up] = { 'gk', 'visual line up', modes = 'nxo' },
    [dd.down] = { 'gj', 'visual line down', modes = 'nxo' },
    [a.move] = {
      y = plug { 'Markdown_OpenUrlUnderCursor', 'follow url' },
    },
    [a.jump] = {
      s = { '<cmd>Telescope heading<cr>', 'headings' },
      t = plug { 'Markdown_MoveToNextHeader', 'next header', modes = 'nxo' },
      pt = plug {
        'Markdown_MoveToPreviousHeader',
        'previous header',
        modes = 'nxo',
      },
      h = plug { 'Markdown_MoveToCurHeader', 'current header', modes = 'nxo' },
      ph = plug {
        'Markdown_MoveToParentHeader',
        'parent header',
        modes = 'nxo',
      },
      [dd.up] = { 'k', 'physical line up', modes = 'nxo' },
      [dd.down] = { 'j', 'physical line down', modes = 'nxo' },
    },
  }
  if require('pager').full then
    -- vim.fn.call('textobj#sentence#init', {})
    reg {
      -- both are identical
      ad = { '<Plug>(textobj-datetime-auto)', noremap = false, modes = 'ox' },
      id = { '<Plug>(textobj-datetime-auto)', noremap = false, modes = 'ox' },
    }
  end
end

local function map_readonly()
  if vim.bo.buftype == 'prompt' then
    local map = require('modules.utils').buf_map
    map('nxo', '<esc>', ':q!<cr>')
    map('nxo', '<a-w>', ':q!<cr>')
    map('nxo', '<c-c>', ':q!<cr>')
    map('si', '<a-w>', '<esc>:q!<cr>')
    map('si', '<c-c>', '<esc>:q!<cr>')
  end

  -- buftype=prompt => map alt-w to :q!
  -- vim.bo.buftype = 'prompt'

  -- buftype=prompt => map alt-w to :q!
  -- vim.bo.buftype = 'prompt'
  if not vim.bo.readonly then
    return
  end
  local reg = require('modules.binder').reg_local
  reg {
    -- x = { '<cmd>q<cr>', nowait = true },
    u = { '<c-u>', noremap = false, nowait = true },
    d = { '<c-d>', noremap = false, nowait = true },
  }
end

function M.setup()
  local map = require('modules.utils').map
  map('nxo', 'q', '<nop>')
  map('nxo', a.edit, '<nop>')
  map('nxo', a.jump, '<nop>')
  map('nxo', a.move, '<nop>')
  map('nxo', a.mark, '<nop>')
  map('nxo', a.macro, '<nop>')
  map('nxo', a.editor, '<nop>')
  map('nxo', a.help, '<nop>')
  -- map('nxo', 'n', '<nop>')
  -- map('nxo', 'N', '<nop>')
  map('nxo', 'gg', '<nop>')
  map('nxo', "g'", '<nop>')
  map('nxo', 'g`', '<nop>')
  map('nxo', 'g~', '<nop>')
  map('nxo', 'gg', '<nop>')
  map('nxo', 'gg', '<nop>')
  map('', '<c-u>', '<nop>')
  map('', '<c-d>', '<nop>')
  require('modules.utils').augroup('ReadonlyMappings', {
    {
      events = { 'BufNew' },
      targets = { '*' },
      command = map_readonly,
    },
  })
  require('modules.utils').augroup('MarkdownBindings', {
    {
      events = { 'FileType' },
      targets = { 'markdown' },
      command = map_markdown,
    },
  })
  -- ordering of the matters for: i) overriding, ii) captures
  map_command_lang()
  map_basic()
  map_textobjects()
  -- require('modules.utils').dump(require('modules.binder').counters)
end

local vim = vim

M.plugins = {
  trouble = {
    close = {},
    refresh = 'r',
    jump = '<cr>',
    cancel = '<c-c>',
    open_split = '<c-x>',
    open_vsplit = '<c-v>',
    jump_close = 'o',
    toggle_fold = 'z',
    close_folds = {},
    open_folds = {},
    next = dd.down,
    previous = dd.up,
  },
  textobj = {
    g = {
      ['textobj#sentence#select'] = 's',
      ['textobj#sentence#move_p'] = 'S',
      ['textobj#sentence#move_n'] = 's',
    },
  },
  nononotes = invert {
    ['<c-k>'] = 'print_hover_title',
  },
  telescope = function()
    local actions = require 'telescope.actions'
    return {
      i = {
        ['<c-q>'] = actions.send_to_qflist,
        ['<c-l>'] = actions.send_to_loclist,
        ['<c-t>'] = function(...)
          require('trouble.providers.telescope').open_with_trouble(...)
        end,
        ['<c-c>'] = function()
          vim.cmd 'stopinsert'
        end,
      },
      n = {
        ['<c-j>'] = actions.file_split,
        ['<c-l>'] = actions.file_vsplit,
        ['<c-t>'] = function(...)
          require('trouble.providers.telescope').open_with_trouble(...)
        end,
        ['<c-c>'] = actions.close,
      },
    }
  end,
  nvim_tree = {
    a = 'create',
    d = 'remove',
    l = 'parent_node',
    L = 'dir_up',
    K = 'last_sibling',
    J = 'first_sibling',
    o = 'system_open',
    p = 'paste',
    r = 'rename',
    R = 'refresh',
    t = 'next_sibling',
    T = 'prev_sibling',
    v = 'next_git_item',
    V = 'prev_git_item',
    x = 'cut',
    yl = 'copy_name',
    yp = 'copy_path',
    ya = 'copy_absolute_path',
    yy = 'copy',
    [';'] = 'edit',
    ['.'] = 'toggle_ignored',
    ['h'] = 'toggle_help',
    ['<bs>'] = 'close_node',
    ['<tab>'] = 'preview',
    ['<s-c>'] = 'close_node',
    ['<c-r>'] = 'full_rename',
    ['<c-t>'] = 'tabnew',
    ['<c-x>'] = 'split',
  },
}

return M
