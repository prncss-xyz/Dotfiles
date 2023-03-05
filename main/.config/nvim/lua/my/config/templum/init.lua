-- TODO: avoid requiring luasnip beforehand

local M = {}

function M.config()
  require('templum').setup(function()
    return require 'my.config.templum.snippets'
  end)
end

return M
