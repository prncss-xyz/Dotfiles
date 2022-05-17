-- 1247 LOC !!
local M = {}

local utils = require 'utils'
local lazy_req = utils.lazy_req

local a = require('bindings.parameters').a
local d = require('bindings.parameters').d
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
    [a.various] = {
      pb = lazy_req('neoscroll', 'zt', 250),
      b = lazy_req('neoscroll', 'zb', 250),
      c = lazy_req('neoscroll', 'zz', 250),
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
        [d.search] = {
          w = plug '(Mac_SearchForNamedMacroAndOverwrite)',
          r = plug '(Mac_SearchForNamedMacroAndRename)',
          d = plug '(Mac_SearchForNamedMacroAndDelete)',
          [a.macro] = plug '(Mac_SearchForNamedMacroAndPlay)',
        },
      },
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
      ['p;'] = { 'g,', 'newer change' },
      [';'] = { 'g;', 'older changer' },
      [d.up] = { 'gk', 'visual up', modes = 'nxo' },
      [d.down] = { 'gj', 'visual down', modes = 'nxo' },
      -- FIXME: built-in previous/next misspelled do not work with spellsitter
      -- replace with search function based on highlight group
      [p(d.spell)] = { '[s', 'prevous misspelled' },
      [d.spell] = { ']s', 'next misspelled' },
      [p(d.search)] = {
        function()
          require('flies.objects.search').search('?', true, false)
        end,
        modes = 'nxo',
      },
      [d.search] = {
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
      [p 'r'] = 'R',
      r = 'r',
      s = { vim.lsp.buf.rename, 'rename' },
      -- s = { vim.lsp.buf.rename, 'rename', modes = 'nx' },
      [p(p 'u')] = {
        rep [["zc<C-R>=casechange#next(@z)<CR><Esc>v`[']],
        'change case',
        modes = 'nx',
      }, -- FIXME: not repeatable
      [p 'u'] = { 'gU', 'uppercase', modes = 'nx' },
      u = { 'gu', 'lowercase', modes = 'nx' },
      -- [p 'v'] = { 'P', modes = 'nx' },
      -- v = { 'p', modes = 'nx' },
      -- specify register 1
      -- v = { 'g~', 'toggle case', modes = 'nx' },
      --
      w = {
        function()
          require('telescope.builtin').symbols {
            sources = { 'math', 'emoji' },
          }
        end,
        'symbols',
        modes = 'n',
      },
      [p '<tab>'] = { '<<', 'dedent', modes = 'nx' },
      ['<tab>'] = { '>>', 'indent', modes = 'nx' },
      -- https://vi.stackexchange.com/questions/3875/how-to-insert-a-newline-without-leaving-normal-mode
      [p '<cr>'] = plug '(unimpaired-blank-up)',
      ['<cr>'] = plug '(unimpaired-blank-down)',
      [d.spell] = {
        function()
          require('telescope.builtin').spell_suggest(
            require('telescope.themes').get_cursor {}
          )
        end,
        'spell suggest',
        modes = 'nx',
      },

      [p(d.comment)] = {
        modes = {
          n = plug '(comment_toggle_blockwise)',
          x = plug '(comment_toggle_blockwise_visual)',
        },
      },
      [d.comment] = {
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
      [d.comment] = {
        [''] = {
          modes = {
            n = plug '(comment_toggle_linewise)',
            x = plug '(comment_toggle_linewise_visual)',
          },
        },
      },
      [d.prev_search] = plug { '(dial-increment-additional)', modes = 'x' },
      [d.next_search] = plug { '(dial-decrement-additional)', modes = 'x' },
      [a.edit] = {
        name = '+line',
        [p(d.comment)] = plug '(comment_toggle_current_blockwise)',
        [d.comment] = plug '(comment_toggle_current_linewise)',
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
    },
    [a.help] = {
      h = cmd {
        'e ~/Dotfiles/bindings-qwerty/.config/nvim/lua/bindings.lua',
        'bindings',
      }, -- FIXME: use `realpath` instead
      m = cmd { 'Telescope man_pages', 'man pages' },
      p = cmd { 'Telescope md_help', 'md help' },
      v = cmd { 'Telescope help_tags', 'help tags' },
    },
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
  -- ordering of the matters for: i) overriding, ii) captures
  map_basic()
end

return M
