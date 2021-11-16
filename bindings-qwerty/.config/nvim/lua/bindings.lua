local M = {}
local invert = require('utils').invert

-- mapclear

M.plugins = {}

local function s(char)
  return '<s-' .. char .. '>'
end

local function alt(key)
  return string.format('<a-%s>', key)
end

local a = invert {
  m = 'edit',
  g = 'jump',
  h = 'move',
  M = 'mark',
  Q = 'macro',
  q = 'editor',
  H = 'help',
  Y = 'browser',
  [' '] = 'leader',
}
local dd = invert {
  [';'] = 'right',
  l = 'left',
  k = 'down',
  j = 'up',
  a = 'diagnostic',
  s = 'symbol',
  z = 'spell',
  ['é'] = 'search',
  L = 'loclist',
  b = 'join',
  n = 'ninja',
  c = 'comment',
  ['<c-j>'] = 'next_search',
  ['<c-x>'] = 'prev_search',
}

-- local r = invert {
--   a = 'outer',
--   i = 'inner',
-- }
--

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
  local reg = require('binder').reg
  reg {
    modes = {
      -- TODO: l is not what I thought
      nvoil = {
        ['<c-c>'] = '<esc>',
        ['<c-n>'] = '<down>',
        ['<c-p>'] = '<up>',
        ['<c-q>'] = { '<cmd>qall!<cr>', 'quit' },
        ['<c-s>'] = { '<cmd>update!<cr>', 'save' },
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
          require('browser').search_cword(url)
        end,
        help,
      },
      i = {
        function()
          require('browser').search_visual(url)
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
  local reg = require('binder').reg
  reg {
    B = plug { '(matchup-g%)', 'matchup cycle backward', modes = 'nxo' },
    b = plug { '(matchup-%)', 'matchup cycle forward', modes = 'nxo' },
    C = { '""C', modes = 'nx' },
    c = { '""c', modes = 'nx' },
    D = { '""D', modes = 'nx' },
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
    J = {
      capture = {
        'neoscroll',
        value = {
          'scroll',
          { '-vim.wo.scroll', 'true', '250' },
        },
      },
    },
    K = {
      capture = {
        'neoscroll',
        value = {
          'scroll',
          { 'vim.wo.scroll', 'true', '250' },
        },
      },
    },
    N = {
      "<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>",
      'search previous',
    },
    n = {
      "<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>",
      'search next',
    },
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
    zt = { capture = { 'neoscroll', value = { 'zt', { '250' } } } },
    zz = { capture = { 'neoscroll', value = { 'zz', { '250' } } } },
    zb = { capture = { 'neoscroll', value = { 'zb', { '250' } } } },
    ['É'] = { '?', modes = 'nxo' },
    ['é'] = { '/', modes = 'nxo' },
    [','] = {
      function()
        require('tsht').nodes()
      end,
      'hint',
      noremap = false,
      modes = 'nxo',
    },
    [dd.right] = { 'l', 'right', modes = 'nxo' },
    [dd.left] = { 'h', 'left', modes = 'nxo' },
    [dd.up] = { 'k', 'up', modes = 'nxo' },
    [dd.down] = { 'j', 'down', modes = 'nxo' },
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
    ['<c-w>'] = {
      r = plug { '(Visual-Split-VSResize)', modes = 'x' },
      S = plug { '(Visual-Split-VSSplit)', modes = 'x' },
      [dd.up] = plug { '(Visual-Split-VSSplitAbove)', modes = 'x' },
      [dd.down] = plug { '(Visual-Split-VSSplitBelow)', modes = 'x' },
    },
    ['<a-a>'] = cmd { 'e#', 'previous buffer' },
    ['<a-b>'] = cmd { 'wincmd p', 'window back' },
    ['<c-v>'] = { 'gp', modes = 'nv' },
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
    [alt(dd.left)] = { require('wrap_win').left, 'window left' },
    [alt(dd.down)] = { require('wrap_win').down, 'window down' },
    [alt(dd.up)] = { require('wrap_win').up, 'window up' },
    [alt(dd.right)] = { require('wrap_win').right, 'window right' },
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
      Z = { '[s', 'prevous misspelled' },
      z = { ']s', 'next misspelled' },
      [':'] = { 'g,', 'newer change' },
      [';'] = { 'g;', 'older changer' },
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
        '(operator-sandwich-replace)',
        'sandwich replace',
        modes = 'nx',
      },
      s = { vim.lsp.buf.rename, 'rename', modes = 'nx' },
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
      Y = plug { '(operator-sandwich-delete)', modes = 'nx' },
      y = plug { '(operator-sandwich-add)', modes = 'nx' },
      z = {
        function()
          require('telescope.builtin').spell_suggest(
            require('telescope.themes').get_cursor {}
          )
        end,
        'spell suggest',
        modes = 'nx',
      },
      [dd.comment] = {
        modes = {
          n = plug 'kommentary_motion_default',
          x = plug 'kommentary_visual_default',
        },
      },
      [dd.comment] = {
        modes = {
          n = plug 'kommentary_motion_default',
          x = plug 'kommentary_visual_default',
        },
      },
      [s(dd.join)] = { 'J', 'join', modes = 'nx' },
      [dd.join] = {
        capture = { 'revJ', 'operator' },
        modes = {
          x = {
            function()
              require('revj').format_visual()
            end,
            'rev join',
          },
        },
      },
      [s(dd.ninja)] = plug '(ninja-insert)',
      [dd.ninja] = plug '(ninja-append)',
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
        [dd.join] = { capture = { 'revJ', 'line' } },
        [dd.comment] = plug 'kommentary_line_default',
      },
    },
    [a.mark] = {
      V = { '`<', modes = 'nxo' },
      v = { '`>', modes = 'nxo' },
      P = { '`[', modes = 'nxo' },
      p = { '`]', modes = 'nxo' },
      t = {
        capture = { 'marks', 'toggle' },
        name = 'toggle next available mark at cursor',
      },
      d = {
        capture = { 'marks', 'delete_line' },
        name = 'Deletes all marks on current line.',
      },
      D = {
        capture = { 'marks', 'delete_buf' },
        name = 'Deletes all marks in current buffer.',
      },
      s = {
        capture = { 'marks', 'set' },
        name = 'Sets a letter mark (will wait for input).',
      },
      S = {
        capture = { 'marks', 'delete' },
        name = 'Delete a letter mark (will wait for input).',
      },
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
      E = {
        function()
          require('alt-jump').reset()
        end,
        'alt-jump reset',
      },
      e = {
        function()
          require('alt-jump').toggle()
        end,
        'alt-jump',
      },
      I = { vim.lsp.buf.declaration, 'go declaration' }, -- FIXME:
      i = cmd 'Telescope lsp_implementations', -- also, trouble
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
      [a.move] = {
        function()
          require('bindutils').project_files()
        end,
        'project file',
      },
    },
    [a.help] = {
      d = {
        function()
          require('bindutils').docu_current()
        end,
        'filetype docu',
      },
      h = cmd {
        'e ~/Dotfiles/bindings-qwerty/.config/nvim/lua/bindings.lua',
        'bindings',
      }, -- FIXME: use `realpath` instead
      m = cmd { 'Telescope man_pages', 'man pages' },
      p = cmd { 'Telescope md_help', 'md help' },
      v = cmd { 'Telescope help_tags', 'help tags' },
    },
    [a.editor] = {
      a = cmd {
        'TroubleToggle lsp_workspace_diagnostics',
        'lsp diagnostics',
      },
      A = cmd {
        'TroubleToggle lsp_document_diagnostics',
        'lsp document diagnostics',
      },
      b = { -- FIXME:
        function()
          require('bufjump').forward(require('bufjump').not_under_cwd)
        end,
        'next workspace',
      },
      B = { -- FIXME:
        function()
          require('bufjump').backward(require('bufjump').not_under_cwd)
        end,
        'previous workspace',
      },
      d = cmd { 'DiffviewOpen', 'diffview open' },
      D = cmd { 'DiffviewClose', 'diffview close' },
      e = {
        function()
          require('bindutils').edit_current()
        end,
        'current in new editor',
      },
      f = cmd { 'NvimTreeOpen', 'file tree' }, -- FIXME: find a way to focus current file on opening
      F = cmd { 'NvimTreeClose', 'file tree' },
      g = cmd { 'Neogit', 'neogit' },
      G = cmd { 'Gitsigns setqflist', 'trouble hunk' },
      h = cmd { 'DiffviewFileHistory', 'diffview open' },
      H = cmd { 'DiffviewClose', 'diffview close' },
      i = cmd { "lua require'dapui'.toggle()", 'toggle dapui' },
      m = cmd { 'Telescope installed_plugins', 'plugins' },
      n = cmd { 'Telescope modules', 'node modules' },
      o = {
        function()
          require('bindutils').open_current()
        end,
        'open current external',
      },
      p = {
        function()
          require('setup-session').develop()
        end,
        'session develop',
      },
      q = cmd { 'TroubleToggle quickfix', 'quickfix' },
      Q = cmd { 'TroubleClose', 'trouble close' },
      r = { '<cmd>update<cr><cmd>luafile %<cr>', 'reload' },
      s = {
        function()
          require('bindutils').outliner()
        end,
        'outliner',
      },
      S = cmd { 'TroubleToggle lsp_references', 'lsp reference' },
      t = {
        function()
          require('bindutils').term()
        end,
        'new terminal',
      },
      u = cmd { 'UndotreeToggleTree', 'undo tree' },
      w = cmd { 'Telescope my_projects', 'sessions' },
      W = cmd { 'Telescope project_directory', 'projects' },
      x = {
        function()
          require('bindutils').term_launch { 'xplr', vim.fn.expand '%' }
        end,
        'xplr',
      },
      z = cmd { 'ZenMode', 'zen mode' },
      ['.'] = {
        function()
          require('bindutils').dotfiles()
        end,
        'dotfiles',
      },
      ['"'] = {
        function()
          require('nononotes').prompt('edit', false, 'all')
        end,
        'pick note',
      },
      [' '] = {
        function()
          require('telescope.builtin').commands()
        end,
        'commands',
      },
    },
    [a.browser] = {
      arch = map_search(
        'https://wiki.archlinux.org/index.php?search=',
        'archlinux wiki'
      ),
      aur = map_search('https://aur.archlinux.org/packages/?K=', 'aur packages'),
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
      man = { require('browser').man, 'man page' },
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
      P = { require('setup-session').launch, 'session lauch' },
      pac = map_search('https://archlinux.org/packages/?q=', 'arch packages'),
      sea = map_search('https://www.seriouseats.com/search?q=', 'seriouseats'),
      sep = map_search(
        'https://plato.stanford.edu/search/searcher.py?query=',
        'sep'
      ),
      sp = map_search('https://www.persee.fr/search?ta=article&q=', 'persée'),
      st = map_search('https://usito.usherbrooke.ca/d%C3%A9finitions/', 'usito'),
      u = {
        require('browser').open_file,
        'open current file',
      },
      we = map_search('https://en.wikipedia.org/wiki/', 'wikipidia en'),
      wf = map_search('https://fr.wikipedia.org/wiki/', 'wikipidia fr'),
      y = map_search('https://www.youtube.com/results?search_query=', 'youtube'),
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
      z = {
        name = '+Spell',
        b = cmd { 'setlocal spell spelllang=en_us,fr,cjk', 'en fr' },
        e = cmd { 'setlocal spell spelllang=en_us,cjk', 'en' },
        f = cmd { 'setlocal spell spelllang=fr,cjk', 'fr' },
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

local function map_to(key, inner, outer)
  local reg = require('binder').reg
  reg {
    modes = {
      ox = {
        ['i' .. key] = inner,
        ['a' .. key] = outer,
      },
    },
  }
end

local function map_textobjects()
  vim.g.targets_nl = 'nN'
  require('utils').augroup('TargetsLine', {
    {
      events = { 'User' },
      targets = { 'targets#mappings#user' },
      command = function()
        vim.fn.call('targets#mappings#extend', {
          {
            ['-'] = { separator = { { d = '-' } } },
            l = { line = { { c = 1 } } },
          },
        })
      end,
    },
  })
  map_to('f', {
    capture = {
      'treesitter',
      'textobjects',
      'select',
      'keymaps',
      value = '@function.inner',
    },
  }, {
    capture = {
      'treesitter',
      'textobjects',
      'select',
      'keymaps',
      value = '@function.outer',
    },
  })
  -- conflict with targets.vim
  -- map_to(s(dd.ninja), {
  --   '<Plug>(ninja-right-foot-inner)',
  --   'ninja right foot',
  --   noremap = false,
  -- }, {
  --   '<Plug>(ninja-right-foot-a)',
  --   'ninja right foot',
  --   noremap = false,
  -- })
  -- map_to(dd.ninja, {
  --   '<Plug>(ninja-right-foot-inner)',
  --   'ninja right foot',
  --   noremap = false,
  -- }, {
  --   '<Plug>(ninja-right-foot-a)',
  --   'ninja right foot',
  --   noremap = false,
  -- })
end

local function map_markdown()
  local reg = require('binder').reg_local
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
  local reg = require('binder').reg_local
  reg {
    x = { '<cmd>q<cr>', nowait = true },
    u = { '<c-u>', noremap = false, nowait = true },
    d = { '<c-d>', noremap = false, nowait = true },
  }
end

--[[
## Text objects (ai)
| key                                       | Description           | source                |
| ----------------------------------------- | --------------------- | --------------------- |
| a                                         | argument              | targets               |
| b                                         | brackets              | vim, targets          |
| B                                         | block                 | vim, targets          |
| d                                         | datetimem ft:markdown | datetimee             |
| e                                         | entire buffer         | entire                |
| f                                         | function              | ts                    |
| g                                         | parameter             | ts                    | inner only
| i                                         | indent                | indent                |
| I                                         | indent                | indent                |
| l                                         | line                  | -                     | ?? conflict with targers
| p                                         | paragraph             | vim                   |
| q                                         | quotes                | targets               |
| s                                         | sentence, ft:markdown | sentence, conflict    |
| t                                         | tag (html)            | vim                   |
| v                                         | variable segment      | -                     |
| w                                         | word                  | vim                   |
| W                                         | bigword               | vim                   |
| ,                                         | parameter             | conflict with targets |
| `{count}ih` nth surrounding open to close |
| n                                         | next                  | targets               |
| l                                         | last                  | targets               |

- sentence: as, is, gS, gs
- line: al, il

| Key binder | Description                                                 |
| ------------ | ----------------------------------------------------------- |
| `<count>ai`  | **A**n **I**ndentation level and line above.                |
| `<count>ii`  | **I**nner **I**ndentation level (**no line above**).        |
| `<count>aI`  | **A**n **I**ndentation level and lines above/below.         |
| `<count>iI`  | **I**nner **I**ndentation level (**no lines above/below**). |
--]]

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
  require('utils').augroup('ReadonlyMappings', {
    {
      events = { 'BufReadPost' },
      targets = { '*' },
      command = map_readonly,
    },
  })
  require('utils').augroup('MarkdownBindings', {
    {
      events = { 'FileType' },
      targets = { 'markdown' },
      command = map_markdown,
    },
  })
  map_command_insert()
  map_basic()
  map_textobjects()
  local captures = require('binder').captures
  -- require('utils').dump(captures)
  require('neoscroll.config').set_mappings(captures.neoscroll)
end

local vim = vim

M.plugins = {
  lightspeed = invert {
    n = 'instant_repeat_fwd_key',
    N = 'instant_repeat_bwd_key',
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
    local trouble = require 'trouble.providers.telescope'
    return {
      defaults = {
        mappings = {
          i = {
            ['<c-q>'] = actions.send_to_qflist,
            ['<c-l>'] = actions.send_to_loclist,
            ['<c-t>'] = trouble.open_with_trouble,
            ['<c-c>'] = function()
              vim.cmd 'stopinsert'
            end,
          },
          n = {
            ['<c-j>'] = actions.file_split,
            ['<c-l>'] = actions.file_vsplit,
            ['<c-t>'] = trouble.open_ith_trouble,
            ['<c-c>'] = actions.close,
          },
        },
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
