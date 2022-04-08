local M = {}

M.setup = function()
  vim.g.undotree_SplitWidth = vim.g.u_pane_width
  vim.g.undotree_TreeVertShape = '│'
end

return M
