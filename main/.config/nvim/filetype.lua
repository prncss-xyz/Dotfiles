vim.filetype.add {
  filename = {
    ['.eslintrc'] = 'json',
    ['.stylelintrc'] = 'json',
    ['.htmlhintrc'] = 'json',
    ['.busted'] = 'lua',
  },
  pattern = {
    -- ['.config/sway/config'] = 'sway',
    -- ['.config/sway/config.d/*'] = 'sway',
    ['.config/kitty/*'] = 'kitty',
    ['.config/waybar/config'] = 'json',
  },
}
