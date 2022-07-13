local M = {}

local function new_file(fname)
  if
    (fname:match '/%.local/bin/' or fname:match '^%.local/bin/')
    and not fname:match '%.local/bin/.+%.'
  then
    os.execute(string.format('chmod +x %q', fname))
  end
  -- when new file belongs to an active stow package, stow it
  local dots = os.getenv 'DOTFILES'
  if vim.fn.getcwd() == dots then
    local stow_package = fname:match('^(.-)/', #dots + 2)
    if
      require('utils.std').file_exists(
        string.format(
          '%s/.config/stow/active/%s',
          os.getenv 'HOME',
          stow_package
        )
      )
    then
      os.execute(string.format('stow %q', stow_package))
    end
  end
end

function M.config()
  -- highlights: NeoTreeFileNameOpened     File name when the file is open. Not used yet.
  require('neo-tree').setup {
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
      width = require('parameters').pane_width,
    },
    zk = {
      window = {
        mappings = {
          m = 'show_debug_info',
        },
      },
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
          ['oo'] = 'system_open',
          ['oh'] = 'open_split',
          ['os'] = 'open_vsplit',
          ['ow'] = 'open_with_window_picker',
          ['i'] = 'run_command',
          ['<tab>'] = 'preview',
          [';'] = 'open',
          ['é'] = 'fuzzy_finder',
          ['.'] = 'toggle_hidden',
          ['gh'] = 'set_root',
          ['gp'] = 'prev_git_modified',
          ['gn'] = 'next_git_modified',
          ['h'] = 'show_help',
          ['q'] = false,
        },
      },
      commands = {
        system_open = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          vim.api.nvim_command('silent !xdg-open ' .. path)
        end,
        run_command = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          vim.api.nvim_input(': ' .. path .. '<Home>')
        end,
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
          new_file(filename)
          vim.cmd('e ' .. filename)
          vim.defer_fn(function()
            require('templum').template_match(filename)
          end, 0)
        end,
      },
    },
  }
end

return M
