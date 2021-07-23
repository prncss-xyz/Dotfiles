local Rule = require 'nvim-autopairs.rule'
local npairs = require 'nvim-autopairs'

-- npairs.add_rule(Rule('$$', '$$', 'tex'))

-- you can use some built-in condition

local cond = require 'nvim-autopairs.conds'
print(vim.inspect(cond))
npairs.add_rules {
  Rule('$$', '$$', 'tex'):with_pair(function(opts)
    print(vim.inspect(opts))
    if opts.line == 'aa $$' then
      -- don't add pair on that line
      return false
    end
  end),
}
