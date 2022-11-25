local M = {}

function M.extend()
  -- local d = require('plugins.binder.parameters').d
  local utils = require 'plugins.binder.utils'
  local repeatable = utils.repeatable
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
    a = keys {
      desc = 'dap',
      b = keys {
        prev = b {
          desc = 'clear breakpoints',
          lazy_req('dap', 'clear_breakpoints'),
        },
        next = b {
          desc = 'toggle breakpoints',
          lazy_req('dap', 'toggle_breakpoint'),
        },
      },
      c = repeatable { desc = 'continue', lazy_req('dap', 'continue') },
      i = repeatable { desc = 'step into', lazy_req('dap', 'step_into') },
      o = keys {
        prev = repeatable { desc = 'step out', lazy_req('dap', 'step_out') },
        next = repeatable {
          desc = 'step over',
          lazy_req('dap', 'step_over'),
        },
      },
      w = b {
        desc = 'ui',
        lazy_req('utils.windows', 'show_ui', 'dap', lazy_req('dapui', 'open')),
      },
      x = keys {
        prev = b { desc = 'disconnect', lazy_req('dap', 'disconnect') },
        next = b { desc = 'terminate', lazy_req('dap', 'terminate') },
      },
      ['.'] = b { desc = 'run last', lazy_req('dap', 'run_last') },
      k = b { desc = 'up', lazy_req('dap', 'up') },
      j = b { desc = 'down', lazy_req('dap', 'down') },
      l = b { desc = 'launch', lazy_req('plugins.dap', 'launch') },
      r = b { desc = 'repl open', lazy_req('dap', 'repl.open') },
      h = keys {
        prev = b {
          "<cmd>lua require'dap.ui.variables'.hover()<cr>",
          desc = 'hover',
        },
        next = b {
          "<cmd>lua require'dap.ui.widgets'.hover()<cr>",
          desc = 'widgets',
        },
      },
      v = b {
        "<cmd>lua require'dap.ui.variables'.visual_hover()<cr>",
        desc = 'visual hover',
      },
      ['?'] = b {
        "<cmd>lua require'dap.ui.variables'.scopes()<cr>",
        desc = 'variables scopes',
      },
      tc = b {
        "<cmd>lua require'telescope'.extensions.dap.commands{}<cr>",
        desc = 'commands',
      },
      ['t,'] = b {
        "<cmd>lua require'telescope'.extensions.dap.configurations{}<cr>",
        desc = 'configurations',
      },
      tb = b {
        "<cmd>lua require'telescope'.extensions.dap.list_breakpoints{}<cr>",
        desc = 'list breakpoints',
      },
      tv = b {
        "<cmd>lua require'telescope'.extensions.dap.variables{}<cr>",
        desc = 'dap variables',
      },
      tf = b {
        "<cmd>lua require'telescope'.extensions.dap.frames{}<cr>",
        desc = 'dap frames',
      },
      ['<cr>'] = repeatable {
        desc = 'run to cursor',
        lazy_req('dap', 'run_to_cursor'),
      },
    },
    b = keys {
      prev = b { desc = 'scroll top', lazy_req('neoscroll', 'zt', 250) },
      next = b { desc = 'scroll bottom', lazy_req('neoscroll', 'zb', 250) },
      c = b { desc = 'scroll middle', lazy_req('neoscroll', 'zz', 250) },
    },
    c = b {
      desc = 'select adjacent command lines',
      require 'utils.select_comment',
    },
    d = keys {
      --   desc = 'show line',
      --   lazy('vim.diagnostic.open_float', nil, { source = 'always' }),
      c = keys {
        prev = b { desc = 'incoming calls', vim.lsp.buf.incoming_call },
        next = b { desc = 'outgoing calls', vim.lsp.buf.outgoing_calls },
      },
      s = b { desc = 'definition', vim.lsp.buf.definition },
      k = b { desc = 'hover', vim.lsp.buf.hover },
      r = b { desc = 'references', vim.lsp.buf.references },
      t = b { desc = 'go to type definition', vim.lsp.buf.type_definition },
      w = keys {
        desc = 'worspace folder',
        a = b {
          desc = 'add workspace folder',
          vim.lsp.buf.add_workspace_folder,
        },
        l = b {
          desc = 'ls workspace folder',
          vim.lsp.buf.list_workspace_folder,
        },
        d = b {
          desc = 'rm workspace folder',
          vim.lsp.buf.remove_workspace_folder,
        },
      },
      x = b { desc = 'signature help', vim.lsp.buf.signature_help },
    },
    -- e = keys {
    --   prev = b { desc = 'reset editor', require('utils').reset_editor },
    --   next = b {
    --     desc = 'current in new editor',
    --     require('utils').edit_current,
    --   },
    -- },
    e = b {
      desc = 'toggle emmet',
      function()
        require('utils.lsp').toggle_client 'emmet_ls'
      end,
    },
    f = keys {
      e = b {
        desc = 'edit file',
        require('utils.buffers').edit,
      },
      r = b {
        desc = 'rename file',
        require('utils.buffers').rename,
      },
      v = b {
        desc = 'move file',
        lazy_req('telescope', 'extensions.my.move'),
      },
    },
    h = keys {
      desc = 'git',
      redup = b {
        desc = 'neogit',
        lazy_req('utils.windows', 'show_ui', 'Neogit', 'Neogit'),
      },
      b = b {
        desc = 'branch',
        lazy_req(
          'utils.windows',
          'show_ui',
          'Neogit',
          lazy_req('neogit', 'open')
        ),
      },
      c = b {
        desc = 'commit',
        lazy_req('neogit', 'open'), -- split, vsplit
      },
      d = keys {
        desc = 'diffview',
        prev = b {
          desc = 'diffview',
          lazy_req('utils.windows', 'show_ui', 'Diffview', 'DiffviewOpen'),
        },
        next = b {
          desc = 'diffview file history',
          lazy_req(
            'utils.windows',
            'show_ui',
            'Diffview',
            'DiffviewFileHistory'
          ),
        },
      },
      k = b {
        desc = 'help',
        lazy_req('neogit', 'open'), -- split, vsplit
      },
      l = b {
        desc = 'log',
        lazy_req('neogit', 'open'), -- split, vsplit
      },
      p = keys {
        prev = b {
          desc = 'push',
          lazy_req('neogit', 'open'), -- split, vsplit
        },
        next = b {
          desc = 'pull',
          lazy_req('neogit', 'open'), -- split, vsplit
        },
      },
      r = b {
        desc = 'rebase',
        lazy_req('neogit', 'open'), -- split, vsplit
      },
      z = b {
        desc = 'stash',
        lazy_req('neogit', 'open'), -- split, vsplit
      },
      ['<cr>'] = b {
        desc = 'blame toggle',
        lazy_req('gitsigns', 'toggle_current_line_blame', { full = true }),
      },
    },
    k = keys {
      desc = 'help',
      redup = b {
        desc = 'tags',
        -- tab | horizontal | vertical

        function()
          require('telescope.builtin').help_tags {
            -- FIXME: not working
            cmd = 'vertical',
          }
        end,
      },
      c = b {
        desc = 'highlights',
        lazy_req('telescope.builtin', 'highlights'),
      },
      d = b {
        desc = 'markdown files',
        lazy_req('telescope', 'extensions.my.md_help'),
      },
      f = b { desc = 'filetype docu', require('utils').docu_current },
      m = b {
        desc = 'man pages',
        lazy_req('telescope.builtin', 'man_pages'),
      },
      o = b {
        -- FIXME:
        desc = 'modules',
        lazy_req('telescope', 'extensions.my.modules'),
      },
      w = b {
        desc = 'docs view',
        function()
          require('utils.windows').show_ui('docs-view', function()
            require('utils.docs-view').reveal()
          end)
        end,
      },
      y = b {
        desc = 'uniduck',
        lazy_req('telescope', 'extensions.my.uniduck'),
      },
    },
    r = modes {
      desc = 'spectre',
      n = keys {
        next = b {
          desc = 'open',
          lazy_req('spectre', 'open'),
        },
        prev = b {
          desc = 'open file seach',
          lazy_req('spectre', 'open_file_search'),
        },
      },
      x = keys {
        next = b {
          desc = 'open visual',
          lazy_req('spectre', 'open_visual'),
        },
        prev = b {
          desc = 'open visual select word',
          lazy_req('spectre', 'open_visual', { select_word = true }),
        },
      },
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
    n = keys {
      desc = 'zk',
      a = b {
        desc = 'open asset',
        require('plugins.zk.utils').open_asset,
      },
      redup = b {
        desc = 'notes',
        -- lazy_req('telescope', 'extensions.zk.notes'),
        lazy_req('telescope', 'extensions.my.zk_notes'),
      },
      c = b {
        desc = 'cd',
        lazy_req('zk', 'cd'),
      },
      d = b {
        desc = 'delete asset',
        require('plugins.zk.utils').remove_asset,
      },
      r = b {
        desc = 'index',
        lazy_req('zk', 'index'),
      },
      l = keys {
        prev = b {
          desc = 'links',
          function()
            -- FIXME:
            require('telescope').extensions.my.zk_notes {
              title = 'links',
              linkBy = { vim.api.nvim_buf_get_name(0) },
              recursive = true,
            }
          end,
        },
        next = b {
          desc = 'backlinks',
          function()
            require('telescope').extensions.my.zk_notes {
              title = 'backlinks',
              linkTo = { vim.api.nvim_buf_get_name(0) },
              recursive = true,
            }
          end,
        },
      },
      j = b {
        desc = 'new journal entry',
        function()
          require('plugins.zk.utils').new_journal_entry 'journal'
        end,
      },
      z = keys {
        prev = b {
          desc = 'new note from content',
          require('plugins.zk.utils').new_note_from_content,
          modes = 'x',
        },
        next = modes {
          x = b {
            desc = 'new note with title',
            require('plugins.zk.utils').new_note_with_title,
          },
        },
      },
      o = b {
        desc = 'orphans',
        function()
          require('telescope').extensions.my.zk_notes {
            title = 'orphans',
            orphan = true,
          }
        end,
      },
      t = b {
        desc = 'tags',
        lazy_req('telescope', 'extensions.zk.tags'),
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
    g = keys {
      desc = 'runner',
      redup = b {
        desc = 'dash run',
        ':DashRun<cr>',
      },
      y = b {
        desc = 'dash connect<cr>',
        ':DashConnect<cr>',
      },
      m = b {
        desc = 'carrot eval',
        ':CarrotEval<cr>',
      },
      n = b {
        desc = 'carrot new block',
        ':CarrotNewBlock<cr>',
      },
      s = b {
        desc = 'dash step',
        repeatable { lazy_req('dash', 'step') },
      },
      v = modes {
        desc = 'dash inspect',
        n = b { lazy_req('dash', 'inspect') },
        v = b { lazy_req('dash', 'vinspect') },
      },
      c = b {
        desc = 'dash continue',
        repeatable { lazy_req('dash', 'continue') },
      },
      p = b {
        desc = 'dash toggle breakpoit',
        lazy_req('dash', 'toggle_breakpoint'),
      },
    },
    G = keys {
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
    i = b {
      desc = 'messages',
      '<cmd>Noice<cr>',
    },
    m = keys {
      desc = 'toggle',
      s = b {
        desc = 'toggle conceal',
        require('utils.vim').toggle_conceal,
      },
      t = b {
        desc = 'toggle cursor conceal',
        require('utils.vim').toggle_conceal_cursor,
      },
      m = b {
        desc = 'toggle foldsigns',
        function()
          if vim.wo.foldcolumn == '1' then
            vim.wo.foldcolumn = '0'
          else
            vim.wo.foldcolumn = '1'
          end
        end,
      },
    },
    s = keys {
      prev = b {
        desc = 'projects (directory)',
        lazy_req('telescope', 'extensions.my.project_directory'),
      },
      next = b {
        desc = 'projects',
        lazy_req('telescope', 'extensions.my.projects'),
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
    w = keys {
      desc = 'windows',
      -- TODO: zoom
      prev = b { lazy_req('split', 'close'), desc = 'close' },
      e = b {
        desc = 'swap',
        require('utils.windows').winpick_swap,
      },
      h = b {
        desc = 'horizontal split equal',
        ':sp<cr>',
      },
      j = modes {
        desc = 'open',
        n = b { lazy_req('split', 'open', {}, 'n') },
        x = b { lazy_req('split', 'open', {}, 'x') },
      },
      n = keys {
        prev = b {
          desc = 'clone to',
          require('utils.windows').winpick_clone_to,
        },
        next = b {
          desc = 'clone from',
          require('utils.windows').winpick_clone_from,
        },
      },
      q = b { desc = 'lsp', lazy_req('split', 'open_lsp'), modes = 'nx' },
      r = modes {
        desc = 'pop',
        n = b { lazy_req('split', 'pop', { target = 'here' }, 'n') },
        x = b { lazy_req('split', 'pop', { target = 'here' }, 'x') },
      },
      w = b {
        desc = 'external',
        require('utils.windows').split_external,
      },
      x = b {
        desc = 'close',
        require('utils.windows').winpick_close,
      },
      z = keys {
        prev = b {
          desc = 'zen',
          'ZenMode',
          cmd = true,
        },
        next = b { require('utils.windows').zoom },
      },
      [';'] = b {
        utils.lazy(require('utils.windows').split_right, 85),
        desc = 'vertical 85',
      },
    },
    x = keys {
      -- Just to test if same results as code actions
      desc = 'refactoring telescope',
      function()
        require('telescope').extensions.refactoring.refactors()
      end,
    },
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
    -- f = b { desc = 'xplr', require('utils').xplr_launch },
    l = keys {
      desc = 'neoclip',
      q = b {
        desc = 'marco',
        lazy_req('telescope', 'extensions.macroscope.default'),
      },
      r = b { desc = 'clip', lazy_req('telescope', 'extensions.neoclip.+') },
      f = b { desc = 'clip', lazy_req('telescope', 'extensions.neoclip.f') },
      y = b {
        desc = 'yank',
        lazy_req('telescope', 'extensions.neoclip.default'),
      },
    },
    z = keys {
      desc = 'harpoon',
      redup = keys {
        redup = b {
          desc = 'harpoon ui',
          lazy_req('harpoon.ui', 'toggle_quick_menu'),
        },
      },
      y = b { desc = 'harpoon add', lazy_req('harpoon.mark', 'add_file') },
      [' '] = b {
        desc = 'harpoon command menu',
        lazy_req('harpoon.cmd-ui', 'toggle_quick_menu'),
      },
    },
    [' '] = b {
      desc = 'command',
      function()
        utils.keys ':'
      end,
      modes = 'nx',
    },
    -- z = keys {
    --   desc = 'spell',
    --   b = b { '<cmd>setlocal spell spelllang=en_us,fr,cjk<cr>', 'en fr' },
    --   e = b { '<cmd>setlocal spell spelllang=en_us,cjk<cr>', 'en' },
    --   f = b { '<cmd>setlocal spell spelllang=fr,cjk<cr>', 'fr' },
    --   y = b { '<cmd>zg', 'add to spellfile<cr>' },
    --   x = b { '<cmd>setlocal nospell<cr>', 'none' },
    -- },
    -- o = b {
    --   desc = 'open current external',
    --   require('utils').open_current,
    -- },
    -- t = b { desc = 'new terminal', require('utils').term },
    -- could merge with neo-tree
    --
  }
end

return M
