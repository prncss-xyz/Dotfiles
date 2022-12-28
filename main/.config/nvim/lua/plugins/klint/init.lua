local M = {}

local theme_name = {
  path = '.theme_name',
  contents = [[{{name}}]],
}

local nvim = {
  path = '.config/nvim/plugin/theme.lua',
  contents = [[
    vim.cmd{cmd ='colorscheme', args={"{{name}}"}}
  ]],
}

function M.config()
  local eval = require('klint').eval
  require('klint').setup {
    basepath = require('parameters').dotfiles .. '/theme-{{name}}',
    templates = {
      theme_name,
      nvim,
      require 'plugins.klint.kitty',
      require 'plugins.klint.sway',
      require 'plugins.klint.mako',
      require 'plugins.klint.sampler',
      require 'plugins.klint.waybar',
    },
    context = {
      default = {
        background = eval 'term00',
        foreground = eval 'Normal.fg',
        selection_background = eval { 'Visual.bg', 'Normal.bg' },
        selection_foreground = eval { 'Visual.fg', 'Normal.fg' },
        cursor = eval { 'Cursor.fg', 'Normal.fg' },
        text = eval 'Normal.fg',
        accent = eval 'term06',
        primary = eval 'term12',
        font = {
          name = 'Montserrat',
          style = 'sans',
          size = { 10, 13 },
        },
        gtk_theme = 'Adwaita',
      },
      ['rose-pine'] = {
        text = eval 'term08',
        accent = eval 'term14',
        primary = eval 'term12',
        gtk_theme = 'Rose-pine',
      },
    },
    themes = {
      'solarized-flat',
      'rose-pine',
      'material',
      'gruvbox-material',
      'everforest',
      'neon',
    },
  }
end

return M
