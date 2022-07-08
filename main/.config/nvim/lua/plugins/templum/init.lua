-- TODO: avoid requiring luasnip beforehand

local M = {}

function M.config()
  require('templum').setup(function()
    return require 'plugins.templum.snippets'
  end)
end

return M
