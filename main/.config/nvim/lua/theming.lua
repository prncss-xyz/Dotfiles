-- TODO: require theme plugins here
local dm = require('utils').deep_merge
local theme = require 'theme'

-- local theme = require 'theme'
-- local theme = {
--   name = 'solarized', colorscheme = 'solarized-flat',
--   g = {
--     neon_style = 'default',
--     -- neon_style = 'doom',
--     -- dark = 'light',
--     -- neon_style = 'dark',
--     -- neon_style =  "light",
--     neon_italic_comment = true,
--     neon_italic_keyword = true,
--     neon_bold = true,
--   },
-- }

-- theme = {
--   name = 'gruvbox-material',
--   -- dark = 'light',
--   g = {
--     gruvbox_material_background = 'soft',
--   },
-- }
-- https://github.com/Murtaza-Udaipurwala/gruvqueen

-- theme = {
--   name = 'nord',
--   g = {
--     -- nord_contrast = false,
--     -- nord_bordders = true,
--     -- nord_disable_background = true,
--   }
-- }

-- NOT WORKING
-- theme = {
--   name = 'doom-one',
--   g = {
--     doom_one_cursor_coloring = true,
--     doom_one_italic_comments = true,
--     doom_one_transparent_background = true,
--   },
-- }

return {
  setup = function()
    vim.o.background = theme.dark or 'dark' -- Color name (:help cterm-colors) or ANSI code
    vim.cmd('colorscheme ' .. (theme.cholorscheme or theme.name))
    if theme.g then
      dm(vim.g, theme.g)
    end
  end,
}
