local utils = require 'modules.utils'
local command = utils.command

-- trying to figure it out
command('Conceal', {}, function()
  vim.cmd [[
    syntax match True "true" conceal cchar=⊤
    syntax match False "false" conceal cchar=⊥
      ]]
end)
