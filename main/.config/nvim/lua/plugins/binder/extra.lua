local M = {}

function M.extend()
  local d = require('plugins.binder.parameters').d
  local utils = require 'plugins.binder.utils'
  local alt = utils.alt
  local binder = require 'binder'
  local keys = binder.keys
  local modes = binder.modes
  local b = binder.b
  local search_cword = require('utils.browser').search_cword
  local search_visual = require('utils.browser').search_visual

  local function map_search(base, desc)
    return modes {
      desc = desc,
      n = b {
        function()
          search_cword(base)
        end,
      },
      x = b {
        function()
          search_visual(base)
        end,
      },
    }
  end

  local function devdocs(mode)
    local base = 'https://devdocs.io/#q='
    local ft = vim.bo.filetype
    if ft ~= '' then
      base = base .. ' ' .. ft .. ' '
    end
    if mode == 'n' then
      search_cword(base)
    else
      search_visual(base)
    end
  end

  local lazy_req = require('plugins.binder.utils').lazy_req
  return keys {
    b = keys {
      prev = b { desc = 'scroll top', lazy_req('neoscroll', 'zt', 250) },
      next = b { desc = 'scroll bottom', lazy_req('neoscroll', 'zb', 250) },
      c = b { desc = 'scroll middle', lazy_req('neoscroll', 'zz', 250) },
    },
    c = b {
      desc = 'select adjacent command lines',
      require 'utils.select_comment',
    },
    e = b {
      desc = 'toggle emmet',
      function()
        require('utils.lsp').toggle_client 'emmet_ls'
      end,
    },
    f = b {
      desc = 'longnose',
      require('utils.longnose').main,
    },
    j = keys {
      desc = 'typescript',
      -- Despite the name, this command fixes a handful of specific issues,
      -- most notably non-async functions that use await and unreachable code.
      a = b {
        desc = 'fix all',
        lazy_req('typescript', 'actions.fixAll'),
      },
      o = b {
        desc = 'organize imports',
        lazy_req('typescript', 'actions.organizeImports'),
      },
      s = b {
        desc = 'go to source definition',
        function()
          require('typescript').goToSourceDefinition()
        end,
      },
      -- operates with full paths: .renameFile(source, target)
      v = b {
        desc = 'rename file',
        '<cmd>TypescriptRenameFile<cr>',
      },
      y = b {
        desc = 'add missing imports',
        lazy_req('typescript', 'actions.addMissingImports'),
      },
      x = b {
        desc = 'remove unused',
        lazy_req('typescript', 'actions.removeUnused'),
      },
    },
    o = keys {
      desc = 'overseer',
      redup = b {
        desc = 'run',
        ':OverseerRun<cr>',
      },
      q = b {
        desc = 'toggle',
        ':OverseerToggle<cr>',
      },
      y = b {
        desc = 'browse dev',
        require('utils.browser').browse_dev,
      },
    },
    q = keys {
      desc = 'marco',
      prev = b {
        desc = 'record',
        'q',
      },
      next = b { desc = 'play', '@' }, -- @@ play again
      -- ['.'] = b { desc = 'play last', '@@' },
    },
    r = keys {
      desc = 'sniprun',
      redup = modes {
        desc = 'run',
        n = b {
          function()
            require('sniprun').run()
          end,
        },
        x = b {
          function()
            require('sniprun').run 'v'
          end,
        },
      },
      c = b {
        desc = 'clear repl',
        function()
          require('sniprun').clear_repl()
        end,
      },
      i = b {
        desc = 'info',
        function()
          require('sniprun').info()
        end,
      },
      l = b {
        desc = 'live toggle',
        function()
          require('sniprun.live_mode').toggle()
        end,
      },
      p = b {
        desc = 'close all',
        function()
          require('sniprun.display').close_all()
        end,
      },
      x = b {
        desc = 'reset',
        function()
          require('sniprun').reset()
        end,
      },
    },
    t = keys {
      desc = 'neotest',
      redup = b {
        desc = 'run nearest',
        lazy_req('neotest', 'run.run'),
      },
      f = b {
        desc = 'run file',
        function()
          -- workarount as 'neotest.plenary' do not seem to work currently
          if vim.bo.filetype == 'lua' then
            require('plenary.test_harness').test_directory(vim.fn.expand '%:p')
          else
            require('neotest').run.run { vim.fn.expand '%' }
          end
        end,
      },
      x = b {
        desc = 'stop',
        lazy_req('neotest', 'run.stop'),
      },
      o = b {
        desc = 'output',
        function()
          require('neotest').output.open { enter = true }
        end,
      },
      s = b {
        desc = 'summary',
        function()
          require('neotest').summary.toggle()
        end,
      },
      -- require("neotest").run.run({strategy = "dap"})
      -- require("neotest").run.attach()
    },
    v = b { desc = 'reselect', 'gv' },
    y = keys {
      desc = 'search',
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
      ddg = map_search('https://duckduckgo.com/?q=', 'duckduckgo'),
      dds = modes {
        desc = 'devdocs',
        n = b {
          function()
            devdocs 'n'
          end,
        },
        x = b {
          function()
            devdocs 'x'
          end,
        },
      },
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
      o = b {
        desc = 'open current cfile',
        '<cmd>call jobstart(["xdg-open", expand("<cfile>")]<cr>, {"detach": v:true})<cr>',
      },
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
      u = b {
        desc = 'browse current cfile',
        require('utils.browser').browse_cfile,
      },
      we = map_search('https://en.wikipedia.org/wiki/', 'wikipidia en'),
      wf = map_search('https://fr.wikipedia.org/wiki/', 'wikipidia fr'),
      y = map_search(
        'https://www.youtube.com/results?search_query=',
        'youtube'
      ),
    },
    x = keys {
      desc = 'refactoring',
      a = modes {
        desc = 'debug print',
        n = b {
          function()
            require('refactoring').debug.print_var { normal = true }
          end,
        },
        x = b {
          function()
            require('refactoring').debug.print_var {}
          end,
        },
      },
      h = b {
        desc = 'telescope',
        function()
          require('telescope').extensions.refactoring.refactors()
        end,
      },
      x = b {
        desc = 'debug print',
        function()
          require('refactoring').debug.cleanup {}
        end,
      },
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

return M
