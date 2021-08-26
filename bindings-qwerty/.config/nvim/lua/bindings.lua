local M = {}
local invert = require('utils').invert

-- local register0
-- local desc = ''
-- register0 = function (t, mode, prefix)
--   for key,value in pairs(t) do
--     if key == 'name' then
--       desc = desc .. prefix .. key .. ' -> +' .. value .. '\n'
--     else
--       if value[1] then
--       print(prefix..key,value[1], mode)
--       require'utils'.map(mode, prefix..key,value[1])
--       desc = desc .. prefix .. key .. ' -> ' .. value[2] .. '\n'
--       else
--         register0(value, mode, prefix..key)
--       end
--     end
--   end
-- end
-- local register = function (t, opts)
--   opts = opts or {}
--   register0(t, opts.mode or '', opts.prefix or '')
-- end
-- local wk = { register = register }

M.plugins = {}

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local edit = 'm'
local jump = 'g'
-- local mark = 'z'
local move = 'q'
local mark = 'M'
local macro = 'Q'
local editor = 'L'
local help = 'H'
local browser = 'Y'

local remap = vim.api.nvim_set_keymap
local npairs = require 'nvim-autopairs'

_G.completion_confirm = function()
  if vim.fn.pumvisible() ~= 0 then
    return npairs.esc '<cr>'
  else
    return npairs.autopairs_cr()
  end
end

function _G.edit_rel()
  return (':e ' .. vim.fn.expand '%:h' .. '/')
end

-- https://github.com/folke/dot/blob/master/config/nvim/lua/config/compe.lua
function _G.confirm()
  if vim.fn.pumvisible() == 1 then
    return vim.fn['compe#confirm'] { keys = '<cr>', select = true }
  else
    return require('nvim-autopairs').autopairs_cr()
  end
end

function _G.tab_complete()
  if vim.fn.pumvisible() == 1 then
    return (vim.fn['compe#confirm'] { keys = '<cr>', select = true })
  end
  return require('luasnip').jump(1) and '' or t '<Plug>(TaboutMulti)'
  -- emmet#moveNextPrev(0)
end

--- <s-tab> to jump to next snippet's placeholder
function _G.s_tab_complete()
  return require('luasnip').jump(-1) and '' or t '<Plug>(TaboutBackMulti)'
  -- emmet#moveNextPrev(1)
end

local function mapBrowserSearch(prefix, help0, mappings)
  local wk = require 'which-key'
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

local function up(str)
  return string.upper(str)
end

