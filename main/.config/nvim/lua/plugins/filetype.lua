require('filetype').setup {
  overrides = {
    extensions = {
    },
    literal = {
      BufRead = 'json',
      BufNewFile = 'json',
      ['.eslintrc'] = 'json',
      ['.stylelintrc'] = 'json',
      ['.htmlhintrc'] = 'json',
      ['.busted'] = 'lua'
    },
    complex = {
      ['.config/sway/config'] = 'sway',
      ['.config/sway/config.d/*'] = 'sway',
      ['.config/kitty/*'] = 'kitty'
    },
  },
}
