local M = {}

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
    },
  }
end

return M
