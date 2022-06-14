local M = {}

function M.extend()
  local d = require('plugins.binder.parameters').d
  local util = require 'plugins.binder.util'
  local alt = util.alt
  local binder = require 'binder'
  local keys = binder.keys
  local modes = binder.modes
  local b = binder.b
  local lazy_req = require('plugins.binder.util').lazy_req
  return keys {
    b = keys {
      prev = b { desc = 'scroll top', lazy_req('neoscroll', 'zt', 250) },
      next = b { desc = 'scroll bottom', lazy_req('neoscroll', 'zb', 250) },
      c = b { desc = 'scroll middle', lazy_req('neoscroll', 'zz', 250) },
    },
    q = keys {
      desc = 'marco',
      prev = b { desc = 'record q', 'qq' },
      next = b { desc = 'play q', '@q' }, -- @@ play again
      -- ['.'] = b { desc = 'play last', '@@' },
    },
    -- q = keys {
    --   r = b { '<Plug>(Mac_RecordNew)' },
    --   n = keys {
    --     prev = b { '<Plug>(Mac_RotateForward)' },
    --     next = b { '<Plug>(Mac_RotateBack)' },
    --   },
    --   a = keys {
    --     prev = b { '<Plug>(Mac_Prepend)' },
    --     next = b { '<Plug>(Mac_Append)' },
    --   },
    --   w = b { '<Plug>(Mac_NameCurrentMacro)' },
    --   fw = b { '<Plug>(Mac_NameCurrentMacroForFileType)' },
    --   sw = b { '<Plug>(Mac_NameCurrentMacroForCurrentSession)' },
    --   l = b { '<cmd>DisplayMacroHistory<cr>' },
    --   redup = b { '<plug>(Mac_Play)', noremap = false },
    --   [d.search] = keys {
    --     w = b { '<Plug>(Mac_SearchForNamedMacroAndOverwrite)' },
    --     r = b { '<Plug>(Mac_SearchForNamedMacroAndRename)' },
    --     d = b { '<Plug>(Mac_SearchForNamedMacroAndDelete)' },
    --     q = b { '<Plug>(Mac_SearchForNamedMacroAndPlay)' },
    --   },
    -- },
    v = b { desc = 'reselect', 'gv' },
    y = keys {
      desc = 'search',
    },
    z = keys {
      desc = 'spell',
      b = b { '<cmd>setlocal spell spelllang=en_us,fr,cjk<cr>', 'en fr' },
      e = b { '<cmd>setlocal spell spelllang=en_us,cjk<cr>', 'en' },
      f = b { '<cmd>setlocal spell spelllang=fr,cjk<cr>', 'fr' },
      y = b { '<cmd>zg', 'add to spellfile<cr>' },
      x = b { '<cmd>setlocal nospell<cr>', 'none' },
    },
  }
end

if false then
  local function map_search(_, _) end
  local y = {
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
    pac = map_search('https://archlinux.org/packages/?q=', 'arch packages'),
    sea = map_search('https://www.seriouseats.com/search?q=', 'seriouseats'),
    sep = map_search(
      'https://plato.stanford.edu/search/searcher.py?query=',
      'sep'
    ),
    sp = map_search('https://www.persee.fr/search?ta=article&q=', 'persée'),
    st = map_search('https://usito.usherbrooke.ca/d%C3%A9finitions/', 'usito'),
    u = {
      require('modules.browser').open_file,
      'open current file',
    },
    we = map_search('https://en.wikipedia.org/wiki/', 'wikipidia en'),
    wf = map_search('https://fr.wikipedia.org/wiki/', 'wikipidia fr'),
    y = map_search('https://www.youtube.com/results?search_query=', 'youtube'),
  }
end

return M
