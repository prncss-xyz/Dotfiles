local function file_cmd(cb)
  return function(state)
    local node = state.tree:get_node()
    local path = node:get_id()
    cb(path)
  end
end

return {
  {
    'willothy/flatten.nvim',
    config = {
      callbacks = {
        nest_if_no_args = false,
      },
    },
    priority = 1001,
  },
  {
    'antosha417/nvim-lsp-file-operations',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-neo-tree/neo-tree.nvim',
    },
    config = function()
      require('lsp-file-operations').setup()
    end,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    opts = function()
      local khutulun = require 'khutulun'
      return {
        open_files_do_not_replace_types = {
          'terminal',
          'Trouble',
          'qf',
          'edgy',
        },
        -- sources = {
        --   'filesystem',
        --   'buffers',
        --   'git_status',
        --   -- 'neo-tree-zk',
        --   -- 'zk',
        --   -- 'document_symbols',
        -- },
        default_component_configs = {
          indent = {
            indent_marker = ' ',
            last_indent_marker = ' ',
          },
          modified = {
            symbol = '',
          },
          name = {
            use_git_status_colors = false,
          },
        },
        close_if_last_window = true,
        window = {
          width = require('my.parameters').pane_width,
        },
        filesystem = {
          follow_current_file = {
            enabled = true,
          },
          -- 'open_default', 'disabled'
          hijack_netrw_behavior = 'open_current',
          use_libuv_file_watcher = true,
          filtered_items = {
            hide_dotfiles = true,
          },
          window = {
            mappings = {
              a = false,
              s = false,
              e = 'create',
              gh = 'set_root',
              gp = 'prev_git_modified',
              gn = 'next_git_modified',
              h = 'show_help',
              i = 'run_command',
              oo = 'system_open',
              oh = 'open_split',
              os = 'open_vsplit',
              ow = 'open_with_window_picker',
              q = false,
              v = 'move',
              yl = 'yank_filename',
              yy = 'yank_filepath',
              x = 'delete',
              ['<tab>'] = 'preview',
              [';'] = 'open',
              ['é'] = 'fuzzy_finder',
              ['.'] = 'toggle_hidden',
            },
          },
          renderers = {
            file = {
              { 'icon' },
              { 'name', use_git_status_colors = true },
              { 'diagnostics' },
              { 'git_status', highlight = 'NeoTreeDimText' },
            },
          },
          commands = {
            move = file_cmd(khutulun.move),
            duplicate = file_cmd(khutulun.duplicate),
            create = file_cmd(khutulun.create),
            --[[ rename = file_cmd(khutulun.rename), ]]
            yank_absolute = file_cmd(khutulun.yank_absolute_filepath),
            yank_filepath = file_cmd(khutulun.yank_relavite_filepath),
            yank_filename = file_cmd(khutulun.yank_filename),
            system_open = file_cmd(function(path)
              vim.api.nvim_command('silent !xdg-open ' .. path)
            end),
            run_command = file_cmd(function(path)
              vim.api.nvim_input(': ' .. path .. '<Home>')
            end),
            preview = function(state)
              local node = state.tree:get_node()
              if require('neo-tree.utils').is_expandable(node) then
                state.commands['toggle_node'](state)
              else
                state.commands['open'](state)
                vim.cmd 'Neotree reveal'
              end
            end,
          },
        },
        event_handlers = {
          {
            event = 'file_added',
            handler = function(filename)
              -- new_file(filename)
              vim.cmd.edit(filename)
              vim.defer_fn(function()
                require('templum').template_match(filename)
              end, 0)
            end,
          },
        },
      }
    end,
    cmd = { 'Neotree' },
    dependencies = { dir = require('my.utils').local_repo 'neo-tree-zk.nvim' },
  },
  {
    dir = require('my.utils').local_repo 'khutulun.nvim',
    -- 'chrisgrieser/nvim-genghis',
    opts = {
      mv = function(source, target)
        local tsserver = require('my.utils.lsp').get_client 'tsserver'
        if tsserver then
          require('typescript').renameFile(source, target)
        else
          return require('khutulun').default_mv(source, target)
        end
      end,
      bdelete = function()
        require('bufdelete').bufdelete(0, true)
      end,
    },
  },
  {
    'ethanholz/nvim-lastplace',
    event = 'BufReadPre',
    opts = {
      lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help' },
      lastplace_ignore_filetype = {
        'gitcommit',
        'gitrebase',
        'svn',
        'hgcommit',
      },
    },
    enabled = true,
  },
  {
    -- FIXME:
    'notjedi/nvim-rooter.lua',
    event = 'BufReadPost',
    enabled = false,
  },
  {
    'famiu/bufdelete.nvim',
  },
  {
    'gaborvecsei/usage-tracker.nvim',
    opts = {},
    event = 'VeryLazy',
    cmd = {
      'UsageTrackerShowAgg',
      'UsageTrackerShowFilesLifetime',
      'UsageTrackerShowVisitLog',
      'UsageTrackerShowDailyAggregation',
      'UsageTrackerShowDailyAggregationByFiletypes',
      'UsageTrackerShowDailyAggregationByProject',
      'UsageTrackerRemoveEntry',
      'UsageTrackerClenup',
    },
    enabled = false,
  },
  {
    'notjedi/nvim-rooter.lua',
    opts = {
      rooter_patterns = { '.git', '.hg', '.svn', 'node_modules' },
    },
    name = 'nvim-rooter',
    event = 'VimEnter',
    cmd = { 'Rooter', 'RooterToggle' },
  },
  {
    'echasnovski/mini.misc',
    opts = {
      make_global = { 'put', 'put_text' },
    },
    config = function(_, opts)
      require('mini.misc').setup(opts)
      -- MiniMisc.setup_auto_root()
      -- MiniMisc.setup_restore_cursor()
    end,
    lazy = false,
    enabled = false,
  },
}
