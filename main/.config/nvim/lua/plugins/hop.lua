local M = {}

M.config = function()
  require('hop').setup {
    jump_on_sole_occurrence = true,
    keys = 'asdfjkl;ghqweruiopzxcvm,étybn'
    -- . does not work
  }
end

return M
