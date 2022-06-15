local M = {}

local function file_exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local function add_open(state, callback)
  require('neo-tree.sources.common.commands').add(state, function(path)
    dump(path)
    -- require 'neo-tree.sources.common.commands'.open(state, nil)
    callback(path)
  end)
end

local function open(path)
  local config = require('neo-tree').config
  local window_position = 'left' -- we don't have access to state with this event
  local width = config.width
  local open_cmd = 'edit'
  local suitable_window_found = false
  local nt = require 'neo-tree'
  if nt.config.open_files_in_last_window then
    local prior_window = nt.get_prior_window()
    if prior_window > 0 then
      local success = pcall(vim.api.nvim_set_current_win, prior_window)
      if success then
        suitable_window_found = true
      end
    end
  end

  -- find a suitable window to open the file in
  if not suitable_window_found then
    if window_position == 'right' then
      vim.cmd 'wincmd t'
    else
      vim.cmd 'wincmd w'
    end
  end
  local attempts = 0
  while attempts < 4 and vim.bo.filetype == 'neo-tree' do
    attempts = attempts + 1
    vim.cmd 'wincmd w'
  end
  if vim.bo.filetype == 'neo-tree' then
    -- Neo-tree must be the only window, restore it's status as a sidebar
    local winid = vim.api.nvim_get_current_win()
    vim.cmd('vsplit ' .. path)
    vim.api.nvim_win_set_width(winid, width)
  else
    vim.cmd(open_cmd .. ' ' .. path)
  end
end

function M.config()
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
      width = vim.g.u_pane_width,
    },
    filesystem = {
      follow_current_file = true,
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
        },
      },
      commands = {
        add_open = add_open,
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
    -- 'file_moved', 'file_renamed'
    event_handlers = {
      --   {
      --     event = 'file_added',
      --     handler = function(filename)
      --       print(filename, 'created')
      --       if
      --         (filename:match '/%.local/bin/' or filename:match '^%.local/bin/')
      --         and not filename:match '%.local/bin/.+%.'
      --       then
      --         os.execute(string.format('chmod +x %q', filename))
      --       end
      --       -- when new file belongs to an active stow package, stow it
      --       local dots = os.getenv 'DOTFILES'
      --       if vim.fn.getcwd() == dots then
      --         local stow_package = filename:match('^(.-)/', #dots + 2)
      --         if
      --           file_exists(
      --             string.format(
      --               '%s/.config/stow/active/%s',
      --               os.getenv 'HOME',
      --               stow_package
      --             )
      --           )
      --         then
      --           os.execute(string.format('stow %q', stow_package))
      --         end
      --       end
      --       open(filename)
      --       require('templum').template_match()
      --     end,
      --   },
      -- },
    },
  }
end

return M
