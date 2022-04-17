local M = {}

function M.config()
  require('nvim-autopairs').setup {
    disable_in_macro = true,
    -- check_ts = true,
    fast_wrap = {
      map = '<m-e>',
      chars = { '{', '[', '(', '"', "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
      end_key = '$',
      keys = 'qwertyuiopzxcvbnmasdfghjkl',
      check_comma = true,
    },
  }
end

return M
