local M = {}

local function file_cmd(cb)
  return function(state)
    local node = state.tree:get_node()
    local path = node:get_id()
    cb(path)
  end
end

function M.config()
  local khutulun = require 'khutulun'
  -- highlights: NeoTreeFileNameOpened     File name when the file is open. Not used yet.
  require('neo-tree').setup {
    sources = {
      'filesystem',
      'buffers',
      'git_status',
      'neo-tree-zk',
      -- 'zk',
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
        harpoon_index = function(config, node, state)
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
      renderers = {
        file = {
          { 'icon' },
          { 'name', use_git_status_colors = true },
          { 'harpoon_index' }, --> This is what actually adds the component in where you want it
          { 'diagnostics' },
          { 'git_status', highlight = 'NeoTreeDimText' },
        },
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
end

return M
