local M = {}

function M.config()
  if false then
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    local cmp = require 'cmp'
    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done { map_char = { tex = '' } }
    )

    -- add a lisp filetype (wrap my-function), FYI: Hardcoded = { "clojure", "clojurescript", "fennel", "janet" }
    cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = 'racket'
  end

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
  local Rule = require 'nvim-autopairs.rule'
  local npairs = require 'nvim-autopairs'

  npairs.add_rule(Rule('$$', '$$', 'lua'))
end

return M
