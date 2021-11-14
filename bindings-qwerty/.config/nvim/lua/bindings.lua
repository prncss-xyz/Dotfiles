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
  [s 'É'] = 'searchBack',
  L = 'loclist',
}

-- local r = invert {
--   a = 'outer',
--   i = 'inner',
-- }

local function map_text_objects()
  local register = require('which-key-fallback').register

  -- map('ox', 'ir', '<Plug>(textobj-sandwich-auto-i)', { noremap = false })
  -- map('ox', 'ar', '<Plug>(textobj-sandwich-auto-a)', { noremap = false })
  -- map('ox', 'iy', '<Plug>(textobj-sandwich-query-i)', { noremap = false })
  -- map('ox', 'ay', '<Plug>(textobj-sandwich-query-a)', { noremap = false })
  -- map('ox', 'ic', '<plug>(matchup-i%)', { noremap = false })
  -- map('ox', 'ac', '<plug>(matchup-a%)', { noremap = false })

  for mode in string.gmatch('ox', '.') do
    register({
      [','] = { '<cmd>lua require("tsht").nodes()<cr>', 'hint' },
      Ni = { '<Plug>(ninja-left-foot-inner', 'ninja left foot' },
      Na = { '<Plug>(ninja-left-foot-a', 'ninja left foot' },
      -- conflict with targets.vim
      -- ni = { '<Plug>(ninja-right-foot-inner)', 'ninja right foot' },
      -- na = { '<Plug>(ninja-right-foot-a)', 'ninja right foot' },
      -- al = { '<Plug>(textobj-line-a)', 'line' },
      -- il = { '<Plug>(textobj-line-i)', 'line' },
    }, {
      mode = mode,
      noremap = false,
    })
  end
end

local function map_command_insert()
  local map = require('utils').map
  -- TODO: dedent
  -- char
  map('l', '<c-d>', '<c-h>') -- kill
  map('l', '<c-b>', '<left>')
  map('l', '<c-f>', '<right>')
  map('l', '<c-w>', '<c-w>')
  map('l', '<c-g>', '<c-right>')
  map('l', '<c-h>', '<c-left>')

  -- insert
  map('l', '<c-u>', '<c-u>') -- kill
  map('i', '<c-k>', '<c-o>d$')
  map('i', '<c-o>', '<c-o>')
  map('i', '<c-v>', '<esc>pa')

  -- commandline
  map('c', '<a-v>', '<c-f>') -- edit command line
  map('c', '<c-v>', '<c-r>+') -- paste to command line
end

