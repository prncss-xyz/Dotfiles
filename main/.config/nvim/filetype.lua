vim.filetype.add {
  filename = {
    ['.eslintrc'] = 'json',
    ['.stylelintrc'] = 'json',
    ['.htmlhintrc'] = 'json',
    ['.busted'] = 'lua',
  },
  pattern = {
    ['.*/%.config/waybar/config'] = 'json',
    ['.*/%.config/kitty/.*'] = 'kitty',
    ['.*/%.config/sway/.*'] = 'sway',
  },
}
