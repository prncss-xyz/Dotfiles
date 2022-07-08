local M = {}

local function cr()
  require('plugins.binder.actions').cr()
  return _G.MPairs.completion_confirm()
end

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
      end_key = ';',
      keys = 'qwertyuiopzxcvbnmasdfghjkl',
      check_comma = true,
    },
  }
  local Rule = require 'nvim-autopairs.rule'
  local npairs = require 'nvim-autopairs'
  local cond = require 'nvim-autopairs.conds'
  local opt = require('nvim-autopairs').config

  -- FIXME: 
  if false then
    local basic = function(...)
      local move_func = opt.enable_moveright and cond.move_right or cond.none
      local rule = Rule(...)
        :with_move(move_func())
        :with_pair(cond.not_add_quote_inside_quote())

      if #opt.ignored_next_char > 1 then
        rule:with_pair(cond.not_after_regex(opt.ignored_next_char))
      end
      rule:use_undo(opt.break_undo)
      return rule
    end
    npairs.add_rule(basic('_', '_', 'markdown'))
  end

  vim.api.nvim_set_keymap('i', '<cr>', '', {
    noremap = true,
    expr = true,
    callback = cr,
  })
end

return M
