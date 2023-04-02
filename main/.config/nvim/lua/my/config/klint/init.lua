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
    basepath = require('my.parameters').dotfiles .. '/theme-{{name}}',
    templates = {
      theme_name,
      nvim,
      require 'my.config.klint.kitty',
      require 'my.config.klint.sway',
      require 'my.config.klint.mako',
      require 'my.config.klint.sampler',
      require 'my.config.klint.waybar',
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
          size = { 20, 26 },
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
