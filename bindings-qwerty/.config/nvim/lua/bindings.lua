local M = {}
local invert = require('utils').invert

-- mapclear

M.plugins = {}

local function s(char)
  return '<s-' .. char .. '>'
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
  q = 'move',
  M = 'mark',
  Q = 'macro',
  L = 'editor',
  H = 'help',
  Y = 'browser',
  K = 'selection',
}
local d0 = {
  h = 'left',
  l = 'right',
  j = 'down',
  k = 'up',
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

function M.setup()
  -- function M.setup(register)
  local register = require 'which-key-fallback'
  local map = require('utils').map

  map('nx', '<leader><leader>', ':')

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
  local function remark(new, old)
    map('', a.mark .. new, '`' .. old)
    map('', a.mark .. new, "'" .. old)
  end
  remark('V', '<')
  remark('v', '>')
  remark('P', '[')
  remark('p', ']')
  map('n', 's', 'm')
  map('n', 'm', "'")
  map('n', a.mark .. 'm', '`') -- not working ?? whichkwey

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

  -- auto-pairs
  -- map('i', '<cr>', 'v:lua.completion_confirm()', { expr = true })

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
  -- map('n', macro .. macro, '<plug>(Mac_Play)', { noremap = false })
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

  -- matze move
  vim.cmd [[
call submode#enter_with('move', 'n', 'r', 'mj', '<Plug>MoveLineDown')
call submode#enter_with('move', 'n', 'r', 'mk', '<Plug>MoveLineUp')
call submode#map('move', 'n', 'r', 'j', '<Plug>MoveLineDown')
call submode#map('move', 'n', 'r', 'k', '<Plug>MoveLineUp')
call submode#leave_with('move', 'n', '', '<Esc>')
]]
  -- map('v', a.edit .. 'j', '<Plug>MoveBlockDown', { noremap = false })
  -- map('v', a.edit .. 'k', '<Plug>MoveBlockUp', { noremap = false })
  map('v', a.edit .. dd.left, '<Plug>MoveBlockLeft', { noremap = false })
  map('v', a.edit .. dd.right, '<Plug>MoveBlockRight', { noremap = false })
  map('n', a.edit .. dd.left, '<Plug>MoveCharLeft', { noremap = false })
  map('n', a.edit .. dd.right, '<Plug>MoveCharRight', { noremap = false })

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
    a.edit .. 'r',
    '<Plug>(operator-sandwich-replace)',
    { noremap = false }
  )
  map(
    '',
    a.edit .. 'Y',
    '<Plug>(operator-sandwich-delete)',
    { noremap = false }
  )
  map('ox', 'ir', '<Plug>(textobj-sandwich-auto-i)', { noremap = false })
  map('ox', 'ar', '<Plug>(textobj-sandwich-auto-a)', { noremap = false })
  map('ox', 'iy', '<Plug>(textobj-sandwich-query-i)', { noremap = false })
  map('ox', 'ay', '<Plug>(textobj-sandwich-query-a)', { noremap = false })

  -- ninja feet
  map('o', a.edit .. 'Ni', '<Plug>(ninja-left-foot-inner)', { noremap = false })
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
  map('v', 'mU', [["zc<C-R>=casechange#next(@z)<CR><Esc>v`[']])

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

  -- VSSPlit
  -- maybe not K... if visual only
  map('x', 'Kr', '<Plug>(Visual-Split-VSResize)', { noremap = false })
  map('x', 'KS', '<Plug>(Visual-Split-VSSplit)', { noremap = false })
  map('x', 'Kk', '<Plug>(Visual-Split-VSSplitAbove)', { noremap = false })
  map('x', 'Kj', '<Plug>(Visual-Split-VSSplitBelow)', { noremap = false })
  --
  -- eft
  -- map('nx', ';', '<plug>(eft-repeat)', { noremap = false })
  -- map('nxo', 'f', '<plug>(eft-f)', { noremap = false })
  -- map('nxo', '<s-f>', '<plug>(eft-F)', { noremap = false })
  -- map('nxo', 't', '<plug>(eft-t)', { noremap = false })
  -- map('nxo', '<s-t>', '<plug>(eft-T)', { noremap = false })

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

  -- luasnip + dial
  -- FIXME
  map(
    'nv',
    '<c-a>',
    "luasnip#choice_active() ? '<plug>luasnip-next-choice' : '<plug>(dial-increment)'",
    { expr = true, noremap = false }
  )
  map(
    'nv',
    '<c-x>',
    "luasnip#choice_active() ? '<plug>luasnip-previous-choice' : '<plug>(dial-decrement)'",
    { expr = true, noremap = false }
  )
  map(
    'v',
    'm<c-a>',
    '<Plug>(dial-increment-additional)',
    { expr = true, silent = true, noremap = false }
  )
  map(
    'v',
    'm<c-x>',
    '<Plug>(dial-decrement-additional)',
    { expr = true, silent = true, noremap = false }
  )

  map(
    'i',
    '<cr>',
    'v:lua.MPairs.autopairs_cr()',
    { expr = true, noremap = true }
  )

  map('is', '<tab>', '<cmd>lua require"bindutils".tab_complete()<cr>')
  map('is', '<s-tab>', '<cmd>lua require"bindutils".s_tab_complete()<cr>')
  map('is', '<c-space>', '<cmd>lua require"bindutils".toggle_cmp()<cr>')

  -- wildmenu
  -- needed for tab-completion
  map(
    'c',
    '<c-n>',
    'wilder#in_context() ? wilder#next() : "\\<down>"',
    { expr = true }
  )
  map(
    'c',
    '<c-p>',
    'wilder#in_context() ? wilder#previous() : "\\<up>"',
    { expr = true }
  )
  -- cannot make "autoselect" work
  map(
    'c',
    '<tab>',
    'wilder#can_accept_completion() ? wilder#accept_completion() : wilder#next()+"\\<cr>"',
    { expr = true }
  )
  -- map('c', '<tab>', 'wilder#accept_completion(1)', {expr = true})
  map('c', '<c-a>', '<up>')
  map('c', '<c-x>', '<down>')
  -- map('c', '<tab>', '<tab><space>')
  -- map('c', '<tab>', 'wilder#accept_completion(1)', { noremap=false,expr = true })
  --
  map('ci', '<c-e>', '<c-right>')
  map('ci', '<c-b>', '<c-left>')

  -- searching
  require 'auto_unhl'
  map('', '*', '<nop>')
  map('', '#', '<nop>')
  map('', 'n', "n<cmd>lua require'auto_unhl'.post()<cr>")
  map('', 'N', "N<cmd>lua require'auto_unhl'.post()<cr>")
  map('n', a.jump .. 'q', "*N<cmd>lua require'auto_unhl'.post()<cr>")
  map('n', a.jump .. 'Q', "g*N<cmd>lua require'auto_unhl'.post()<cr>")
  map(
    'x',
    a.jump .. 'q',
    "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>N<cmd>lua require'auto_unhl'.post()<cr>"
  )

  -- matchup
  map('', a.jump .. 'c', '%', { noremap = false })
  map('', a.jump .. 'C', 'g%', { noremap = false })
  map('', a.jump .. 'y', '[%', { noremap = false })
  map('', a.jump .. 'Y', ']%', { noremap = false })
  map('', a.jump .. 'i', 'z%', { noremap = false })
  map('o', 'ic', 'i%', { noremap = false })
  map('o', 'ac', 'a%', { noremap = false })

  -- nvi mappings
  for mode in string.gmatch('nvi', '.') do
    register({
      -- ['<a-p>'] = { '<cmd>BufferPrevious<cr>', 'focus previous buffer' },
      -- ['<a-n>'] = { '<cmd>BufferNext<cr>', 'focus next buffer' },
      -- ['<a-h>'] = { "<cmd>lua require('Navigator').left()<cr>", 'window left' },
      -- ['<a-j>'] = { "<cmd>lua require('Navigator').down()<cr>", 'window down' },
      -- ['<a-k>'] = { "<cmd>lua require('Navigator').up()<cr>", 'window up' },
      -- ['<a-l>'] = { "<cmd>lua require('Navigator').right()<cr>", 'window right' },
      ['<a-t>'] = { '<cmd><cr>', 'edit alt' },
      ['<a-h>'] = { '<cmd>wincmd h<cr>', 'window left' },
      ['<a-j>'] = { '<cmd>wincmd j<cr>', 'window down' },
      ['<a-k>'] = { '<cmd>wincmd k<cr>', 'window up' },
      ['<a-l>'] = { '<cmd>wincmd l<cr>', 'window right' },
      ['<a-b>'] = { '<cmd>wincmd p<cr>', 'window back' },
      ['<a-a>'] = { '<cmd>e#<cr>', 'previous buffer' },
      ['<a-p>'] = { '<cmd>BufferPick<cr>', 'previous pick' },
      ['<a-P>'] = { '<cmd>BufferPin<cr>', 'previous pin' },

      ['<a-x>'] = { '<cmd>BufferClose!<cr>', 'close buffer' },
      ['<a-X>'] = { '<cmd>tabnew#<cr>', 'close buffer' },
      ['<a-o>'] = {
        '<cmd>BufferCloseBuffersRight<cr><cmd>BufferCloseBuffersLeft<cr><c-w>o',
        'buffer only',
      },
      ['<a-w>'] = { '<cmd>q<cr>', 'close window' },

      ['<a-z>'] = { '<cmd>ZenMode<cr>', 'zen mode' },
      ['<a-s-n>'] = { '<cmd>BufferMoveNext<cr>', 'move buffer next' },
      ['<a-s-p>'] = { '<cmd>BufferMovePrevious<cr>', 'move buffer previous' },

      ['<c-l>'] = {
        "<cmd>nohlsearch<cr><cmd>lua require('hlslens.main').cmdl_search_leave()<cr>",
        'nohlsearch',
      },
      -- ['<c-n>'] = {
      --   '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>',
      --   'next occurence',
      -- },
      -- ['<c-p>'] = {
      --   '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>',
      --   'previous occurence',
      -- },
      ['<c-a-o>'] = { '<cmd>b#<cr>', 'only' }, -- FIXME
      ['<c-q>'] = { '<cmd>qall!<cr>', 'quit' },
      ['<c-s>'] = { '<cmd>w!<cr>', 'save' },
      -- ['<c-w>'] = {
      --   L = { '<cmd>vsplit<cr>', 'split left' },
      --   J = { '<cmd>split<cr>', 'split down' },
      -- },
    }, {
      mode = mode,
    })
    for i = 1, 9 do
      register({
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
  --   register({}, {mode = mode})
  -- end

  -- nvo mappings
  for mode in string.gmatch('nvo', '.') do
    register({
      -- G = { 'gg', 'first line'},
      -- local movements
      [a.jump] = {
        name = '+local movements',
        e = { 'G', 'last line' },
        E = { 'gg', 'first line' },
        L = { "<cmd>lua require('telescope.builtin').loclist()<cr>", 'loclist' },
        s = {
          "<cmd>lua require('telescope.builtin').treesitter()<cr>",
          'symbol or heading',
        }, --
        ['é'] = {
          "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>",
          'current buffer fuzzy find',
        },
      },
    }, {
      mode = mode,
    })
  end

  -- nx mappings
  for mode in string.gmatch('nx', '.') do
    register({
      ['é'] = { '/', 'search' },
      ['É'] = { '?', 'backward' },
      [a.selection] = {
        name = '+visual selection',
        s = { '<c-v>', 'square selection' },
        [a.selection] = { 'gv', 'reselect' },
      },
      [a.edit] = {
        name = '+edit',
        -- J = { 'gJ', 'join' },
        a = {
          "<cmd>lua require('telescope.builtin').lsp_code_actions(require('telescope.themes').get_cursor{})<cr>",
          'code actions',
        },
        A = {
          "<cmd>lua require('telescope.builtin').lsp_range_code_actions(require('telescope.themes').get_cursor{})<cr>",
          'range code actions',
        },
        s = { '<cmd>lua vim.lsp.buf.rename()<cr>', 'rename' },
        t = { '>>', 'indent' },
        T = { '<<', 'dedent' },
        u = { 'gu', 'lowercase' },
        U = { 'gU', 'uppercase' },
        v = { 'g~', 'toggle case' },
        w = {
          "<cmd>lua require'telescope.builtin'.symbols{ sources = {'math', 'emoji'} }<cr>",
          'symbols',
        },
        z = {
          "<cmd>lua require('telescope.builtin').spell_suggest(require('telescope.themes').get_cursor{})<cr>",
          'spell suggest',
        },
      },
    }, {
      mode = mode,
    })
  end

  -- n mappings
  register {
    [a.editor] = {
      name = '+editor state',
      a = {
        '<cmd>TroubleToggle lsp_workspace_diagnostics<cr>',
        'lsp diagnostics',
      },
      A = {
        '<cmd>TroubleToggle lsp_document_diagnostics<cr>',
        'lsp document diagnostics',
      },
      b = { '<cmd>lua require("persistence").load()<cr>', 'restore seesion' },
      B = {
        '<cmd>lua require("persistence").load({last=true})<cr>',
        'restore last seesion',
      },
      d = { '<cmd>DiffviewOpen<cr>', 'diffview open' },
      D = { '<cmd>DiffviewClose<cr>', 'diffview close' },
      e = { '<cmd>lua require"bindutils".edit_current()<cr>', 'edit current' },
      f = { '<cmd>NvimTreeFindFile<cr>', 'file tree' },
      F = { '<cmd>NvimTreeClose<cr>', 'file tree' },
      g = { '<cmd>Neogit<cr>', 'neogit' },
      h = { '<cmd>DiffviewFileHistory .<cr>', 'diffview open' },
      H = { '<cmd>DiffviewClose<cr>', 'diffview close' },
      -- n = {
      --   "<cmd>lua require'nononotes'.prompt('edit', false, 'all')<cr>",
      --   'pick note',
      -- },
      n = { "<cmd>lua require'nononotes'.new_note()<cr>", 'new note' },
      p = { "<cmd>lua require'setup-session'.develop()<cr>", 'session develop' },
      P = {
        "<cmd>lua require'persistence'.load()<cr><cmd>silent! BufferGoto %i<cr>",
      },
      q = { '<cmd>TroubleToggle quickfix<cr>', 'quickfix' },
      r = { '<cmd>update<cr><cmd>luafile %<cr>', 'reload' },
      s = {
        '<cmd>SymbolsOutline<cr>',
        'symbols',
      },
      S = { '<cmd>TroubleToggle lsp_references<cr>', 'lsp reference' },
      t = { '<cmd>lua require"bindutils".term()<cr>', 'new terminal' },
      u = { '<cmd>UndotreeToggle<cr>', 'undo tree' },
      w = { '<cmd>Telescope projects<cr>', 'sessions' },
      W = { "<cmd>lua require'telescope'.extensions.repo.list()<cr>", 'projects' },
      x = { "<cmd>lua require'bindutils'.term_launch({'xplr'})<cr>", 'xplr' },
      z = { '<cmd>ZenMode<cr>', 'zen mode' },
      [';'] = {
        "<cmd>lua require('telescope.builtin').commands()<cr>",
        'commands',
      },
    },
    [a.browser] = {
      b = {
        "<cmd>lua require('telescope').extensions.bookmarks.bookmarks()<cr>",
        'bookmarks',
      },
      man = { '<cmd>lua require"browser".man()<cr>', 'man page' },
      o = {
        '<cmd>call jobstart(["opener", expand("<cfile>")]<cr>, {"detach": v:true})<cr>',
        'open current file',
      },
      p = { "<cmd>lua require'setup-session'.launch()<cr>", 'session lauch' },
      u = {
        '<cmd>lua require"browser".openCfile()<cr>',
        'open current file',
      },
    },
    [a.jump] = {
      name = '+jump',
      a = { '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', 'go next diagnostic' },
      A = {
        '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>',
        'go previous diagnostic',
      },
      d = { ']c', 'next change' },
      D = { '[c', 'previous change' },
      o = { '`.', 'last change' },
      O = { '``', 'before last jump' },
      r = { 'g,', 'newer change' },
      R = { 'g;', 'older change' },
      -- z = { '<cmd>lua require"bindutils".spell_next()<cr>', 'next misspelled' },
      -- Z = { '<cmd>lua require"bindutils".spell_next(-1)<cr>', 'prevous misspelled' },
      z = { ']s', 'next misspelled' },
      Z = { '[s', 'prevous misspelled' },
    },
    [a.move] = {
      name = '+global movements',
      b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", 'buffers' },
      d = { -- FIXME
        '<cmd>lua require("telescope.builtin").lsp_definitions()<cr>',
        'go definition',
      },
      D = { '<cmd>lua vim.lsp.buf.declaration()<cr>', 'go declaration' },
      i = { -- FIXME
        '<cmd>lua require("telescope.").builtin.lsp_implementations()<cr>',
        'go implementation',
      },
      -- n = { '<cmd>Telescope node_modules list<cr>', 'node modules' },
      o = { "<cmd>lua require('telescope.builtin').oldfiles()<cr>", 'oldfiles' },
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
      ['é'] = {
        "<cmd>lua require('telescope.builtin').live_grep()<cr>",
        'live grep',
      },
      ['.'] = { -- FIXME
        "<cmd>lua require('telescope.builtin').find_files({find_command={'ls-dots'}, })<cr>",
        'dofiles',
      },
      -- TODO filter current project
      [a.move] = {
        '<cmd>lua require"bindutils".open_file()<cr>',
        'project file',
      },
    },
    H = {
      name = '+help',
      m = {
        "<cmd>lua require('telescope.builtin').man_pages()<cr>",
        'man pages',
      },
      p = { '<cmd>Mdhelp<cr>', 'md help' },
      v = {
        "<cmd>lua require('telescope.builtin').help_tags()<cr>",
        'help tags',
      },
    },
    ['<leader>'] = {
      s = {
        name = '+LSP',
        a = {
          '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>',
          'show line diagnostics',
        },
        c = { '<cmd>ProDoc<cr>', 'prepare doc comment' },
        d = { '<cmd>lua PeekDefinition()<cr>', 'hover definition' },
        k = { '<cmd>lua vim.lsp.buf.hover()<cr>', 'hover' },
        r = { '<cmd>lua vim.lsp.buf.references()<cr>', 'references' },
        s = { '<cmd>lua vim.lsp.buf.signature_help()<cr>', 'signature help' },
        t = {
          '<cmd>lua vim.lsp.buf.type_definition()<cr>',
          'hover type definition',
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
  require('browser').mapBrowserSearch(register, a.browser, '+browser search', {
    arch = { 'https://wiki.archlinux.org/index.php?search=', 'archlinux wiki' },
    aur = { 'https://aur.archlinux.org/packages/?K=', 'aur packages' },
    ca = { 'https://www.cairn.info/resultats_recherche.php?searchTerm=', 'cairn' },
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

local SignatureMap = invert {
  [a.jump .. 'b'] = 'GotoNextSpotByPos',
  [a.jump .. a.jump .. 'b'] = 'GotoNextLineByPos',
  [a.jump .. 'B'] = 'GotoPrevSpotByPos',
  [a.jump .. a.jump .. 'B'] = 'GotoPrevLineByPos',
  [a.mark .. 'da'] = 'PurgeMarksAtLine',
  [a.mark .. 'dA'] = 'PurgeMarks',
  [a.jump .. 'e'] = 'GotoNextMarkerAny',
  [a.jump .. 'E'] = 'GotoPrevMarkerAny',
  [a.mark .. 'ha'] = 'ListBufferMarkers',
  [a.jump .. 'm'] = 'GotoNextSpotAlpha',
  [a.jump .. a.jump .. 'm'] = 'GotoNextLineAlpha',
  [a.jump .. 'M'] = 'GotoPrevSpotAlpha',
  [a.jump .. a.jump .. 'M'] = 'GotoPrevLineAlpha',
  [a.mark .. 'sa'] = 'PurgeMarkers',
  [a.mark .. 't'] = 'ToggleMarkAtLine',
  [a.jump .. 'x'] = 'GotoNextMarker',
  [a.jump .. 'X'] = 'GotoPrevMarker',
  [a.mark .. 'xa'] = 'DeleteMark',
  [a.mark .. 'y'] = 'PlaceNextMark',
}
SignatureMap.Leader = 'M'

local signature = { g = { SignatureMap = SignatureMap } }

M.plugins = {
  vim = {
    -- options related to mapping
    g = {
      mapleader = ' ',
      user_emmet_leader_key = '<C-y>',
    },
  },
  revJ = {
    operator = a.edit .. 'j', -- for operator (+motion)
    line = a.edit .. a.edit .. 'j', -- for formatting current line
    visual = a.edit .. 'j', -- for formatting visual selection
  },
  textobj = {
    g = {
      ['textobj#sentence#select'] = 's',
      ['textobj#sentence#move_p'] = 'S',
      ['textobj#sentence#move_n'] = 's',
      -- vim_textobj_parameter_mapping = ','
    },
  },
  signature = signature,
  nononotes = invert {
    -- ['<cr>'] = 'enter_link',
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
          -- ['ia'] = '@parameter.inner',
          -- ['aq'] = {
          --   lua = '@string.outer',
          -- },
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
    -- textsubjects = {
    --   keymaps = {
    --     ['.'] = 'textsubjects-smart',
    --     [','] = 'textsubjects-big',
    --   },
    -- },
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
    -- still use ijkl, gG, G
    a = 'create',
    d = 'remove',
    h = 'parent_node',
    H = 'dir_up',
    J = 'last_sibling',
    K = 'first_sibling',
    l = 'edit',
    ll = 'copy_name',
    lp = 'copy_path',
    lP = 'copy_absolute_path',
    o = 'system_open',
    p = 'paste',
    q = 'close',
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
    ['.'] = 'toggle_ignored',
    ['?'] = 'toggle_help',
    ['<bs>'] = 'close_node',
    ['<tab>'] = 'preview',
    ['<s-c>'] = 'close_node',
    ['<c-r>'] = 'full_rename',
    ['<c-t>'] = 'tabnew',
    ['<c-x>'] = 'split',
  },
}

return M
