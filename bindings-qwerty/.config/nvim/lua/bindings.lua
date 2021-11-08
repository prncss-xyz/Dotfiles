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

local function safe_merge(inv, dir, new)
  for key, value in pairs(new) do
    if dir[key] then
      print(
        string.format(
          'key %q in conflict, %q is declared, trying to add %q',
          key,
          dir[key],
          value
        )
      )
    elseif inv[value] then
      print(
        string.format(
          'trying to add value %q to %q, while it is already attached to %q',
          value,
          key,
          inv[value]
        )
      )
    else
      inv[value] = key
    end
  end
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
local d0 = {
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

-- map('é', 'search', {
--   jump = {'/', '?'},
--   d'jump' = 'k',
--   move = '<cmd><cr>',
-- }, {expr=true})

local function append(word)
  return function(str)
    return str .. word
  end
end

local function prepend(word)
  return function(str)
    return str .. word
  end
end

local adapters = {
  default = { append ' next', append ' previous' },
  un = { prepend '', prepend 'un' },
  time = { append ' forward', append 'back' },
}

local function d(key)
  return {
    type = 'doubler',
    adapter = function(str)
      return 'line ' .. str
    end,
  }
end

local function id(x)
  return x
end

local function allmap(key, name, maps, opts)
  local register = require 'which-key-fallback'
  for domain, lhs in pairs(maps) do
    local adapter2 = id
    local k = key
    if type(domain) == 'table' then
      adapter2 = domain.adapter
      k = key .. key
    end
    if type(lhs == 'table') then
      local adapter = adapters[lhs.typ or 'default']
      register({ a[domain] .. k, lhs[1], adapter2(adapter[1](name)) }, opts)
      register({ a[domain] .. s(k), lhs[2], adapter2(adapter[2](name)) }, opts)
    else
      register({ a[domain] .. k, lhs, name }, opts)
    end
  end
end

local dd = invert(d0)

safe_merge(dd, d0, {})

local r = invert {
  a = 'outer',
  i = 'inner',
}

local function map_command_insert()
  local map = require('utils').map
  -- TODO: dedent
  -- char
  map('ci', '<c-d>', '<c-h>') -- kill
  map('ci', '<c-b>', '<left>')
  map('ci', '<c-f>', '<right>')
  map('ci', '<c-w>', '<c-w>')
  map('ci', '<c-g>', '<c-right>')
  map('ci', '<c-h>', '<c-left>')

  -- line
  map('ci', '<c-u>', '<c-u>') -- kill
  map('i', '<c-k>', '<c-o>d$')
  map('i', '<c-o>', '<c-o>')

  -- commandline
  map('c', '<a-v>', '<c-f>') -- edit command line
  map('c', '<c-v>', '<c-r>+') -- paste to command line
end

-- summary
-- jkl;       -- move
-- aA         -- code action, range code action
-- bB         -- unjoin, join
-- c          -- comment
-- f          -- refactoring
-- h          -- annotate
-- nN         -- ninja
-- r          -- sandwich-replace
-- s          -- rename
-- t          -- indent
-- i          -- indent
-- l          -- line
-- uU         -- lowercase
-- v          -- toggle case
-- w          -- telescope symbol
-- x          -- exchange
-- yY         -- sandwich-add, delete
-- z          -- spell suggest
local function map_edit()
  local map = require('utils').map
  local register = require 'which-key-fallback'

  -- neogen
  map(
    'n',
    a.edit .. 'hf',
    "<cmd>lua require('neogen').generate({ type = 'func' })<cr>",
    { noremap = false }
  )
  map(
    'n',
    a.edit .. 'hc',
    "<cmd>lua require('neogen').generate({ type = 'class' })<cr>",
    { noremap = false }
  )
  map(
    'n',
    a.edit .. 'ht',
    "<cmd>lua require('neogen').generate({ type = 'type' })<cr>",
    { noremap = false }
  )

  -- refactoring
  map('', a.edit .. 'f', '<cmd>Telescope refactoring<cr>')

  -- matze move
  local rep = require('bindutils').repeatable
  map('v', a.edit .. dd.left, rep '<Plug>MoveBlockLeft', { noremap = false })
  map('v', a.edit .. dd.right, rep '<Plug>MoveBlockRight', { noremap = false })
  map('n', a.edit .. dd.left, rep '<Plug>MoveCharLeft', { noremap = false })
  map('n', a.edit .. dd.right, rep '<Plug>MoveCharRight', { noremap = false })
  map('v', a.edit .. dd.up, rep '<Plug>MoveBlockUp', { noremap = false })
  map('n', a.edit .. dd.up, rep '<Plug>MoveLineUp', { noremap = false })
  map('v', a.edit .. dd.down, rep '<Plug>MoveBlockDown', { noremap = false })
  map('n', a.edit .. dd.down, rep '<Plug>MoveLineDown', { noremap = false })

  -- exchange (repeat)
  map('nx', a.edit .. 'x', '<Plug>(Exchange)', { noremap = false })
  map(
    'nx',
    a.edit .. a.edit .. 'x',
    '<Plug>(ExchangeLine)',
    { noremap = false }
  )
  map('nx', a.edit .. 'xc', '<Plug>(ExchangeClear)', { noremap = false })

  -- sandwich
  map('', a.edit .. 'y', '<Plug>(operator-sandwich-add)', { noremap = false })
  map(
    '',
    a.edit .. 'Y',
    '<Plug>(operator-sandwich-delete)',
    { noremap = false }
  )
  map(
    '',
    a.edit .. 'r',
    '<Plug>(operator-sandwich-replace)',
    { noremap = false }
  )
  map('ox', 'ir', '<Plug>(textobj-sandwich-auto-i)', { noremap = false })
  map('ox', 'ar', '<Plug>(textobj-sandwich-auto-a)', { noremap = false })
  map('ox', 'iy', '<Plug>(textobj-sandwich-query-i)', { noremap = false })
  map('ox', 'ay', '<Plug>(textobj-sandwich-query-a)', { noremap = false })

  -- ninja feet
  map('o', a.edit .. 'Ni', '<Plug>(ninja-left-foot-inner)', {
    noremap = false,
  })
  map('o', a.edit .. 'Na', '<Plug>(ninja-left-foot-a)', { noremap = false })
  map(
    'o',
    a.edit .. 'ni',
    '<Plug>(ninja-right-foot-inner)',
    { noremap = false }
  )
  map('o', a.edit .. 'na', '<Plug>(ninja-right-foot-a)', { noremap = false })
  map('n', a.jump .. 'N', '<Plug>(ninja-insert)', { noremap = false })
  map('n', a.jump .. 'n', '<Plug>(ninja-append)', { noremap = false })

  -- case-change
  map('nx', a.edit .. 'v', rep [["zc<C-R>=casechange#next(@z)<CR><Esc>v`[']])

  -- kommentary
  map(
    'n',
    a.edit .. a.edit .. 'c',
    '<plug>kommentary_line_default',
    { noremap = false }
  )
  map(
    'n',
    a.edit .. 'c',
    '<Plug>kommentary_motion_default',
    { noremap = false }
  )
  map(
    'x',
    a.edit .. 'c',
    '<Plug>kommentary_visual_default<esc>',
    { noremap = false }
  )
  map('nvx', a.edit .. 'a', '<cmd>CodeActionMenu<cr>')

  for mode in string.gmatch('nx', '.') do
    register({
      -- J = { 'gJ', 'join' },
      -- a = {
      --   "<cmd>lua require('telescope.builtin').lsp_code_actions(require('telescope.themes').get_cursor{})<cr>",
      --   'code actions',
      -- },
      -- A = {
      --   "<cmd>lua require('telescope.builtin').lsp_range_code_actions(require('telescope.themes').get_cursor{})<cr>",
      --   'range code actions',
      -- },
      B = { 'J', 'join' },
      -- b = { '', 'unjoin' }, -- mapped by the plugin
      s = { '<cmd>lua vim.lsp.buf.rename()<cr>', 'rename' },
      i = { '>>', 'indent' },
      t = { '<<', 'dedent' },
      u = { 'gu', 'lowercase' },
      -- v = { 'g~', 'toggle case' },
      -- v = { [["zc<C-R>=casechange#next(@z)<CR><Esc>v`[']], 'toggle case' },
      w = {
        "<cmd>lua require'telescope.builtin'.symbols{ sources = {'math', 'emoji'} }<cr><esc>",
        'symbols',
      }, -- FIXME: insert emoji multiple times
      z = {
        "<cmd>lua require('telescope.builtin').spell_suggest(require('telescope.themes').get_cursor{})<cr>",
        'spell suggest',
      },
    }, {
      prefix = a.edit,
      mode = mode,
    })
  end
end

local function map_jump()
  local map = require('utils').map
  local register = require 'which-key-fallback'

  -- textobject line
  map('vo', 'al', '<Plug>(textobj-line-a)')
  map('vo', 'il', '<Plug>(textobj-line-i)')

  -- matchup
  map('nx', a.jump .. 'C', '<plug>(matchup-g%)', { noremap = false })
  map('nx', a.jump .. 'c', '<plug>(matchup-%)', { noremap = false })
  map('nx', a.jump .. 'Y', '<plug>(matchup-[%)', { noremap = false })
  map('nx', a.jump .. 'y', '<plug>(matchup-]%)', { noremap = false })
  map('nx', a.jump .. 'i', '<plug>(matchup-z%)', { noremap = false })
  map('vo', 'ic', '<plug>(matchup-i%)', { noremap = false })
  map('vo', 'ac', '<plug>(matchup-a%)', { noremap = false })

  if false then
    map('nv', '<c-i>', '<cmd>lua require"bufjump".local_backward()<cr>')
  end
  map('nv', '<c-o>', '<cmd>lua require"bufjump".local_forward()<cr>')

  register({
    a = {
      '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>',
      'go next diagnostic',
    },
    A = {
      '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>',
      'go previous diagnostic',
    },
    d = { ']c', 'next change' },
    D = { '[c', 'previous change' },
    b = { '<cmd>lua require"alt-jump".toggle()<cr>', 'alt-jump' },
    B = { '<cmd>lua require"alt-jump".reset()<cr>', 'alt-jump reset' },
    o = { '`.', 'last change' },
    -- z = { '<cmd>lua require"bindutils".spell_next()<cr>', 'next misspelled' },
    -- Z = { '<cmd>lua require"bindutils".spell_next(-1)<cr>', 'prevous misspelled' },
    z = { ']s', 'next misspelled' },
    Z = { '[s', 'prevous misspelled' },
    [':'] = { 'g,', 'newer change' },
    [';'] = { 'g;', 'older changer' },
    ['é'] = {
      "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>",
      'current buffer fuzzy find',
    },
  }, {
    prefix = a.jump,
  })
  for mode in string.gmatch('nvo', '.') do
    register({
      e = { 'G', 'last line' },
      E = { 'gg', 'first line' },
      L = { "<cmd>lua require('telescope.builtin').loclist()<cr>", 'loclist' },
      s = {
        "<cmd>lua require('telescope.builtin').treesitter()<cr>",
        'symbols',
      },
      [dd.up] = { 'gk', 'visual up' },
      [dd.down] = { 'gj', 'visual down' },
    }, {
      mode = mode,
      prefix = a.jump,
    })
  end
end

-- workspace movements
local function map_move()
  local register = require 'which-key-fallback'
  register({
    p = { '<cmd>TodoTrouble<cr>', 'telescope TODO' },
    P = { '<cmd>TodoTelescope<cr>', 'telescope TODO' },
    b = { '<cmd>Telescope buffers<cr>', 'buffers' },
    d = { '<cmd>Telescope lsp_definitions<cr>', 'go definition' }, -- also, trouble
    D = { '<cmd>Telescope lsp_type_definitions<cr>', 'go type' }, -- also, trouble
    i = { '<cmd>Telescope lsp_implementations<cr>', 'go implementation' }, -- also, trouble
    I = { '<cmd>lua vim.lsp.buf.declaration()<cr>', 'go declaration' }, -- FIXME:
    o = {
      "<cmd>lua require('telescope.builtin').oldfiles({only_cwd = true})<cr>",
      'oldfiles',
    },
    -- r = {
    --   "<cmd>Telescope lsp_references<cr>",
    --   'lsp references',
    -- },
    r = {
      '<cmd>Trouble lsp_references<cr>',
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
  require 'which-key-fallback'({
    a = {
      '<cmd>TroubleToggle lsp_workspace_diagnostics<cr>',
      'lsp diagnostics',
    },
    A = {
      '<cmd>TroubleToggle lsp_document_diagnostics<cr>',
      'lsp document diagnostics',
    },
    b = { -- FIXME:
      '<cmd>lua require"bufjump".backward(require"bufjump".not_under_cwd)<cr>',
      'previous workspace',
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
  local register = require 'which-key-fallback'
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
  require 'which-key-fallback'({
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
--   local register = require 'which-key-fallback'
-- end

local function map_markdown()
  local register = require 'which-key-fallback'
  local map_local = require('utils').buf_map
  local buffer = vim.api.nvim_get_current_buf()
  if true then
    map_local('i', '<c-a>', '<c-o>g^')
    map_local('i', '<c-e>', '<c-o>g$')
    map_local('nvo', '<c-a>', 'g^')
    map_local('nvo', '<c-e>', 'g$')
    register({
      y = { '<Plug>Markdown_OpenUrlUnderCursor', 'follow url' },
    }, {
      prefix = a.move,
      buffer = buffer,
    })
    for mode in string.gmatch('nvo', '.') do
      register({
        -- s = { '<cmd>Telescope heading<cr>', 'headings' },
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
        [dd.up] = { 'k', 'physical line up' },
        [dd.down] = { 'j', 'physical line down' },
      }, {
        prefix = a.jump,
        mode = mode,
        buffer = buffer, -- FIXME: this is still setting bindings as global
        noremap = false,
      })
    end
  end

  map_local('', a.jump .. 's', '<cmd>Telescope heading<cr>')
  map_local('nvo', a.jump .. 'T', '<Plug>Markdown_MoveToPreviousHeader')
  map_local('nvo', a.jump .. 't', '<Plug>Markdown_MoveToNextHeader')
  map_local('nvo', a.jump .. 'h', '<Plug>Markdown_MoveToCurHeader')
  map_local('nvo', a.jump .. 'H', '<Plug>Markdown_MoveToParentHeader')
  map_local('', a.jump .. dd.up, 'k')
  map_local('', a.jump .. dd.down, 'j')
  map_local('', dd.up, 'gk')
  map_local('', dd.down, 'gj')
  -- both are identical
  map_local('ox', 'ad', '<Plug>(textobj-datetime-auto)', { noremap = false })
  map_local('ox', 'id', '<Plug>(textobj-datetime-auto)', { noremap = false })

  if require('pager').full then
    vim.fn.call('textobj#sentence#init', {})
  end
end

local function map_readonly()
  local map = require('utils').buf_map
  if vim.bo.readonly then
    map('', 'x', '<cmd>q<cr>', { nowait = true })
    map('', 'u', '<c-u>', { noremap = false, nowait = true })
    map('', 'd', '<c-d>', { noremap = false, nowait = true })
  end
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
  map_edit()
  map_jump()
  map_move()
  map_editor()
  map_browser()
  map_help()
  map_command_insert()

  local register = require 'which-key-fallback'
  local map = require('utils').map

  -- TODO: remap cmp c-e
  -- fish-emacs compatibility
  map('nvioc', '<c-e>', '<end>')

  map('c', '<c-a>', '<home>')
  map('c', '<c-e>', '<end>')
  map('i', '<c-a>', '<c-o>^')
  map('i', '<c-e>', '<c-o>$')
  map('nvo', '<c-a>', '^')
  map('nvo', '<c-e>', '$')

  map('nvioc', '<c-p>', '<up>')
  map('nvioc', '<c-n>', '<down>')
  map('nvioc', '<c-c>', '<esc>')
  map('n', '<a-t>', '"zdh"zp') -- transpose
  map('i', '<a-t>', '<esc>"zdh"zpa') -- transpose

  -- TODO:map reselect "gv"

  map('nx', '<leader><leader>', ':')

  map('', 'q', '<nop>')
  map('', a.edit, '<nop>')
  map('', a.jump, '<nop>')
  map('', a.move, '<nop>')
  map('', a.mark, '<nop>')
  map('', a.macro, '<nop>')
  map('', a.editor, '<nop>')
  map('', a.help, '<nop>')
  map('', a.browser, '<nop>')
  map('', 'gg', '<nop>')
  map('', "g'", '<nop>')
  map('', 'g`', '<nop>')
  map('', 'g~', '<nop>')
  map('', 'gg', '<nop>')
  map('', 'gg', '<nop>')
  map('', '<c-u>', '<nop>')
  map('', '<c-d>', '<nop>')
  local function remark(new, old)
    map('', a.mark .. new, '`' .. old)
    map('', a.mark .. new, "'" .. old)
  end
  map('nx', 'r', 'r')
  map('nx', 'R', 'R')
  remark('V', '<')
  remark('v', '>')
  remark('P', '[')
  remark('p', ']')

  map('', dd.right, 'l')
  map('', dd.left, 'h')
  map('', dd.up, 'k')
  map('', dd.down, 'j')

  map('', 'b', '*')
  map('', 'B', '#')
  map('', 'w', 'b')
  map('', 'W', 'B')
  map('', 'e', 'e')
  map('', 'E', 'E')
  map('', 'é', '/')
  map('', 'É', 'É')
  map('nvo', 'L', '^')
  map('nvo', ':', '$')

  map('o', ',', ':<c-u>lua require("tsht").nodes()<CR>')
  map('v', ',', ':lua require("tsht").nodes()<cr>')

  -- neoscroll
  require('neoscroll.config').set_mappings {
    J = { 'scroll', { '-vim.wo.scroll', 'true', '250' } },
    K = { 'scroll', { 'vim.wo.scroll', 'true', '250' } },
    zt = { 'zt', { '250' } },
    zz = { 'zz', { '250' } },
    zb = { 'zb', { '250' } },
  }

  map('', 's', '<Plug>Lightspeed_s', { noremap = false })
  map('', 'S', '<Plug>Lightspeed_S', { noremap = false })
  map(
    '',
    'f',
    'reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_f" : "f"',
    { noremap = false, expr = true }
  )
  map(
    '',
    'F',
    'reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_F" : "F"',
    { noremap = false, expr = true }
  )
  map(
    '',
    't',
    'reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_t" : "t"',
    { noremap = false, expr = true }
  )
  map(
    '',
    'T',
    'reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_T" : "T"',
    { noremap = false, expr = true }
  )

  -- searching
  require 'auto_unhl'
  map('', '*', '<nop>')
  map('', '#', '<nop>')
  map('nxo', 'n', "n<cmd>lua require'auto_unhl'.post()<cr>")
  map('nxo', 'N', "N<cmd>lua require'auto_unhl'.post()<cr>")
  map('n', a.jump .. 'q', "g*<cmd>lua require'auto_unhl'.post()<cr>")
  map('n', 'b', "*<cmd>lua require'auto_unhl'.post()<cr>")
  map('n', 'B', "#<cmd>lua require'auto_unhl'.post()<cr>")
  map(
    'x',
    'b',
    "y/\\V<C-R>=escape(@\",'/\\')<CR><CR><cmd>lua require'auto_unhl'.post()<cr>"
  )
  map(
    'x',
    'B',
    "y/\\V<C-R>=escape(@\",'/\\')<CR><CR><cmd>lua require'auto_unhl'.post()<cr>"
  )

  -- luasnip + dial
  -- FIXME:
  -- map('i', '<c-a>', 'pumvisible() ? "a" : "b"', { expr = true })
  -- map('i', '<c-x>', '<down>')

  -- TODO: use dial-* and luasnip-*-choice in insert mode
  -- map('i', '<c-x>', 'pumvisible() ? "\\<down>" : 1', { expr = true })
  map(
    'nx',
    '<c-j>',
    "luasnip#choice_active() ? '<plug>luasnip-next-choice' : '<plug>(dial-increment)'",
    { expr = true, noremap = false }
  )
  map(
    'nx',
    '<c-x>',
    "luasnip#choice_active() ? '<plug>luasnip-previous-choice' : '<plug>(dial-decrement)'",
    { expr = true, noremap = false }
  )
  map(
    'x',
    '<c-s-j>',
    '<Plug>(dial-increment-additional)',
    { expr = true, silent = true, noremap = false }
  )
  map(
    'x',
    '<c-s-x>',
    '<Plug>(dial-decrement-additional)',
    { expr = true, silent = true, noremap = false }
  )

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
  map('', 'V', '<c-v>')
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

  -- nvi mappings
  for mode in string.gmatch('nvi', '.') do
    register({
      [alt(dd.left)] = { '<cmd>wincmd h<cr>', 'window left' },
      [alt(dd.down)] = { '<cmd>wincmd j<cr>', 'window down' },
      [alt(dd.up)] = { '<cmd>wincmd k<cr>', 'window up' },
      [alt(dd.right)] = { '<cmd>wincmd l<cr>', 'window right' },
      ['<a-b>'] = { '<cmd>wincmd p<cr>', 'window back' },
      ['<a-a>'] = { '<cmd>e#<cr>', 'previous buffer' }, -- move
      ['<a-w>'] = { '<cmd>q<cr>', 'close window' },
      ['<c-l>'] = {
        "<cmd>nohlsearch<cr><cmd>lua require('hlslens.main').cmdl_search_leave()<cr>",
        'nohlsearch',
      },
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
  revJ = {
    operator = a.edit .. 'b', -- for operator (+motion)
    line = a.edit .. a.edit .. 'b', -- for formatting current line
    visual = a.edit .. 'b', -- for formatting visual selection
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
