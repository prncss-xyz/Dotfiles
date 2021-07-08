local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node

-- stylua: ignore
ls.snippets = {
  javascript = {
    s({
      trig = 'she',
      name = 'shebang',
    }, {
      t '#!/usr/bin/env node',
      f(function ()
        vim.cmd(string.format("!chmod +x %q", vim.fn.expand '%:p'))
        return ''
      end, {}),
      t {'', ''},
    }),
  },
  lua = {
    s("__insert_node_exemple", c(1, {
		  t("Ugh boring, a text node"),
  		i(nil, "At least I can edit something now..."),
  		f(function(args) return "Still only counts as text!!" end, {})
  	})),
	  s("__function_node_exemple", {
		  i(1),
  		f(function(args, user_arg_1) return args[1][1] .. user_arg_1 end,
	  		{1},
		  	"Will be appended to text from i(0)"),
  		i(0)
	  }),
  },
}