local function map_edit()
  local reg = require('which-key-fallback').reg
  local reg2 = require('which-key-fallback').reg2
  local rep = require('bindutils').repeatable
  reg2 {
    C = { '""C', modes = 'nx' },
    c = { '""c', modes = 'nx' },
    D = { '""D', modes = 'nx' },
    d = { '""d', modes = 'nx' },
    p = { 'p', modes = 'nx' },
    R = { 'R', modes = 'nx' },
    r = { 'r', modes = 'nx' },
    X = { '"+d$', modes = 'nx' },
    x = { '"+d', modes = 'nx' },
    cc = '""S',
    dd = '""dd',
    xx = '"+dd',
    ['É'] = { '?', modes = 'nxo' },
    ['é'] = { '/', modes = 'nxo' },
    ['<c-j>'] = {
      "luasnip#choice_active() ? '<plug>luasnip-next-choice' : '<plug>(dial-increment)'",
      noremap = false,
      expr = true,
      modes = 'nx',
    },
    ['c-v'] = { 'gp', modes = 'nx' },
    ['<c-x>'] = {
      "luasnip#choice_active() ? '<plug>luasnip-previous-choice' : '<plug>(dial-decrement)'",
      noremap = false,
      expr = true,
      modes = 'nx',
    },
    [a.edit] = {
      name = '+edit',
      a = { '<cmd>CodeActionMenu<cr>', 'code action', modes = 'nx' },
      B = { 'J', 'join', modes = 'nx' },
      b = {
        function()
          require('revj').format_visual()
        end,
        'rev join',
        modes = 'x',
      }, -- see also plugins.revJ
      c = {
        modes = {
          n = {
            '<plug>kommentary_motion_default',
            'comment',
            noremap = false,
          },
          x = {
            '<Plug>kommentary_visual_default<esc>',
            'comment',
            noremap = false,
          },
        },
      },
      f = { '<cmd>Telescope refactoring<cr>', 'refactoring', modes = 'nx' },
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
      N = { '<Plug>(ninja-insert)', 'ninja insert', noremap = false },
      n = { '<Plug>(ninja-append)', 'ninja append', noremap = false },
      r = {
        '<Plug>(operator-sandwich-replace)',
        'sandwich replace',
        noremap = false,
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
      X = {
        '<Plug>(ExchangeClear)',
        'exchange clear',
        noremap = false,
        modes = 'nx',
      },
      x = {
        name = 'exchange',
        modes = {
          x = { '<Plug>(Exchange)', noremap = false },
          n = { '<Plug>(ExchangeLine)', noremap = false },
        },
      },
      Y = {
        '<Plug>(operator-sandwich-delete)',
        'sandwich delete',
        noremap = false,
        modes = 'nx',
      },
      y = {
        '<Plug>(operator-sandwich-add)',
        'sandwich add',
        noremap = false,
        modes = 'nx',
      },
      z = {
        function()
          require('telescope.builtin').spell_suggest(
            require('telescope.themes').get_cursor {}
          )
        end,
        'spell suggest',
        modes = 'nx',
      },
      [dd.left] = { '<Plug>MoveCharLefg', 'move up', noremap = false },
      [dd.right] = { '<Plug>MoveCharRight', 'move up', noremap = false },
      [dd.up] = { '<Plug>MoveLineUp', 'move up', noremap = false },
      [dd.down] = { '<Plug>MoveLineDown', 'move up', noremap = false },
      [a.edit] = {
        name = 'line',
        c = {
          '<plug>kommentary_line_default',
          'comment',
          noremap = false,
        },
      },
      ['<c-j>'] = {
        '<Plug>(dial-increment-additional)',
        noremap = false,
      },
      ['<c-x>'] = {
        '<Plug>(dial-decrement-additional)',
        noremap = false,
      },
      [dd.left] = {
        '<Plug>MoveBlockLeft',
        'move up',
        noremap = false,
        modes = 'x',
      },
      [dd.right] = {
        '<Plug>MoveBlockRight',
        'move up',
        noremap = false,
        modes = 'x',
      },
      [dd.up] = {
        '<Plug>MoveBlockUp',
        'move up',
        noremap = false,
        modes = 'x',
      },
      [dd.down] = {
        '<Plug>MoveBlockDown',
        'move up',
        noremap = false,
        modes = 'x',
      },
    },
  }

  reg({
    modes = 'n',
  }, {
    -- p = { 'p', 'paste' },
    -- xx = { '"+dd', 'cut line' },
    -- cc = { '""S', 'replace line' },
    -- dd = { '""dd', 'delete line' },
    [a.edit] = {
      name = '+edit',
      h = {
        name = '+annotatate',
        -- c = {
        --   "<cmd>lua require('neogen').generate({ type = 'class' })<cr>",
        --   'class',
        -- },
        -- f = {
        --   "<cmd>lua require('neogen').generate({ type = 'func' })<cr>",
        --   'function',
        -- },
        -- t = {
        --   "<cmd>lua require('neogen').generate({ type = 'type' })<cr>",
        --   'type',
        -- },
      },
    },
  })
  reg({
    modes = 'n',
    noremap = false,
  }, {
    [a.edit] = {
      -- c = { '<plug>kommentary_motion_default', 'comment' },
      -- N = { '<Plug>(ninja-insert)', 'ninja insert' },
      -- n = { '<Plug>(ninja-append)', 'ninja append' },
      -- [dd.left] = { '<Plug>MoveCharLefg', 'move up' },
      -- [dd.right] = { '<Plug>MoveCharRight', 'move up' },
      -- [dd.up] = { '<Plug>MoveLineUp', 'move up' },
      -- [dd.down] = { '<Plug>MoveLineDown', 'move up' },
      -- [a.edit] = {
      --   name = 'line',
      --   x = { '<Plug>(ExchangeLine)', 'exchange' },
      --   c = { '<plug>kommentary_line_default', 'comment' },
      -- },
    },
  })
  reg({ modes = 'x', noremap = false }, {
    [a.edit] = {
      -- b = { '<cmd>lua require("revj").format_visual()<cr>', 'rev join' }, -- see also plugins.revJ
      -- c = { '<Plug>kommentary_visual_default<esc>', 'comment' },
      -- [dd.left] = { '<Plug>MoveBlockLeft', 'move up' },
      -- [dd.right] = { '<Plug>MoveBlockRight', 'move up' },
      -- [dd.up] = { '<Plug>MoveBlockUp', 'move up' },
      -- [dd.down] = { '<Plug>MoveBlockDown', 'move up' },
      -- ['<c-j>'] = { '<Plug>(dial-increment-additional)' },
      -- ['<c-x>'] = { '<Plug>(dial-decrement-additional)' },
    },
  })
  reg({ modes = 'nx' }, {
    -- C = { '""C', 'replace to EOL' },
    -- c = { '""c', 'replace' },
    -- D = { '""D', 'delete to EOL' },
    -- d = { '""d', 'delete' },
    -- R = { 'R', 'replace' },
    -- r = { 'r', 'replace char' },
    -- X = { '"+d$', 'cut to EOL' },
    -- x = { '"+d', 'cut' },
    -- ['c-v'] = { 'gp', 'paste' }, -- FIXME:
    [a.edit] = {
      -- a = { '<cmd>CodeActionMenu<cr>', 'code action' },
      -- B = { 'J', 'join' },
      -- -- b (unjoin): mapped by the plugin
      -- f = { '<cmd>Telescope refactoring<cr>', 'refactoring' },
      -- i = { '>>', 'indent' },
      -- s = { '<cmd>lua vim.lsp.buf.rename()<cr>', 'rename' },
      -- t = { '<<', 'dedent' },
      -- U = { 'gU', 'uppercase' },
      -- u = { 'gu', 'lowercase' },
      -- v = { rep [["zc<C-R>=casechange#next(@z)<CR><Esc>v`[']], 'change case' }, -- FIXME: not repeatable
      -- -- v = { 'g~', 'toggle case' },
      -- w = {
      --   "<cmd>lua require'telescope.builtin'.symbols{ sources = {'math', 'emoji'} }<cr><esc>",
      --   'symbols',
      -- },
      -- z = {
      --   "<cmd>lua require('telescope.builtin').spell_suggest(require('telescope.themes').get_cursor{})<cr>",
      --   'spell suggest',
      -- },
    },
  })
  reg({ modes = 'nx', noremap = false }, {
    [a.edit] = {
      -- r = { '<Plug>(operator-sandwich-replace)', 'sandwich replace' },
      -- X = { '<Plug>(ExchangeClear)', 'exchange clear' },
      -- x = { '<Plug>(Exchange)', 'exchange' },
      -- Y = { '<Plug>(operator-sandwich-delete)', 'sandwich delete' },
      -- y = { '<Plug>(operator-sandwich-add)', 'sandwich add' },
    },
  })
  reg({ modes = 'nx', expr = true, noremap = false }, {
    -- ['<c-j>'] = {
    --   "luasnip#choice_active() ? '<plug>luasnip-next-choice' : '<plug>(dial-increment)'",
    -- },
    -- ['<c-x>'] = {
    --   "luasnip#choice_active() ? '<plug>luasnip-previous-choice' : '<plug>(dial-decrement)'",
    -- },
  })
end

local function map_jump()
  local map = require('utils').map
  local register = require('which-key-fallback').register
  register({
    N = {
      "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>",
      'search previous',
    },
    n = {
      "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>",
      'search next',
    },
    r = { 'r', 'replace char' },
    [a.jump] = {
      A = {
        '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>',
        'go previous diagnostic',
      },
      a = {
        '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>',
        'go next diagnostic',
      },
      D = { '[c', 'previous change' }, -- FIXME:
      d = { ']c', 'next change' }, -- FIXME:
      o = { '`.', 'last change' },
      -- Z = { '<cmd>lua require"bindutils".spell_next(-1)<cr>', 'prevous misspelled' },
      -- z = { '<cmd>lua require"bindutils".spell_next()<cr>', 'next misspelled' },
      Z = { '[s', 'prevous misspelled' },
      z = { ']s', 'next misspelled' },
      [':'] = { 'g,', 'newer change' },
      [';'] = { 'g;', 'older changer' },
      ['é'] = {
        "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>",
        'current buffer fuzzy find',
      },
    },
  }, {
    mode = 'n',
  })
  map(
    'nx',
    'b',
    '<Plug>(asterisk-z*)<cmd>lua require"hlslens".start()<cr>',
    { noremap = false }
  )
  map(
    'x',
    'B',
    '<Plug>(asterisk-gz*)<cmd>lua require"hlslens".start()<cr>',
    { noremap = false }
  )
  map(
    'nxo',
    'f',
    'reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_f" : "f"',
    { noremap = false, expr = true }
  )
  map(
    'nxo',
    'F',
    'reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_F" : "F"',
    { noremap = false, expr = true }
  )
  map(
    'nxo',
    't',
    'reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_t" : "t"',
    { noremap = false, expr = true }
  )
  map(
    'nxo',
    'T',
    'reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_T" : "T"',
    { noremap = false, expr = true }
  )

  for mode in string.gmatch('nxo', '.') do
    register({
      W = { 'B', 'previous word' },
      w = { 'b', 'next word' },
      E = { 'E', 'previous bigword' },
      e = { 'e', 'next bigword ' },
      [dd.right] = { 'l', 'right' },
      [dd.left] = { 'h', 'left' },
      [dd.up] = { 'k', 'up' },
      [dd.down] = { 'j', 'down' },
      [a.jump] = {
        E = { 'gg', 'first line' },
        e = { 'G', 'last line' },
        L = {
          "<cmd>lua require('telescope.builtin').loclist()<cr>",
          'loclist',
        },
        s = {
          "<cmd>lua require('telescope.builtin').treesitter()<cr>",
          'symbols',
        },
        [dd.up] = { 'gk', 'visual up' },
        [dd.down] = { 'gj', 'visual down' },
      },
    }, {
      mode = mode,
    })
  end
  for mode in string.gmatch('nxo', '.') do
    register({
      -- F = { '<Plug>Lightspeed_F', 'F' },
      -- f = { '<Plug>Lightspeed_f', 'f' },
      S = { '<Plug>Lightspeed_S', 'S' },
      s = { '<Plug>Lightspeed_s', 's' },
      -- T = { '<Plug>Lightspeed_T', 'T' },
      -- t = { '<Plug>Lightspeed_t', 't' },
      [a.jump] = {
        C = { '<plug>(matchup-g%)', 'matchup cycle backward' },
        c = { '<plug>(matchup-%)', 'matchup cycle forward' },
        Y = { '<plug>(matchup-[%)', 'matchup backward' },
        y = { '<plug>(matchup-]%)', 'matchup forward' },
        i = { '<plug>(matchup-z%)', 'matchup inward' },
      },
    }, {
      mode = mode,
      noremap = false,
    })
  end
end

-- workspace movements
local function map_move()
  local register = require('which-key-fallback').register
  register({
    b = { '<cmd>Telescope buffers<cr>', 'buffers' },
    D = { '<cmd>Telescope lsp_type_definitions<cr>', 'go type' }, -- also, trouble
    d = { '<cmd>Telescope lsp_definitions<cr>', 'go definition' }, -- also, trouble
    E = { '<cmd>lua require"alt-jump".reset()<cr>', 'alt-jump reset' },
    e = { '<cmd>lua require"alt-jump".toggle()<cr>', 'alt-jump' },
    I = { '<cmd>lua vim.lsp.buf.declaration()<cr>', 'go declaration' }, -- FIXME:
    i = { '<cmd>Telescope lsp_implementations<cr>', 'go implementation' }, -- also, trouble
    o = {
      "<cmd>lua require('telescope.builtin').oldfiles({only_cwd = true})<cr>",
      'oldfiles',
    },
    --   "<cmd>Telescope lsp_references<cr>",
    -- r = {
    --   'lsp references',
    -- },
    p = { '<cmd>TodoTrouble<cr>', 'telescope TODO' },
    P = { '<cmd>TodoTelescope<cr>', 'telescope TODO' },
    r = {
      '<cmd>Trouble lsp_references<cr>',
      'lsp references',
    },
    T = {
      '<cmd>lua require("trouble").previous({skip_groups = true, jump = true})<cr>',
      'trouble, previous',
    },
    t = {
      '<cmd>lua require("trouble").next({skip_groups = true, jump = true})<cr>',
      'trouble, next',
    },
    ['é'] = {
      '<cmd>Telescope live_grep<cr>',
      'live grep',
    },
    [a.move] = {
      '<cmd>lua require("bindutils").project_files()<cr>',
      'project file',
    },
  }, {
    prefix = a.move,
  })
end

local function map_editor()
  local map = require('utils').map
  local register = require('which-key-fallback').register
  if false then
    map('n', '<c-i>', '<cmd>lua require"bufjump".local_backward()<cr>')
  end
  map('n', '<c-o>', '<cmd>lua require"bufjump".local_forward()<cr>')
  register({
    a = {
      '<cmd>TroubleToggle lsp_workspace_diagnostics<cr>',
      'lsp diagnostics',
    },
    A = {
      '<cmd>TroubleToggle lsp_document_diagnostics<cr>',
      'lsp document diagnostics',
    },
    b = { -- FIXME:
      '<cmd>lua require"bufjump".forward(require"bufjump".not_under_cwd)<cr>',
      'next workspace',
    },
    B = { -- FIXME:
      '<cmd>lua require"bufjump".backward(require"bufjump".not_under_cwd)<cr>',
      'previous workspace',
    },
    d = { '<cmd>DiffviewOpen<cr>', 'diffview open' },
    D = { '<cmd>DiffviewClose<cr>', 'diffview close' },
    e = {
      '<cmd>lua require"bindutils".edit_current()<cr>',
      'current in new editor',
    },
    f = { '<cmd>NvimTreeOpen<cr>', 'file tree' }, -- FIXME: find a way to focus current file on opening
    F = { '<cmd>NvimTreeClose<cr>', 'file tree' },
    g = { '<cmd>Neogit<cr>', 'neogit' },
    G = { '<cmd>Gitsigns setqflist<cr>', 'trouble hunk' },
    h = { '<cmd>DiffviewFileHistory<cr>', 'diffview open' },
    H = { '<cmd>DiffviewClose<cr>', 'diffview close' },
    i = { "<cmd>lua require'dapui'.toggle()<cr>", 'toggle dapui' },
    m = { '<cmd>Telescope installed_plugins<cr>', 'plugins' },
    n = { '<cmd>Telescope modules<cr>', 'node modules' },
    o = {
      "<cmd>lua require'bindutils'.open_current()<cr>",
      'open current external',
    },
    p = { "<cmd>lua require'setup-session'.develop()<cr>", 'session develop' },
    q = { '<cmd>TroubleToggle quickfix<cr>', 'quickfix' },
    Q = { '<cmd>TroubleClose<cr>', 'trouble close' },
    r = { '<cmd>update<cr><cmd>luafile %<cr>', 'reload' },
    s = { '<cmd>lua require"bindutils".outliner()<cr>', 'outliner' },
    S = { '<cmd>TroubleToggle lsp_references<cr>', 'lsp reference' },
    t = { '<cmd>lua require"bindutils".term()<cr>', 'new terminal' },
    u = { '<cmd>UndotreeToggleTree<cr>', 'undo tree' },
    w = { '<cmd>Telescope my_projects<cr>', 'sessions' },
    W = { '<cmd>Telescope project_directory<cr>', 'projects' },
    x = {
      "<cmd>lua require'bindutils'.term_launch({'xplr', vim.fn.expand'%'})<cr>",
      'xplr',
    },
    z = { '<cmd>ZenMode<cr>', 'zen mode' },
    ['.'] = { '<cmd>lua require"bindutils".dotfiles()<cr>', 'dotfiles' },
    ['"'] = {
      "<cmd>lua require'nononotes'.prompt('edit', false, 'all')<cr>",
      'pick note',
    },
    [' '] = {
      "<cmd>lua require('telescope.builtin').commands()<cr>",
      'commands',
    },
  }, {
    prefix = a.editor,
  })
end

local function map_browser()
  local register = require('which-key-fallback').register
  register {
    [a.browser] = {
      man = { '<cmd>lua require"browser".man()<cr>', 'man page' },
      o = {
        '<cmd>call jobstart(["xdg-open", expand("<cfile>")]<cr>, {"detach": v:true})<cr>',
        'open current file',
      },
      p = { "<cmd>lua require'setup-session'.launch()<cr>", 'session lauch' },
      u = {
        '<cmd>lua require"browser".openCfile()<cr>',
        'open current file',
      },
    },
  }
  require('browser').mapBrowserSearch(a.browser, '+browser search', {
    arch = {
      'https://wiki.archlinux.org/index.php?search=',
      'archlinux wiki',
    },
    aur = { 'https://aur.archlinux.org/packages/?K=', 'aur packages' },
    ca = {
      'https://www.cairn.info/resultats_recherche.php?searchTerm=',
      'cairn',
    },
    cn = { 'https://www.cnrtl.fr/definition/', 'cnrtl' },
    d = { 'https://duckduckgo.com/?q=', 'duckduckgo' },
    eru = {
      'https://www.erudit.org/fr/recherche/?funds=%C3%89rudit&funds=UNB&basic_search_term=',
      'erudit',
    },
    fr = {
      'https://pascal-francis.inist.fr/vibad/index.php?action=search&terms=',
      'francis',
    },
    gh = { 'https://github.com/search?q=', 'github' },
    go = { 'https://google.ca/search?q=', 'google' },
    lh = { 'https://www.libhunt.com/search?query=', 'libhunt' },
    mdn = { 'https://developer.mozilla.org/en-US/search?q=', 'mdn' },
    nell = {
      'https://nelligan.ville.montreal.qc.ca/search*frc/a?searchtype=Y&searcharg=',
      'nelligan',
    },
    npm = { 'https://www.npmjs.com/search?q=', 'npm' },
    pac = { 'https://archlinux.org/packages/?q=', 'arch packages' },
    sea = { 'https://www.seriouseats.com/search?q=', 'seriouseats' },
    sep = { 'https://plato.stanford.edu/search/searcher.py?query=', 'sep' },
    sp = { 'https://www.persee.fr/search?ta=article&q=', 'persée' },
    usi = { 'https://usito.usherbrooke.ca/d%C3%A9finitions/', 'usito' },
    we = { 'https://en.wikipedia.org/wiki/', 'wikipidia en' },
    wf = { 'https://fr.wikipedia.org/wiki/', 'wikipidia fr' },
    y = { 'https://www.youtube.com/results?search_query=', 'youtube' },
  })
end

local function map_help()
  local register = require('which-key-fallback').register
  register({
    d = { '<cmd>lua require"bindutils".docu_current()<cr>', 'filetype docu' },
    h = {
      '<cmd>e ~/Dotfiles/bindings-qwerty/.config/nvim/lua/bindings.lua<cr>',
      'bindings',
    }, -- FIXME: use `realpath` instead
    m = {
      "<cmd>lua require('telescope.builtin').man_pages()<cr>",
      'man pages',
    },
    p = { '<cmd>Telescope md_help<cr>', 'md help' },
    v = {
      "<cmd>lua require('telescope.builtin').help_tags()<cr>",
      'help tags',
    },
  }, {
    prefix = 'H',
  })
end

-- local function map_()
--   local map = require('utils').map
--   local register = require 'which-key-fallback'.register
-- end

local function map_markdown()
  local map_local = require('utils').buf_map
  map_local('i', '<c-a>', '<c-o>g^')
  map_local('i', '<c-e>', '<c-o>g$')
  map_local('nvo', '<c-a>', 'g^')
  map_local('nvo', '<c-e>', 'g$')
  -- both are identical
  map_local('ox', 'ad', '<Plug>(textobj-datetime-auto)', { noremap = false })
  map_local('ox', 'id', '<Plug>(textobj-datetime-auto)', { noremap = false })

  local register = require('which-key-fallback').register
  local buffer = vim.api.nvim_get_current_buf()
  register({
    y = { '<Plug>Markdown_OpenUrlUnderCursor', 'follow url' },
  }, {
    prefix = a.move,
    buffer = buffer,
  })
  for mode in string.gmatch('nxo', '.') do
    register({
      s = { '<cmd>Telescope heading<cr>', 'headings' },
      t = { '<Plug>Markdown_MoveToNextHeader', 'next header' },
      T = {
        '<Plug>Markdown_MoveToPreviousHeader',
        'previous header',
      },
      h = {
        '<Plug>Markdown_MoveToCurHeader',
        'current header',
      },
      H = {
        '<Plug>Markdown_MoveToParentHeader',
        'parent header',
      },
    }, {
      prefix = a.jump,
      mode = mode,
      buffer = buffer, -- FIXME: this is still setting bindings as global
      noremap = false,
    })
  end
  for mode in string.gmatch('nxo', '.') do
    register({
      [dd.up] = { 'gk', 'visual line up' },
      [dd.down] = { 'gj', 'visual line down' },
      [a.jump] = {
        [dd.up] = { 'k', 'physical line up' },
        [dd.down] = { 'j', 'physical line down' },
      },
    }, {
      mode = mode,
      buffer = buffer, -- FIXME: this is still setting bindings as global
    })
  end

  if require('pager').full then
    vim.fn.call('textobj#sentence#init', {})
  end
end

local function map_readonly()
  if not vim.bo.readonly then
    return
  end
  local map = require('utils').buf_map
  map('nxo', 'x', '<cmd>q<cr>', { nowait = true })
  map('nxo', 'u', '<c-u>', { noremap = false, nowait = true })
  map('nxo', 'd', '<c-d>', { noremap = false, nowait = true })
end

--[[
## Macros (Q)

## Text objects (ai)
| key                                       | Description           | source                |
| ----------------------------------------- | --------------------- | --------------------- |
| a                                         | argument              | targets               |
| b                                         | brackets              | vim, targets          |
| B                                         | block                 | vim, targets          |
| c                                         | matching block        | matchup               |
| d                                         | datetimem ft:markdown | datetimee             |
| e                                         | entire buffer         | entire                |
| f                                         | function              | ts                    |
| g                                         | parameter             | ts                    | inner only
| i                                         | indent                | indent                |
| I                                         | indent                | indent                |
| l                                         | line                  | -                     | ?? conflict with targers
| p                                         | paragraph             | vim                   |
| q                                         | quotes                | targets               |
| r                                         | auto                  | sandwich              |
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

| Key bindings | Description                                                 |
| ------------ | ----------------------------------------------------------- |
| `<count>ai`  | **A**n **I**ndentation level and line above.                |
| `<count>ii`  | **I**nner **I**ndentation level (**no line above**).        |
| `<count>aI`  | **A**n **I**ndentation level and lines above/below.         |
| `<count>iI`  | **I**nner **I**ndentation level (**no lines above/below**). |


| command | key              |
| ------- | ---------------- |
| r       | RecordNew        |
| n       | RotateBack       |
| N       | RotateForward    |
| a       | Append           |
| A       | Prepend          |
| w       | NameCurrentMacro |
--]]
function M.setup()
  vim.cmd 'cmapclear'
  vim.cmd 'imapclear'
  -- require('utils').augroup('ReadonlyMappings', {
  --   {
  --     events = { 'BufReadPost' },
  --     targets = { '*' },
  --     command = map_readonly,
  --   },
  -- })
  require('utils').augroup('MarkdownBindings', {
    {
      events = { 'FileType' },
      targets = { 'markdown' },
      command = map_markdown,
    },
  })
  map_text_objects()
  map_edit()
  map_jump()
  map_move()
  map_editor()
  map_browser()
  map_help()
  map_command_insert()
  map_readonly()

  local register = require('which-key-fallback').register
  local map = require('utils').map

  -- TODO: remap cmp c-e
  -- fish-emacs compatibility
  map('l', '<c-e>', '<end>')
  map('l', '<c-a>', '<home>')
  map('i', '<c-a>', '<c-o>^')
  map('i', '<c-e>', '<c-o>$')
  map('nvo', '<c-a>', '^')
  map('nvo', '<c-e>', '$')
  map('nvol', '<c-p>', '<up>')
  map('nvol', '<c-n>', '<down>')
  map('nvol', '<c-c>', '<esc>')
  map('n', '<a-t>', '"zdh"zp') -- transpose
  map('i', '<a-t>', '<esc>"zdh"zpa') -- transpose

  -- TODO:map reselect "gv"

  map('nx', '<leader><leader>', ':')

  map('nxo', 'q', '<nop>')
  map('nxo', a.edit, '<nop>')
  map('nxo', a.jump, '<nop>')
  map('nxo', a.move, '<nop>')
  map('nxo', a.mark, '<nop>')
  map('nxo', a.macro, '<nop>')
  map('nxo', a.editor, '<nop>')
  map('nxo', a.help, '<nop>')
  map('nxo', a.browser, '<nop>')
  map('nxo', 'gg', '<nop>')
  map('nxo', "g'", '<nop>')
  map('nxo', 'g`', '<nop>')
  map('nxo', 'g~', '<nop>')
  map('nxo', 'gg', '<nop>')
  map('nxo', 'gg', '<nop>')
  map('', '<c-u>', '<nop>')
  map('', '<c-d>', '<nop>')

  local function remark(new, old)
    map('nxo', a.mark .. new, '`' .. old)
    map('nxo', a.mark .. new, "'" .. old)
  end
  remark('V', '<')
  remark('v', '>')
  remark('P', '[')
  remark('p', ']')

  -- neoscroll
  require('neoscroll.config').set_mappings {
    J = { 'scroll', { '-vim.wo.scroll', 'true', '250' } },
    K = { 'scroll', { 'vim.wo.scroll', 'true', '250' } },
    zt = { 'zt', { '250' } },
    zz = { 'zz', { '250' } },
    zb = { 'zb', { '250' } },
  }

  map(
    'i',
    '<cr>',
    'v:lua.MPairs.autopairs_cr()',
    { expr = true, noremap = true }
  )
  map('is', '<Tab>', '<cmd>lua require"bindutils".tab_complete()<cr>')
  map('is', '<s-Tab>', '<cmd>lua require"bindutils".s_tab_complete()<cr>')
  map('is', '<c-space>', '<cmd>lua require"bindutils".toggle_cmp()<cr>')

  -- macrobatics
  if false then
    map('n', a.macro .. a.macro, '<plug>(Mac_Play)', { noremap = false })
  end
  map('n', a.macro .. 'r', '<plug>(Mac_RecordNew)', { noremap = false })
  map('n', a.macro .. 'n', '<plug>(Mac_RotateBack)', { noremap = false })
  map('n', a.macro .. 'N', '<plug>(Mac_RotateForward)', { noremap = false })
  map('n', a.macro .. 'a', '<plug>(Mac_Append)', { noremap = false })
  map('n', a.macro .. 'A', '<plug>(Mac_Prepend)', { noremap = false })
  map('n', a.macro .. 'w', '<plug>(Mac_NameCurrentMacro)', { noremap = false })
  map(
    'n',
    a.macro .. 'fw',
    '<plug>(Mac_NameCurrentMacroForFileType)',
    { noremap = false }
  )
  map(
    'n',
    a.macro .. 'sw',
    '<plug>(Mac_NameCurrentMacroForCurrentSession)',
    { noremap = false }
  )
  map(
    'n',
    a.macro .. dd.search .. 'r',
    '<plug>(Mac_SearchForNamedMacroAndOverwrite)',
    { noremap = false }
  )
  map(
    'n',
    a.macro .. dd.search .. 'n',
    '<plug>(Mac_SearchForNamedMacroAndRename)',
    { noremap = false }
  )
  map(
    'n',
    a.macro .. dd.search .. 'd',
    '<plug>(Mac_SearchForNamedMacroAndDelete)',
    { noremap = false }
  )
  map(
    'n',
    a.macro .. dd.search .. 'q',
    '<plug>(Mac_SearchForNamedMacroAndPlay)',
    { noremap = false }
  )
  map('n', a.macro .. 'l', 'DisplayMacroHistory')

  -- VSSPlit
  -- maybe not K...if for visual only
  map('nxo', 'V', '<c-v>')
  map('x', 'v', 'V')
  map('x', '<c-w>r', '<Plug>(Visual-Split-VSResize)', { noremap = false })
  map('x', '<c-w>S', '<Plug>(Visual-Split-VSSplit)', { noremap = false })
  map(
    'x',
    '<c-w>' .. dd.up,
    '<Plug>(Visual-Split-VSSplitAbove)',
    { noremap = false }
  )
  map(
    'x',
    '<c-w>' .. dd.down,
    '<Plug>(Visual-Split-VSSplitBelow)',
    { noremap = false }
  )

  -- nxi mappings
  for mode in string.gmatch('nxi', '.') do
    register({
      [alt(dd.left)] = {
        '<cmd>lua require"wrap_win".left()<cr>',
        'window left',
      },
      [alt(dd.down)] = {
        '<cmd>lua require"wrap_win".down()<cr>',
        'window down',
      },
      [alt(dd.up)] = { '<cmd>lua require"wrap_win".up()<cr>', 'window up' },
      [alt(dd.right)] = {
        '<cmd>lua require"wrap_win".right()<cr>',
        'window right',
      },
      ['<a-b>'] = { '<cmd>wincmd p<cr>', 'window back' },
      ['<a-a>'] = { '<cmd>e#<cr>', 'previous buffer' }, -- move
      ['<a-w>'] = { '<cmd>q<cr>', 'close window' },
      -- ['<c-l>'] = {
      --   "<cmd>nohlsearch<cr><cmd>lua require('hlslens.main').cmdl_search_leave()<cr>",
      --   'nohlsearch',
      -- },
      ['<c-l>'] = { '<cmd>nohlsearch<cr>', 'nohlsearch' },
      ['<c-q>'] = { '<cmd>qall!<cr>', 'quit' },
      ['<c-s>'] = { '<cmd>w!<cr>', 'save' },
      -- ['<a-t>'] = { '<cmd><cr>', 'edit alt' },
    }, {
      mode = mode,
    })
  end

  -- n mappings
  register {
    ['<c-n>'] = {
      '<cmd>lua require("bufjump").forward()<cr>',
      'jump next buffer',
    },
    ['<c-p>'] = {
      '<cmd>lua require("bufjump").backward()<cr>',
      'jump previous buffer',
    },
    ['<leader>'] = {
      s = {
        name = '+LSP',
        a = {
          '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>',
          'show line diagnostics',
        },
        C = { '<cmd>lua vim.lsp.buf.incoming_calls()<cr>', 'incoming calls' },
        c = { '<cmd>lua vim.lsp.buf.outgoing_calls()<cr>', 'outgoing calls' },
        d = { '<cmd>lua PeekDefinition()<cr>', 'hover definition' },
        k = { '<cmd>lua vim.lsp.buf.hover()<cr>', 'hover' },
        r = { '<cmd>lua vim.lsp.buf.references()<cr>', 'references' },
        s = { '<cmd>lua vim.lsp.buf.signature_help()<cr>', 'signature help' },
        t = {
          '<cmd>lua vim.lsp.buf.type_definition()<cr>',
          'go to type definition', -- ??
        },
        wa = {
          '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>',
          'add workspace folder',
        },
        wl = {
          '<cmd>lua vim.lsp.buf.list_workspace_folder()<cr>',
          'rm workspace folder',
        },
        wd = {
          '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>',
          'rm workspace folder',
        },
        x = {
          '<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<cr>',
          'stop active clients',
        },
      },
      z = {
        name = '+Spell',
        b = { '<cmd>setlocal spell spelllang=en_us,fr,cjk<cr>', 'en fr' },
        e = { '<cmd>setlocal spell spelllang=en_us,cjk<cr>', 'en' },
        f = { '<cmd>setlocal spell spelllang=fr,cjk<cr>', 'fr' },
        g = { '<cmd>LanguageToolCheck<cr>', 'language tools' },
        x = { '<cmd>setlocal nospell spelllang=<cr>', 'none' },
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
    },
  }
end

local vim = vim

M.plugins = {
  vim = {
    -- options related to mapping
    g = {
      mapleader = ' ',
    },
  },
  anywise_reg = {
    textobjects = {
      { 'i', 'a' },
      { 'w', 'W' },
    },
    paste_keys = {
      ['p'] = 'p',
    },
    setmap = {
      y = 'y',
      x = 'd',
    },
  },
  revJ = {
    operator = a.edit .. 'b', -- for operator (+motion)
    line = a.edit .. a.edit .. 'b', -- for formatting current line
  },
  lightspeed = invert {
    a = 'instant_repeat_fwd_key',
    A = 'instant_repeat_bwd_key',
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
  marks = invert {
    [a.mark .. 't'] = 'toggle', -- Toggle next available mark at cursor.
    [a.mark .. 'd'] = 'delete_line', -- Deletes all marks on current line.
    [a.mark .. 'D'] = 'delete_buf', -- Deletes all marks in current buffer.
    [a.jump .. 'm'] = 'next', -- Goes to next mark in buffer.
    [a.jump .. 'M'] = 'prev', -- Goes to previous mark in buffer.
    [a.mark .. a.mark] = 'preview', -- Previews mark (will wait for user input). press <cr> to just preview the next mark.
    [a.mark .. 's'] = 'set', -- Sets a letter mark (will wait for input).
    [a.mark .. 'S'] = 'delete', -- Delete a letter mark (will wait for input).
    -- 'set_next', -- Set next available lowercase mark at cursor.
    --set_bookmark[0-9]     -- Sets a bookmark from group[0-9].
    --delete_bookmark[0-9]  -- Deletes all bookmarks from group[0-9].
    --delete_bookmark       -- Deletes the bookmark under the cursor.
    --next_bookmark         -- Moves to the next bookmark having the same type as the
    --                      -- bookmark under the cursor.
    --prev_bookmark         -- Moves to the previous bookmark having the same type as the
    --                      -- bookmark under the cursor.
    --next_bookmark[0-9]    -- Moves to the next bookmark of of the same group type. Works by
    --                      -- first going according to line number, and then according to buffer
    --                      -- number.
    --prev_bookmark[0-9]    -- Moves to the previous bookmark of of the same group type. Works by
    --                      -- first going according to line number, and then according to buffer
    --                      -- number.
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
  treesitter = {
    textobjects = {
      select = {
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
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
          ['gf'] = '@function.outer',
        },
        goto_previous_end = {
          ['gF'] = '@function.outer',
        },
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
      ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line()<cr>',
      ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<cr>',
      ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<cr>',
      ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<cr>',
      ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<cr>',
    },
  },
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
