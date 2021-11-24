local M = {}
local invert = require('modules.utils').invert

-- mapclear

M.plugins = {}

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
  M = 'move',
  m = 'mark',
  Q = 'macro',
  q = 'editor',
  Y = 'browser',
  z = 'various',
  [' '] = 'leader',
}
local dd = invert {
  a = 'diagnostic',
  b = 'join',
  c = 'comment',
  g = 'ninja',
  j = 'up',
  k = 'down',
  L = 'loclist',
  l = 'left',
  s = 'symbol',
  z = 'spell',
  ['é'] = 'search',
  [';'] = 'right',
  ['<c-j>'] = 'next_search',
  ['<c-x>'] = 'prev_search',
}

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

local function map_command_insert()
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
        ['<c-n>'] = '<down>',
        ['<c-p>'] = '<up>',
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
        ['<Tab>'] = { require('bindutils').tab_complete },
        ['<s-Tab>'] = { require('bindutils').s_tab_complete },
        ['<c-space>'] = { require('bindutils').toggle_cmp },
      },
      c = {
        ['<a-v>'] = { '<c-f>', 'edit command line' },
        ['<c-v>'] = { '<c-r>+', 'paste to command line' },
      },
    },
    ['<c-a>'] = { modes = { i = '<c-o>^', nvo = '^' } },
    -- ['<c-e>'] = { modes = { i = '<c-o>$', nvo = '$' } },
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
    E = { 'E', 'previous bigword', modes = 'nxo' },
    -- e = { 'e', 'next word ', modes = 'nxo' },
    e = plug { 'CamelCaseMotion_e', 'next subword ', modes = 'nxo' },
    F = {
      'reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_F" : "F"',
      noremap = false,
      expr = true,
      modes = 'nxo',
    },
    f = {
      'reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_f" : "f"',
      noremap = false,
      expr = true,
      modes = 'nxo',
    },
    I = 'I',
    i = 'i',
    N = {
      modes = {
        nx = {
          "<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>",
          'search previous',
        },
        o = 'gN',
      },
    },
    n = {
      modes = {
        nx = {
          "<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>",
          'search previous',
        },
        o = 'gn',
      },
    },
    O = { 'O', modes = 'nx' },
    o = { 'o', modes = 'nx' },
    p = { 'p', modes = 'nx' },
    R = { 'R', modes = 'nx' },
    r = { 'r', modes = 'nx' },
    S = plug { 'Lightspeed_S', 'S', modes = 'nxo' },
    s = plug { 'Lightspeed_s', 's', modes = 'nxo' },
    T = {
      'reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_T" : "T"',
      noremap = false,
      expr = true,
      modes = 'nxo',
    },
    t = {
      'reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_t" : "t"',
      noremap = false,
      expr = true,
      modes = 'nxo',
    },
    U = 'U',
    u = 'u',
    V = { '<c-v>', modes = 'nxo' },
    v = { modes = {
      x = 'V',
      n = 'v',
    } },
    W = { 'B', 'previous word', modes = 'nxo' },
    -- w = { 'b', 'next word', modes = 'nxo' },
    w = plug { 'CamelCaseMotion_b', 'previous subword ', modes = 'nxo' },
    X = { '"+d$', modes = 'nx' },
    x = { '"+d', modes = 'nx' },
    cc = '""S',
    dd = '""dd',
    xx = '"+dd',
    ['É'] = { '?', modes = 'nxo' },
    ['é'] = { '/', modes = 'nxo' },
    ['.'] = '.',
    ['!'] = { '!', modes = 'nx' },
    ['!!'] = { '!!', modes = 'nx' },
    ['='] = { '=', modes = 'nx' },
    ['=='] = { '==', modes = 'nx' },
    ['"'] = '"',
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
    [dd.right] = { 'l', 'right', modes = 'nxo' },
    [dd.left] = { 'h', 'left', modes = 'nxo' },
    [dd.up] = { 'k', 'up', modes = 'nxo' },
    [dd.down] = { 'j', 'down', modes = 'nxo' },
    ['<c-d>'] = function()
      require('neoscroll').scroll(0.9, true, 250)
    end,
    ['<c-f>'] = plug { 'Lightspeed_,_ft', modes = 'nxo' },
    ['<c-g>'] = plug { 'Lightspeed_;_ft', modes = 'nxo' },
    ['<c-i>'] = function()
      require('neoscroll').scroll(-0.9, true, 250)
    end,
    ['<c-n>'] = {
      function()
        require('bufjump').forward()
      end,
      'jump next buffer',
    },
    ['<c-p>'] = {
      function()
        require('bufjump').backward()
      end,
      'jump previous buffer',
    },
    ['<c-r>'] = '<c-r>',
    ['<c-s>'] = { vim.lsp.buf.formatting_sync, modes = 'ni' },
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
    [a.various] = {
      n = 'gn',
      N = 'gN',
      v = 'gv',
      t = function()
        require('neoscroll').zt(250)
      end,
      z = function()
        require('neoscroll').zz(250)
      end,
      b = function()
        require('neoscroll').zb(250)
      end,
    },
    [a.jump] = {
      A = { vim.lsp.diagnostic.goto_prev, 'go previous diagnostic' },
      a = { vim.lsp.diagnostic.goto_next, 'go next diagnostic' },
      C = {
        '<plug>(asterisk-gz*)<cmd>lua require"hlslens".start()<cr>',
        noremap = false,
        modes = 'nx',
      },
      c = {
        '<plug>(asterisk-z*)<cmd>lua require"hlslens".start()<cr>',
        noremap = false,
        modes = 'nx',
      },
      D = { '[c', 'previous change' }, -- FIXME:
      d = { ']c', 'next change' }, -- FIXME:
      E = { 'gg', 'first line', modes = 'nxo' },
      e = { 'G', 'last line', modes = 'nxo' },
      i = { '(matchup-z%)', 'matchup inward', modes = 'nxo' },
      L = cmd 'Telescope loclist',
      m = {
        capture = { 'marks', 'next' },
        name = 'Goes to next mark in buffer.',
      },
      M = {
        capture = { 'marks', 'prev' },
        name = 'Goes to previous mark in buffer.',
      },
      o = { '`.', 'last change' },
      s = cmd 'Telescope treesitter',
      Y = { '(matchup-[%)', 'matchup backward', modes = 'nxo' },
      y = { '(matchup-]%)', 'matchup forward', modes = 'nxo' },
      -- Z = { '<cmd>lua require"bindutils".spell_next(-1)<cr>', 'prevous misspelled' },
      -- z = { '<cmd>lua require"bindutils".spell_next()<cr>', 'next misspelled' },
      [':'] = { 'g,', 'newer change' },
      [';'] = { 'g;', 'older changer' },
      [s(dd.spell)] = { '[s', 'prevous misspelled' },
      [dd.spell] = { ']s', 'next misspelled' },
      [dd.search] = cmd {
        'Telescope current_buffer_fuzzy_find',
        modes = 'nxo',
      },
      [dd.up] = { 'gk', 'visual up', modes = 'nxo' },
      [dd.down] = { 'gj', 'visual down', modes = 'nxo' },
    },
    [a.edit] = {
      name = '+edit',
      a = cmd { 'CodeActionMenu', 'code action', modes = 'nx' },
      f = cmd { 'Telescope refactoring', 'refactoring', modes = 'nx' },
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
      r = plug {
        '(buffet-operator-replace)',
        'buffet replace',
        modes = 'nx',
      },
      R = plug {
        '(buffet-operator-extract)',
        'buffet extract',
        modes = 'nx',
      },
      s = {
        function()
          require('renamer').rename { empty = false }
        end,
        'rename',
        modes = 'nx',
      },
      -- s = { vim.lsp.buf.rename, 'rename', modes = 'nx' },
      t = { '<<', 'dedent', modes = 'nx' },
      U = { 'gU', 'uppercase', modes = 'nx' },
      u = { 'gu', 'lowercase', modes = 'nx' },
      v = {
        rep [["zc<C-R>=casechange#next(@z)<CR><Esc>v`[']],
        'change case',
        modes = 'nx',
      }, -- FIXME: not repeatable
      -- v = { 'g~', 'toggle case', modes = 'nx' },
      w = {
        function()
          require('telescope.builtin').symbols {
            sources = { 'math', 'emoji' },
          }
        end,
        'symbols',
        modes = 'nx',
      },
      X = plug {
        '(ExchangeClear)',
        modes = 'nx',
      },
      x = {
        name = 'exchange',
        modes = {
          x = plug '(Exchange)',
          n = plug '(ExchangeLine)',
        },
      },
      Y = plug { '(buffet-operator-delete)', modes = 'nx' },
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
      [s(dd.comment)] = plug { '(u-comment-opleader-block)', modes = 'nx' },
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
      [s(dd.join)] = { 'J', 'join', modes = 'nx' },
      [dd.join] = {
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
      [s(dd.ninja)] = {
        modes = {
          n = plug '(ninja-insert)',
          x = require('bindutils').pre,
        },
      },
      [dd.ninja] = {
        modes = {
          n = plug '(ninja-append)',
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
        Y = {'<Plug>(buffet-operator-delete)il', noremap=false},
        y = {'<Plug>(buffet-operator-add)il', noremap=false},
        R = {'<Plug>(buffet-operator-extract)il', noremap=false},
        r = {'<Plug>(buffet-operator-replace)il', noremap=false},
        [dd.join] = plug '(u-revj-line)',
        [s(dd.comment)] = plug '(u-comment-toggler-block)',
        [dd.comment] = plug '(u-comment-toggler-line)',
      },
    },
    [a.mark] = {
      D = {
        capture = { 'marks', 'delete_buf' },
        name = 'Deletes all marks in current buffer.',
      },
      d = {
        capture = { 'marks', 'delete_line' },
        name = 'Deletes all marks on current line.',
      },
      i = { 'gi' },
      P = { '`[', modes = 'nxo' },
      p = { '`]', modes = 'nxo' },
      S = {
        capture = { 'marks', 'delete' },
        name = 'Delete a letter mark (will wait for input).',
      },
      s = {
        capture = { 'marks', 'set' },
        name = 'Sets a letter mark (will wait for input).',
      },
      t = {
        capture = { 'marks', 'toggle' },
        name = 'toggle next available mark at cursor',
      },
      V = { '`<', modes = 'nxo' },
      v = { '`>', modes = 'nxo' },
      [','] = { require('modules.alt-jump').reset, 'alt-jump reset' },
      [a.mark] = {
        capture = { 'marks', 'preview' },
        name = 'Previews mark (will wait for user input). press <cr> to just preview the next mark.',
      },
    },
    [a.move] = {
      name = '+move',
      b = cmd 'Telescope buffers',
      D = cmd 'Telescope lsp_type_definitions', -- also, trouble
      d = cmd 'Telescope lsp_definitions', -- also, trouble
      I = { vim.lsp.buf.declaration, 'go declaration' }, -- FIXME:
      i = cmd 'Telescope lsp_implementations', -- also, trouble
      -- m = function()
      --   require('telescope.builtin').find_files {
      --     cwd = vim.fn.expand '%:p:h',
      --   }
      -- end,
      m = function()
        require('telescope.builtin').file_browser {
          cwd = vim.fn.expand '%:p:h',
        }
      end,
      o = cmd 'Telescope oldfiles only_cwd=true',
      -- "Telescope lsp_references"
      p = cmd 'TodoTrouble',
      P = cmd 'TodoTelescope',
      r = cmd 'Trouble lsp_references',
      T = {
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
      A = {
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
      B = { -- FIXME:
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
      G = {
        function()
          require('modules.toggler').open('Gitsigns setqflist', 'TroubleClose')
        end,
        'hunks',
      },
      g = function()
        require('modules.toggler').open('Neogit', ':q')
      end,
      H = cmd { 'DiffviewClose', 'diffview close' },
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
      p = { require('modules.setup-session').develop, 'session develop' },
      r = { '<cmd>update<cr><cmd>luafile %<cr>', 'reload' },
      s = { require('bindutils').outliner, 'outliner' },
      S = {
        function()
          require('modules.toggler').open(
            'TroubleToggle lsp_references',
            'TroubleClose'
          )
        end,
        'lsp references',
      },
      t = { require('bindutils').term, 'new terminal' },
      u = {
        function()
          require('modules.toggler').open('UndotreeToggle', 'UndotreeToggle')
        end,
        'undo tree',
      },
      w = cmd { 'Telescope my_projects', 'sessions' },
      W = cmd { 'Telescope project_directory', 'projects' },
      x = {
        function()
          require('bindutils').term_launch { 'xplr', vim.fn.expand '%' }
        end,
        'xplr',
      },
      z = function()
        require('modules.toggler').open('ZenMode', 'zen mode')
      end,
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
    [a.browser] = {
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
      mdn = map_search('https://developer.mozilla.org/en-US/search?q=', 'mdn'),
      nell = map_search(
        'https://nelligan.ville.montreal.qc.ca/search*frc/a?searchtype=Y&searcharg=',
        'nelligan'
      ),
      npm = map_search('https://www.npmjs.com/search?q=', 'npm'),
      o = {
        '<cmd>call jobstart(["xdg-open", expand("<cfile>")]<cr>, {"detach": v:true})<cr>',
        'open current file',
      },
      P = { require('modules.setup-session').launch, 'session lauch' },
      pac = map_search('https://archlinux.org/packages/?q=', 'arch packages'),
      sea = map_search('https://www.seriouseats.com/search?q=', 'seriouseats'),
      sep = map_search(
        'https://plato.stanford.edu/search/searcher.py?query=',
        'sep'
      ),
      sp = map_search('https://www.persee.fr/search?ta=article&q=', 'persée'),
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
    [a.macro] = {
      r = plug '(Mac_RecordNew)',
      n = plug '(Mac_RotateBack)',
      N = plug '(Mac_RotateForward)',
      a = plug '(Mac_Append)',
      A = plug '(Mac_Prepend)',
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
    [a.leader] = {
      s = {
        name = '+LSP',
        a = {
          vim.lsp.diagnostic.show_line_diagnostics(),
          'show line diagnostics',
        },
        C = { vim.lsp.buf.incoming_call, 'incoming calls' },
        c = { vim.lsp.buf.outgoing_calls, 'outgoing calls' },
        d = cmd { 'lua PeekDefinition()', 'hover definition' }, -- FIXME:
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
      t = {
        require('modules.palette').shrink,
        'experiments!',
        modes = 'x',
      },
      [dd.spell] = {
        name = '+Spell',
        b = cmd { 'setlocal spell spelllang=en_us,fr,cjk', 'en fr' },
        e = cmd { 'setlocal spell spelllang=en_us,cjk', 'en' },
        f = cmd { 'setlocal spell spelllang=fr,cjk', 'fr' },
        g = cmd { 'zg', 'add to spellfile' },
        x = cmd { 'setlocal nospell spelllang=', 'none' },
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
        -- u = { "<cmd>lua require'dapui'.eval()<cr>", 'toggle dapui' },
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
      [a.leader] = { ':', modes = 'nx' },
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

local function map_ts_textobj(key, name)
  -- TODO: accept count argument
  -- make indepenent of mappings
  map_textobj(
    key,
    plug(string.format('(%s-inner)', name)),
    plug(string.format('(%s-outer)', name))
  )
  require('modules.binder').reg {
    [' gi' .. key] = plug(string.format('(gns-%s-inner)', name)),
    [' gi' .. s(key)] = plug(string.format('(gpe-%s-inner)', name)),
    [' go' .. key] = plug(string.format('(gns-%s-outer)', name)),
    [' go' .. s(key)] = plug(string.format('(gpe-%s-outer)', name)),
  }
  map_textobj('N' .. key, {
    string.format('<esc><Plug>(gpe-%s-inner)v<Plug>(%s-inner)', name, name),
    noremap = false,
  }, {
    string.format('<esc><Plug>(gpe-%s-outer)v<Plug>(%s-outer)', name, name),
    noremap = false,
  })
  map_textobj('n' .. key, {
    string.format('<esc><Plug>(gns-%s-inner)v<Plug>(%s-inner)', name, name),
    noremap = false,
  }, {
    string.format('<esc><Plug>(gns-%s-outer)v<Plug>(%s-outer)', name, name),
    noremap = false,
  })
end

-- FIXME: not working in visual mode: comment, ninja
-- a: argument (targets)
-- A: parameter (ts)
-- b: brackets (targets)
-- c: comment
-- d: datetime
-- e: entire buffer
-- f: funtion (ts)
-- h: gitsigns
-- i: indent
-- j: block (ts)
-- k: call (ts)
-- l: line
-- m: parameter (ts)
-- p: paragraph (builtin)
-- q: quotes (targets)
-- s: sentence
-- t: tag (targets)
-- v: variable segment
-- y: conditional (ts)
-- é: detect (sandwich)
-- z: loop (ts)
-- wW: word (vim)
-- IA (targets)

-- ts: Ajktyz

-- nN: next/last (targets)
-- gG: ninja

-- , hint

local function map_textobjects()
  map_textobj('p', 'ip', 'ap')
  map_textobj('w', 'iw', 'aw')
  map_textobj('W', 'iW', 'aw')
  map_ts_textobj('a', 'parameter')
  map_ts_textobj('Q', 'string')
  map_ts_textobj('f', 'function')
  map_ts_textobj('k', 'call')
  map_ts_textobj('j', 'block')
  map_ts_textobj('y', 'conditional')
  map_ts_textobj('z', 'loop')
  vim.g.targets_nl = 'nN'
  require('modules.utils').augroup('targetsline', {
    {
      events = { 'user' },
      targets = { 'targets#mappings#user' },
      command = function()
        vim.fn.call('targets#mappings#extend', {
          {
            ['-'] = { separator = { { d = '-' } } },
            l = { line = { { c = 1 } } },
            A = { argument = { { o = '[([]', c = '[])]', s = ',' } } },
          },
        })
      end,
    },
  })
  map_textobj(
    dd.comment,
    plug '(u-comment-textobj)',
    plug '(u-comment-textobj)'
  )
  -- todo: should be ii / ai for certain filetypes (markdown, python)
  map_textobj('i', plug '(indent-object-ii)', plug '(indent-object-ai)')
  -- FIXME:
  map_textobj(
    s(dd.ninja),
    plug '(ninja-left-foot-inner)',
    plug '(ninja-left-foot-a)',
    'ninja left foot'
  )
  map_textobj(
    dd.ninja,
    plug '(ninja-right-foot-inner)',
    plug '(ninja-right-foot-a)',
    'ninja right foot'
  )
  local map = require('modules.utils').map
  map('o', 'z', '<Plug>Lightspeed_x', { noremap = false })
  map('o', 'Z', '<Plug>Lightspeed_x', { noremap = false })
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
      T = plug {
        'Markdown_MoveToPreviousHeader',
        'previous header',
        modes = 'nxo',
      },
      h = plug { 'Markdown_MoveToCurHeader', 'current header', modes = 'nxo' },
      H = plug {
        'Markdown_MoveToParentHeader',
        'parent header',
        modes = 'nxo',
      },
      [dd.up] = { 'k', 'physical line up', modes = 'nxo' },
      [dd.down] = { 'j', 'physical line down', modes = 'nxo' },
    },
  }
  if require('pager').full then
    vim.fn.call('textobj#sentence#init', {})
    reg {
      -- both are identical
      ad = { '<Plug>(textobj-datetime-auto)', noremap = false, modes = 'ox' },
      id = { '<Plug>(textobj-datetime-auto)', noremap = false, modes = 'ox' },
    }
  end
end

local function map_readonly()
  if not vim.bo.readonly then
    return
  end
  local reg = require('modules.binder').reg_local
  reg {
    x = { '<cmd>q<cr>', nowait = true },
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
  map('nxo', a.browser, '<nop>')
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
      events = { 'BufReadPost' },
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
  map_command_insert()
  map_basic()
  map_textobjects()
  -- require('modules.utils').dump(require('modules.binder').counters)
end

local vim = vim

M.plugins = {
  renamer = {
    ['<c-a>'] = 'set_cursor_to_end',
    ['<c-i>'] = 'set_cursor_to_start',
    ['<c-e>'] = 'set_cursor_to_word_end',
    ['<c-b>'] = 'set_cursor_to_word_start',
    ['<c-c>'] = 'clear_line',
    ['<c-u>'] = 'undo',
    ['<c-r>'] = 'redo',
  },
  lightspeed = invert {
    [';'] = 'instant_repeat_fwd_key',
    l = 'instant_repeat_bwd_key',
    c = 'cycle_group_fwd_key',
    C = 'cycle_group_bwd_key',
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