function M.setup()
  local map = require('utils').map
  local wk = require 'which-key'

  map('nx', '<leader><leader>', ':')

  map('', edit, '<nop>')
  map('', jump, '<nop>')
  map('', move, '<nop>')
  map('', mark, '<nop>')
  map('', macro, '<nop>')
  map('', editor, '<nop>')
  map('', help, '<nop>')
  map('', browser, '<nop>')
  map('', 'gg', '<nop>')
  map('', "g'", '<nop>')
  map('', 'g`', '<nop>')
  map('', 'g~', '<nop>')
  map('', 'gg', '<nop>')
  map('', 'gg', '<nop>')
  map('n', '<c-h>', 'v:lua.edit_rel()', { expr = true })
  local function remark(new, old)
    map('', mark .. new, '`' .. old)
    map('', mark .. new, "'" .. old)
  end
  remark('V', '<')
  remark('v', '>')
  remark('P', '[')
  remark('p', ']')
  map('n', 's', 'm')
  map('n', 'm', "'")
  map('n', mark .. 'm', '`') -- not working ?? whichkwey

  -- auto-pairs
  -- weirdly workds after a few times
  map('i', '<cr>', 'v:lua.completion_confirm()', { expr = true })

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
  map('v', edit .. 'j', '<Plug>MoveBlockDown', { noremap = false })
  map('v', edit .. 'k', '<Plug>MoveBlockUp', { noremap = false })
  map('v', edit .. 'h', '<Plug>MoveBlockLeft', { noremap = false })
  map('v', edit .. 'l', '<Plug>MoveBlockRight', { noremap = false })
  map('n', edit .. 'l', '<Plug>MoveCharRight', { noremap = false })
  map('n', edit .. 'h', '<Plug>MoveCharLeft', { noremap = false })

  -- exchange (repeat)
  map('nx', edit .. 'x', '<Plug>(Exchange)', { noremap = false })
  map('nx', edit .. edit .. 'x', '<Plug>(ExchangeLine)', { noremap = false })
  map('nx', edit .. 'xc', '<Plug>(ExchangeClear)', { noremap = false })

  -- sandwich
  map('', edit .. 'y', '<Plug>(operator-sandwich-add)', { noremap = false })
  map('', edit .. 'r', '<Plug>(operator-sandwich-replace)', { noremap = false })
  map('', edit .. 'Y', '<Plug>(operator-sandwich-delete)', { noremap = false })
  map('ox', 'ir', '<Plug>(textobj-sandwich-auto-i)', { noremap = false })
  map('ox', 'ar', '<Plug>(textobj-sandwich-auto-a)', { noremap = false })
  map('ox', 'iy', '<Plug>(textobj-sandwich-query-i)', { noremap = false })
  map('ox', 'ay', '<Plug>(textobj-sandwich-query-a)', { noremap = false })

  -- ninja feet
  map('o', edit .. 'ni', '<Plug>(ninja-left-foot-inner)', { noremap = false })
  map('o', edit .. 'na', '<Plug>(ninja-left-foot-a)', { noremap = false })
  map('o', edit .. 'Ni', '<Plug>(ninja-right-foot-inner)', { noremap = false })
  map('o', edit .. 'Na', '<Plug>(ninja-right-foot-a)', { noremap = false })
  map('n', jump .. 'n', '<Plug>(ninja-insert)', { noremap = false })
  map('n', jump .. 'N', '<Plug>(ninja-append)', { noremap = false })

  -- kommentary
  map(
    'n',
    edit .. edit .. 'c',
    '<Plug>kommentary_line_default',
    { noremap = false }
  )
  map('n', edit .. 'c', '<Plug>kommentary_motion_default', { noremap = false })
  map(
    'x',
    edit .. 'c',
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

  -- compe
  map(
    'i',
    '<c-space>',
    "pumvisible() ? compe#close('<c-e>') : compe#complete()",
    { expr = true, silent = true }
  )
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

  map('c', '<c-a>', '<up>')
  map('c', '<c-x>', '<down>')
  -- map('c', '<tab>', '<tab><space>')
  -- map('c', '<tab>', 'wilder#accept_completion(1)', { noremap=false,expr = true })
  map(
    'is',
    '<tab>',
    'v:lua.tab_complete()',
    -- "pumvisible() ? compe#confirm({ 'keys': '<tab>', 'select': v:true }) : v:lua.tab_complete()",
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
    jump .. 'q',
    '<plug>(asterisk-z*)<cmd>lua require"hlslens".start()<cr>',
    { noremap = false }
  )
  map(
    '',
    jump .. 'Q',
    '<plug>(asterisk-gz*)<cmd>lua require"hlslens".start()<cr>',
    { noremap = false }
  )

  map('', jump .. 'c', '%', { noremap = false })
  map('', jump .. 'C', 'g%', { noremap = false })
  map('', jump .. 'y', '[%', { noremap = false })
  map('', jump .. 'Y', ']%', { noremap = false })
  map('', jump .. 'i', 'z%', { noremap = false })
  map('o', 'ic', 'i%', { noremap = false })
  map('o', 'ac', 'a%', { noremap = false })

  -- nvi mappings
  for mode in string.gmatch('nvi', '.') do
    wk.register({
      -- ['<a-p>'] = { '<cmd>BufferPrevious<cr>', 'focus previous buffer' },
      -- ['<a-n>'] = { '<cmd>BufferNext<cr>', 'focus next buffer' },
      ['<a-h>'] = { "<cmd>lua require('Navigator').left()<cr>", 'window left' },
      ['<a-j>'] = { "<cmd>lua require('Navigator').down()<cr>", 'window down' },
      ['<a-k>'] = { "<cmd>lua require('Navigator').up()<cr>", 'window up' },
      ['<a-l>'] = { "<cmd>lua require('Navigator').right()<cr>", 'window right' },
      ['<a-b>'] = {
        "<cmd>lua require('Navigator').previous()<cr>",
        'window back',
      },
      ['<a-a>'] = { '<cmd>e#<cr>', 'previous buffer'},
      ['<a-p>'] = { '<cmd>BufferPick<cr>', 'previous pick'},
      ['<a-P>'] = { '<cmd>BufferPin<cr>', 'previous pin'},

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
      ['<c-n>'] = {
        '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>',
        'next occurence',
      },
      ['<c-p>'] = {
        '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>',
        'previous occurence',
      },
      ['<c-q>'] = { '<cmd>qa!<cr>', 'quit' },
      ['<c-a-o>'] = { '<cmd>b#<cr>', 'only' }, -- FIXME
      ['<c-s>'] = { '<cmd>w!<cr>', 'save' },
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
      [jump] = {
        name = '+local movements',
        ['é'] = {
          "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>",
          'current buffer fuzzy find',
        },
        s = {
          "<cmd>lua require('telescope.builtin').treesitter()<cr>",
          'symbol or heading',
        }, --
        L = { "<cmd>lua require('telescope.builtin').loclist()<cr>", 'loclist' },
        G = { 'gg', 'first line' },
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
      [edit] = {
        name = '+edit',
        -- J = { 'gJ', 'join' },
        s = { '<cmd>lua vim.lsp.buf.rename()<cr>', 'rename' },
        z = {
          "<cmd>lua require('telescope.builtin').spell_suggest(require('telescope.themes').get_cursor{})<cr>",
          'spell suggest',
        },
        u = { 'gu', 'lowercase' },
        U = { 'gU', 'uppercase' },
        v = { 'g~', 'toggle case' },
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
        w = {
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
    [editor] = {
      name = '+editor state',
      n = {
        "<cmd>lua require'nononotes'.prompt('edit', false, 'all')<cr>",
        'pick note',
      },
      N = { "<cmd>lua require'nononotes'.new_note()<cr>", 'new note' },
      a = {
        '<cmd>TroubleToggle lsp_workspace_diagnostics<cr>',
        'lsp diagnostics',
      },
      A = {
        '<cmd>TroubleToggle lsp_document_diagnostics<cr>',
        'lsp document diagnostics',
      },
      t = { '<cmd>Term<cr>', 'new terminal' },
      q = { '<cmd>TroubleToggle quickfix<cr>', 'quickfix' },
      L = { '<cmd>TroubleToggle loclist<cr>', 'loclist' },
      S = { '<cmd>TroubleToggle lsp_references<cr>', 'lsp reference' },
      u = { '<cmd>UndotreeToggle<cr>', 'undo tree' },
      f = { '<cmd>NvimTreeFindFile<cr>', 'file tree' },
      F = { '<cmd>NvimTreeClose<cr>', 'file tree' },
      d = { '<cmd>DiffviewOpen<cr>', 'diffview open' },
      D = { '<cmd>DiffviewClose<cr>', 'diffview close' },
      s = {
        '<cmd>SymbolsOutline<cr>',
        'symbols',
      },
      z = { '<cmd>ZenMode<cr>', 'zen mode' },
    },
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
    [jump] = {
      a = { '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', 'go next diagnostic' },
      A = {
        '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>',
        'go previous diagnostic',
      },
      z = { ']s', 'next misspelled' },
      Z = { '[s', 'next misspelled' },
      d = { ']c', 'jump to next change' },
      D = { '[c', 'jump to previous change' },
      r = { 'g,', 'jump to newer change' },
      R = { 'g;', 'jump to older change' },
      o = { '`.', 'jump to last change' },
      O = { '``', 'jump to before last jump' },
    },
    [move] = {
      name = '+global movements',
      -- n = { '<cmd>Telescope node_modules list<cr>', 'node modules' },
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
      --w = { '<cmd>Rg <cword><cr>', 'rg current word' },
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
      i = { '<cmd>SearchSession<cr>', 'sessions' },
      [';'] = {
        "<cmd>lua require('telescope.builtin').commands()<cr>",
        'commands',
      },
      n = {
        name = '+notes',
        n = {
          "<cmd>lua require'nononotes'.prompt('edit', false, 'all')<cr>",
          'pick note',
        },
        i = {
          "<cmd>lua require'nononotes'.prompt('insert', false, 'all')<cr>",
          'insert note id',
        },
        N = { "<cmd>lua require'nononotes'.new_note()<cr>", 'new note' },
        s = { "<cmd>lua require'nononotes'.prompt_step()<cr>", 'pick step id' },
        S = { "<cmd>lua require'nononotes'.new_step()<cr>", 'new step' },
        t = { "<cmd>lua require'nononotes'.prompt_thread()<cr>", 'prick step id' },
      },
      s = {
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
      z = {
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

local SignatureMap = invert {
  [mark .. 'y'] = 'PlaceNextMark',
  [mark .. 't'] = 'ToggleMarkAtLine',
  [mark .. 'da'] = 'PurgeMarksAtLine',
  [mark .. 'xa'] = 'DeleteMark',
  [mark .. 'dA'] = 'PurgeMarks',
  [mark .. 'sa'] = 'PurgeMarkers',
  [mark .. 'ha'] = 'ListBufferMarkers',
  [jump .. jump .. 'm'] = 'GotoNextLineAlpha',
  [jump .. jump .. 'M'] = 'GotoPrevLineAlpha',
  [jump .. 'm'] = 'GotoNextSpotAlpha',
  [jump .. 'M'] = 'GotoPrevSpotAlpha',
  [jump .. jump .. 'b'] = 'GotoNextLineByPos',
  [jump .. jump .. 'B'] = 'GotoPrevLineByPos',
  [jump .. 'b'] = 'GotoNextSpotByPos',
  [jump .. 'B'] = 'GotoPrevSpotByPos',
  [jump .. 'x'] = 'GotoNextMarker',
  [jump .. 'X'] = 'GotoPrevMarker',
  [jump .. 'e'] = 'GotoNextMarkerAny',
  [jump .. 'E'] = 'GotoPrevMarkerAny',
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
    operator = edit .. 'j', -- for operator (+motion)
    line = edit .. edit .. 'j', -- for formatting current line
    visual = edit .. 'j', -- for formatting visual selection
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
      ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<cr>',
      ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<cr>',
      ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<cr>',
      ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<cr>',
      ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line()<cr>',
    },
  },
  nvim_tree = {
    ['<cr>'] = 'edit',
    ['<C-x>'] = 'split',
    ['<C-t>'] = 'tabnew',
    ['<'] = 'prev_sibling',
    ['>'] = 'next_sibling',
    h = 'parent_node',
    ['<BS>'] = 'close_node',
    ['<S-CR>'] = 'close_node',
    ['<Tab>'] = 'preview',
    K = 'first_sibling',
    J = 'last_sibling',
    I = 'toggle_ignored',
    ['.'] = 'toggle_dotfiles',
    R = 'refresh',
    a = 'create',
    d = 'remove',
    r = 'rename',
    ['<C-r>'] = 'full_rename',
    x = 'cut',
    c = 'copy',
    p = 'paste',
    y = 'copy_name',
    Y = 'copy_path',
    gy = 'copy_absolute_path',
    ['[c'] = 'prev_git_item',
    [']c'] = 'next_git_item',
    ['-'] = 'dir_up',
    s = 'system_open',
    q = 'close',
    ['g?'] = 'toggle_help',
  },
}

return M
