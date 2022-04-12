local M = {}
local invert = require('utils').invert

local function s(char)
  return '<s-' .. char .. '>'
end

local function alt(key)
  return string.format('<a-%s>', key)
end

local a = require('bindings.parameters').a
local dd = require('bindings.parameters').d
local p = require('bindings.parameters').p

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
        ['<c-v>'] = cmd 'normal! Pl',
      },
      is = {
        ['<s-tab>'] = { require('bindutils').s_tab },
        ['<tab>'] = { require('bindutils').tab },
        ['<c-e>'] = { require('plugins.cmp').utils.toggle },
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

local count = 0

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

local function map_basic()
  -- TODO:
  -- - map('n', '<a-t>', '"zdh"zp') -- transpose
  -- - map reselect "gv"
  local reg = require('modules.binder').reg
  reg {
    fn = {
      [dd.search] = cmd 'Telescope current_buffer_fuzzy_find',
    },
  }
  reg {
    A = 'A',
    a = 'a',
    b = plug { '%', 'matchup cycle forward', modes = 'nxo' },
    C = { '<nop>', modes = 'nx' },
    c = { '""c', modes = 'nx' },
    D = { '<nop>', modes = 'nx' },
    d = { '""d', modes = 'nx' },
    E = {
      modes = {
        n = 'W',
        xo = 'E',
      },
    },
    -- e = { 'w', 'next word ', modes = 'nxo' },
    e = {
      modes = {
        n = 'w',
        xo = 'e',
        -- n = plug { 'CamelCaseMotion_w', 'next subword ' },
        -- xo = plug { 'CamelCaseMotion_e', 'next subword ' },
      },
    },
    -- f = { require('flies').meta_move, mode = true, modes = 'nx' },
    f = {
      modes = {
        n = function()
          require('flies').meta_move 'n'
        end,
        o = function()
          require('flies').meta_move 'o'
        end,
        x = function()
          require('flies').meta_move 'x'
        end,
      },
    },
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
    t = {
      function()
        require('flies').append_insert()
      end,
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
    },
    ['<c-f>'] = {
      function()
        require('luasnip.extras.otf').on_the_fly 'f'
      end,
      modes = 'vi',
    },
    ['<c-g>'] = cmd { 'Telescope luasnip', modes = 'ni' },
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
    ['<c-s>'] = {
      modes = {
        n = function()
          vim.lsp.buf.formatting_sync()
        end,
        i = function()
          vim.cmd 'stopinsert'
          vim.lsp.buf.formatting_sync()
        end,
      },
    },
    ['<c-v>'] = { 'P', modes = 'nv' },
    ['<a-a>'] = cmd { 'e#', 'previous buffer' },
    ['<a-b>'] = cmd { 'wincmd p', 'window back' },
    ['<a-w>'] = cmd { 'q', 'close window' },
    [dd.right] = { 'l', 'right', modes = 'nxo' },
    [dd.left] = { 'h', 'left', modes = 'nxo' },
    [dd.up] = { 'k', 'up', modes = 'nxo' },
    [dd.down] = { 'j', 'down', modes = 'nxo' },
    -- also: require("luasnip.extras.select_choice")
    -- TODO: require luasnip
    [dd.prev_search] = {
      modes = {
        n = function()
          require('bindutils').luasnip_choice_or_dial_previous 'n'
        end,
        x = function()
          require('bindutils').luasnip_choice_or_dial_previous 'x'
        end,
      },
    },
    [dd.next_search] = {
      modes = {
        n = function()
          require('bindutils').luasnip_choice_or_dial_next 'n'
        end,
        x = function()
          require('bindutils').luasnip_choice_or_dial_next 'x'
        end,
      },
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
        pb = function()
          require('dap').clear_breakpoints()
        end,
        b = {
          "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
          'toggle breakpoints',
        },
        c = repeatable_cmd "lua require'dap'.continue()",
        i = repeatable_cmd "lua require'dap'.step_into()",
        po = repeatable_cmd "lua require'dap'.step_out()",
        o = repeatable_cmd "lua require'dap'.step_over()",
        px = { "<cmd>lua require'dap'.disconnect()<cr>", 'stop' },
        x = { "<cmd>lua require'dap'.terminate()<cr>", 'stop' },
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
        ['<cr>'] = repeatable_cmd "lua require'dap'.run_to_cursor()",
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
        d = { vim.lsp.buf.definition, 'definition' },
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
      t = plug 'PlenaryTestFile',
      v = 'gv',
      pw = plug '(Marks-prev-bookmark1)',
      w = plug '(Marks-next-bookmark1)',
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
        y = { 'zg', 'add to spellfile' },
        x = cmd { 'setlocal nospell', 'none' },
      },
    },
    [a.jump] = {
      a = cmd {
        'Telescope current_buffer_fuzzy_find',
      },
      b = { '%', modes = 'nxo' },
      [p 'd'] = {
        function()
          vim.diagnostic.goto_prev { float = not vim.g.u_virtual_lines }
        end,
        'go previous diagnostic',
      },
      d = {
        function()
          vim.diagnostic.goto_next { float = not vim.g.u_lsp_lines }
        end,
        'go next diagnostic',
      },
      [p 'f'] = plug {
        '(buffet-operator-extract)',
        'buffet extract',
        modes = 'nx',
      },
      f = plug {
        '(buffet-operator-replace)',
        'buffet replace',
        modes = 'nx',
      },
      g = { '``', 'before last jump' },
      o = { '`.', 'last change' },
      l = '`', -- jump
      [p 'm'] = { '`[', 'start of last mod', modes = 'nxo' },
      m = { '`]', 'begin of last mod', modes = 'nxo' },
      pr = { require('bindutils').previous_reference },
      r = { require('bindutils').next_reference },
      -- s = cmd 'Telescope treesitter',
      -- s = cmd 'Telescope lsp_document_symbols',
      s = require('bindutils').telescope_symbols_md_lsp,
      pt = plug '(ultest-prev-fail)',
      t = plug '(ultest-next-fail)',
      pu = require('bindutils').scroll_up,
      u = require('bindutils').scroll_down,
      pv = { '`<', modes = 'nxo' },
      v = { '`>', modes = 'nxo' },
      ['p;'] = { 'g,', 'newer change' },
      [';'] = { 'g;', 'older changer' },
      [dd.up] = { 'gk', 'visual up', modes = 'nxo' },
      [dd.down] = { 'gj', 'visual down', modes = 'nxo' },
      -- FIXME: built-in previous/next misspelled do not work with spellsitter
      -- replace with search function based on highlight group
      [p(dd.spell)] = { '[s', 'prevous misspelled' },
      [dd.spell] = { ']s', 'next misspelled' },
      [p(dd.search)] = {
        function()
          require('flies.objects.search').search('?', true, false)
        end,
        modes = 'nxo',
      },
      [dd.search] = {
        function()
          require('flies.objects.search').search('/', true, true)
        end,
        modes = 'nxo',
      },
      ['p' .. a.mark] = {
        a = require('bindutils').bookmark_next(0),
        s = require('bindutils').bookmark_next(1),
        d = require('bindutils').bookmark_next(2),
        f = require('bindutils').bookmark_next(3),
        b = plug '(Marks-prev-bookmark)',
        l = plug { '(Marks-prev)', name = 'Goes to previous mark in buffer.' },
      },
    },
    [a.edit] = {
      name = '+edit',
      a = {
        modes = {
          -- n = cmd { 'CodeActionMenu', 'code action',
          n = vim.lsp.buf.code_action,
          v = { ":'<,'>lua vim.lsp.buf.range_code_action()<cr>" },
        },
      },
      b = { 'gi', 'last insert point' },
      d = plug '(u-flies-operator-swap)', -- FIXME:
      he = cmd 'ISwapWith',
      [p 'e'] = {
        function()
          require('nvim-treesitter.textobjects.swap').swap_previous '@swappable'
        end,
        'swap',
      },
      e = {
        function()
          require('nvim-treesitter.textobjects.swap').swap_next '@swappable'
        end,
        'swap',
      },
      [p 'g'] = cmd 'SplitjoinJoin',
      g = cmd 'SplitjoinSplit',
      m = { 'J', 'join', modes = 'nx' },
      [p 'o'] = 'O',
      o = 'o',
      n = {
        name = '+annotate',
        n = {
          function()
            require('neogen').generate {}
          end,
          'all',
          -- 'annotate (neogen)',
        },
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
            require('neogen').generate { type = 'type' }
          end,
          'type',
        },
      },
      r = 'R',
      s = { vim.lsp.buf.rename, 'rename' },
      -- s = { vim.lsp.buf.rename, 'rename', modes = 'nx' },
      [p(p 'u')] = {
        rep [["zc<C-R>=casechange#next(@z)<CR><Esc>v`[']],
        'change case',
        modes = 'nx',
      }, -- FIXME: not repeatable
      [p 'u'] = { 'gU', 'uppercase', modes = 'nx' },
      u = { 'gu', 'lowercase', modes = 'nx' },
      [p 'v'] = { 'P', modes = 'nx' },
      v = { 'p', modes = 'nx' },
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
      [p 'x'] = plug {
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
      [p 'y'] = plug { '(buffet-operator-delete)', modes = 'nx' },
      y = plug { '(buffet-operator-add)', modes = 'nx' },
      [p '<tab>'] = { '<<', 'dedent', modes = 'nx' },
      ['<tab>'] = { '>>', 'indent', modes = 'nx' },
      -- https://vi.stackexchange.com/questions/3875/how-to-insert-a-newline-without-leaving-normal-mode
      [p '<cr>'] = plug 'unimpairedBlankUp',
      ['<cr>'] = plug 'unimpairedBlankDown',
      [dd.spell] = {
        function()
          require('telescope.builtin').spell_suggest(
            require('telescope.themes').get_cursor {}
          )
        end,
        'spell suggest',
        modes = 'nx',
      },
      [p(dd.comment)] = plug { '(u-comment-opleader-block)', modes = 'nx' },
      [dd.comment] = {
        modes = {
          n = {
            o = function()
              require('Comment.api').locked.insert_linewise_below()
            end,
            po = function()
              require('Comment.api').locked.insert_linewise_above()
            end,
            pp = function()
              require('Comment.api').locked.insert_linewise_eol()
            end,
          },
          nx = {
            [''] = plug '(u-comment-opleader-line)',
          },
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
      b = plug { '(Marks-delete-bookmark)' },
      a = plug { '(Marks-set-bookmark0)' },
      s = plug { '(Marks-set-bookmark1)' },
      d = plug { '(Marks-set-bookmark2)' },
      f = plug { '(Marks-set-bookmark3)' },
      pl = plug {
        '(Marks-delete)',
        name = 'Delete a letter mark (will wait for input).',
      },
      l = plug {
        '(Marks-set)',
        name = 'Sets a letter mark (will wait for input).',
      },
      ['pp' .. a.mark] = plug {
        '(Marks-deletebuf)',
        name = 'Deletes all marks in current buffer.',
      },
      ['p' .. a.mark] = plug {
        '(Marks-deleteline)',
        name = 'Deletes all marks on current line.',
      },
      [a.mark] = plug {
        '(Marks-toggle)',
        name = 'toggle next available mark at cursor',
      },
    },
    [a.move] = {
      name = '+move',
      a = { require('bindutils').edit_alt, 'edit alternate' },
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
      },
      g = cmd 'Telescope buffers',
      pi = { vim.lsp.buf.declaration, 'go declaration' },
      i = cmd 'Telescope lsp_implementations',
      j = cmd 'Telescope lsp_type_definitions',
      pf = function()
        require('telescope.builtin').file_browser {
          cwd = vim.fn.expand '%:p:h',
          depth = 10,
        }
      end,
      f = function()
        require('telescope.builtin').file_browser {
          cwd = vim.fn.expand '%:p:h',
          -- hidden = false,
        }
      end,
      o = cmd 'Telescope oldfiles only_cwd=true',
      W = cmd 'TodoTelescope',
      q = 'Telescope quickfixlist',
      r = cmd 'Telescope lsp_references',
      s = cmd 'Telescope lsp_definitions', -- also, trouble
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
      [a.mark] = {
        b = function()
          require('marks').bookmark_state:all_to_list 'quickfixlist'
          require('telescope.builtin').quickfix()
        end,
        pb = plug '(Marks-next-bookmark)',
        l = function()
          require('marks').mark_state:all_to_list 'quickfixlist'
          require('telescope.builtin').quickfix()
        end,
        pl = plug { '(Marks-next)', name = 'Goes to next mark in buffer.' },
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
      -- require'dap'.list_breakpoints() -- Lists all breakpoints and log points in quickfix window.
      pa = {
        require('modules.toggler').cb(
          'Trouble document_diagnostics',
          'TroubleClose'
        ),
        'lsp document diagnostics',
      },
      a = {
        require('modules.toggler').cb(
          'Trouble workspace_diagnostics',
          'TroubleClose'
        ),
        'lsp worspace diagnostics',
      },
      -- pb = { -- FIXME:
      --   function()
      --     require('bufjump').backward(require('bufjump').not_under_cwd)
      --   end,
      --   'previous workspace',
      -- },
      -- b = { -- FIXME:
      --   function()
      --     require('bufjump').forward(require('bufjump').not_under_cwd)
      --   end,
      --   'next workspace',
      -- },
      b = require('modules.toggler').cb(function()
        require('marks').bookmark_state:all_to_list 'quickfixlist'
        vim.cmd 'Trouble quickfix'
      end, 'TroubleClose'),
      d = {
        require('modules.toggler').cb(function()
          require('dapui').open()
        end, function()
          require('dapui').close()
        end),
        'toggle dapui',
      },
      pe = { require('bindutils').reset_editor, 'reset editor' },
      e = { require('bindutils').edit_current, 'current in new editor' },
      f = {
        require('modules.toggler').cb('NvimTreeOpen', 'NvimTreeClose'),
        'nvim tree',
      },
      g = require('modules.toggler').cb('Neogit', ':q'),
      h = require('modules.toggler').cb('DiffviewFileHistory', 'DiffviewClose'),
      j = {
        name = '+peek',
        l = plug {
          '(Marks-preview)',
          name = 'Previews mark (will wait for user input). press <cr> to just preview the next mark.',
        },
        d = {
          function()
            require('goto-preview').goto_preview_definition()
          end,
          'definition',
        },
        r = {
          function()
            require('goto-preview').goto_preview_references()
          end,
          'referenes',
        },
        t = cmd 'UltestOutput',
        [dd.git] = function()
          require('gitsigns').blame_line { full = true }
        end,
      },
      pk = { vim.lsp.buf.signature_help, 'signature help' },
      k = { vim.lsp.buf.hover, 'hover' },
      l = require('modules.toggler').cb(function()
        require('marks').mark_state:all_to_list 'quickfixlist'
        vim.cmd 'Trouble quickfix'
      end, 'TroubleClose'),
      m = cmd { 'Telescope installed_plugins', 'plugins' },
      n = cmd { 'Telescope modules', 'node modules' },
      o = { require('bindutils').open_current, 'open current external' },
      pp = { require('modules.setup-session').develop, 'session develop' },
      r = { '<cmd>update<cr><cmd>so %<cr>', 'reload' },
      ps = {
        require('modules.toggler').cb(
          'TroubleToggle references',
          'TroubleClose'
        ),
        'lsp references',
      },
      s = {
        require('modules.toggler').cb(
          'SymbolsOutlineOpen',
          'SymbolsOutlineClose'
        ),
        'outliner',
      },
      t = { require('bindutils').term, 'new terminal' },
      pv = cmd { 'Telescope project_directory', 'projects' },
      v = cmd { 'Telescope my_projects', 'sessions' },
      cs = {
        function()
          require('split').open_lsp()
        end,
      },
      pc = {
        modes = {
          n = function()
            require('split').close()
          end,
        },
      },
      cr = {
        modes = {
          n = function()
            require('split').pop({ target = 'here' }, 'n')
          end,
          x = ":<c-u>lua require('split').open({target='here'}, 'x')<cr>",
        },
      },
      co = {
        modes = {
          n = function()
            require('split').open({}, 'n')
          end,
          x = ":<c-u>lua require('split').open({}, 'x')<cr>",
        },
      },
      w = require('modules.toggler').cb('TodoTrouble', 'TroubleClose'),
      x = { require('bindutils').xplr_launch, 'xplr' },
      y = {
        require('modules.toggler').cb('UndotreeToggle', 'UndotreeToggle'),
        'undo tree',
      },
      z = require('modules.toggler').cb('ZenMode', 'ZenMode'),
      ['.'] = { require('bindutils').dotfiles, 'dotfiles' },
      ['"'] = {
        function()
          require('nononotes').prompt('edit', false, 'all')
        end,
        'pick note',
      },
      [' '] = require('modules.toggler').cb(
        require('modules.blank_pane').open,
        require('modules.blank_pane').close
      ),
      -- [' '] = cmd { 'Telescope commands', 'commands' },
      ['p' .. dd.git] = require('modules.toggler').cb(
        'DiffviewOpen',
        'DiffviewClose'
      ),
      [dd.git] = {
        require('modules.toggler').cb('Gitsigns setqflist', 'TroubleClose'),
        'hunks',
      },
      [s(a.editor)] = { require('modules.toggler').back, 'toggle' },
      [a.editor] = { require('modules.toggler').toggle, 'toggle' },
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
  -- vim.fn.call('textobj#sentence#init', {})
  reg {
    -- both are identical
    ad = { '<Plug>(textobj-datetime-auto)', noremap = false, modes = 'ox' },
    id = { '<Plug>(textobj-datetime-auto)', noremap = false, modes = 'ox' },
  }
end

local function map_readonly()
  if vim.bo.buftype == 'prompt' then
    local map = require('utils').buf_map
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
  local map = require('utils').map
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
  require('utils').augroup('ReadonlyMappings', {
    {
      events = { 'BufNew' },
      targets = { '*' },
      command = map_readonly,
    },
  })
  if false then
    require('utils').augroup('MarkdownBindings', {
      {
        events = { 'FileType' },
        targets = { 'markdown' },
        command = map_markdown,
      },
    })
  end
  -- ordering of the matters for: i) overriding, ii) captures
  map_command_lang()
  map_basic()
  require('bindings.textobjects').setup()
  -- require('utils').dump(require('modules.binder').counters)
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
    hover = 'h',
    open_folds = {},
    next = dd.down,
    previous = dd.up,
    toggle_mode = 'm', -- toggle between "workspace" and "document" diagnostics mode
    toggle_preview = 'l', -- toggle auto_preview
    preview = 'p', -- preview the diagnostic location
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
