require('nvim-autopairs').setup {}
local Rule = require 'nvim-autopairs.rule'
local cond = require 'nvim-autopairs.conds'
local npairs = require 'nvim-autopairs'

print 'setup'
npairs.add_rules {
  Rule('*', '*', 'markdown'),
  Rule('**', '*', 'markdown'):with_move(cond.none),
  Rule('_', '_', 'markdown'),
  Rule('__', '_', 'markdown'):with_move(cond.none),
  -- FIXME - not properly closed
  -- TODO ```
}

-- needs a condition
-- npairs.add_rule(Rule('**', '**', 'lua'))

-- npairs.add_rule(Rule('$$', '$$', 'tex'))
-- you can use some built-in condition

-- print(vim.inspect(cond))
-- npairs.add_rules {
--   Rule('*', '*', 'markdown'),
--   Rule('$$', '$$', 'tex'):with_pair(function(opts)
--     print(vim.inspect(opts))
--     if opts.line == 'aa $$' then
--       -- don't add pair on that line
--       return false
--     end
--   end),
-- }