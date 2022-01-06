require('filetype').setup {
  overrides = {
    literal = {
      BufRead = 'json',
      BufNewFile = 'json',
      ['.eslintrc'] = 'json',
      ['.stylelintrc'] = 'json',
      ['.htmlhintrc'] = 'json',
    },
    complex = {
      ['.config/sway/config'] = 'sway',
      ['.config/sway/config.d/*'] = 'sway',
      ['.config/kitty/*'] = 'kitty',
    },
  },
}
