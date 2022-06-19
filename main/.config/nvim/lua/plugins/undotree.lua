local M = {}

M.setup = function()
  vim.g.undotree_SplitWidth = require('parameters').pane_width
  vim.g.undotree_TreeVertShape = '│'
end

return M
