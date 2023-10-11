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
    config = {},
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
        sources = {
          'filesystem',
          'buffers',
          'git_status',
          -- 'neo-tree-zk',
          -- 'zk',
         -- 'document_symbols',
        },
        enable_git_status = true,
        enable_diagnostics = true,
        default_component_configs = {
          indent = {
            indent_marker = ' ',
            last_indent_marker = ' ',
          },
          modified = {
            symbol = '',
            hightlight = 'NeoTreefileIcon',
          },
          name = {
            use_git_status_colors = false,
            highlight = 'NeoTreeFileIcon',
          },
          git_status = {
            symbols = {
              -- Change type
              added = '✚',
              modified = '',
            },
          },
        },
        close_if_last_window = true,
        window = {
          width = require('my.parameters').pane_width,
        },
        filesystem = {
          follow_current_file = true,
          hijack_netrw_behavior = 'open_default',
          use_libuv_file_watcher = true,
          filtered_items = {
            hide_dotfiles = false,
          },
          window = {
            mappings = {
              a = false,
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
              { 'harpoon_index' }, --> This is what actually adds the component in where you want it
              { 'diagnostics' },
              { 'git_status', highlight = 'NeoTreeDimText' },
            },
          },
          commands = {
            move = file_cmd(khutulun.move),
            duplicate = file_cmd(khutulun.duplicate),
            create = file_cmd(khutulun.create),
            rename = file_cmd(khutulun.rename),
            yank_filepath = file_cmd(khutulun.yank_filepath),
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
          components = {
            harpoon_index = function(config, node, _)
              local Marked = require 'harpoon.mark'
              local path = node:get_id()
              local succuss, index = pcall(Marked.get_index_of, path)
              if succuss and index and index > 0 then
                -- TODO: sync with bindings
                local index_name = { 'zu', 'zi', 'zo', 'zp' }
                local text = index_name[index] or (string.format('%d', index))
                text = string.format(' ⥤ %s ', text)
                return {
                  text = text, -- <-- Add your favorite harpoon like arrow here
                  highlight = config.highlight or 'NeoTreeDirectoryIcon',
                }
              else
                return {}
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
  -- TODO: with flatten, we just need terminal buffer
  {
    'is0n/fm-nvim',
    opts = {
      ui = {
        default = 'float',
        split = {
          direction = 'leftabove',
        },
      },
    },
    cmd = { 'Xplr' },
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
    enable = false,
  },
  {
    -- FIXME:
    'notjedi/nvim-rooter.lua',
    event = 'BufReadPost',
    enable = false,
  },
  {
    'ThePrimeagen/harpoon',
    opts = {
      global_settings = {
        save_on_toggle = true,
        enter_on_sendcmd = true,
      },
      projects = {
        ['$DOTFILES'] = {
          term = {
            cmds = {
              'ls',
            },
          },
        },
      },
    },
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
  },
}
