local M = {}

-- a built in plugin do not seem to work yet

function M.config()
  if true then
    return
  end
  require('filetype').setup {
    overrides = {
      extensions = {},
      literal = {
        -- BufRead = 'json',
        -- BufNewFile = 'json',
        ['.eslintrc'] = 'json',
        ['.stylelintrc'] = 'json',
        ['.htmlhintrc'] = 'json',
        ['.busted'] = 'lua',
      },
      complex = {
        -- ['.config/sway/config'] = 'sway',
        -- ['.config/sway/config.d/*'] = 'sway',
        ['.config/kitty/*'] = 'kitty',
        ['.config/waybar/config'] = 'json',
      },
    },
  }
end

return M
