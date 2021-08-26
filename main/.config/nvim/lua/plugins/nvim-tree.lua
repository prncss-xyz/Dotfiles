local M = {}

M.config = function()
  local bindings = {}
  local cb = require('nvim-tree.config').nvim_tree_callback
  for key, value in pairs(require('bindings').plugins.nvim_tree) do
    table.insert(bindings, {
      key = key,
      cb = cb(value),
    })
  end
  vim.g.nvim_tree_bindings = bindings
  require'nvim-tree.events'.on_file_created(function (ev)
    local fname = ev.fname
    if fname:match('/%.local/bin/') then
      os.execute(string.format('chmod +x %q', fname))
    end
    vim.cmd(string.format('e %s', fname))
    require'templates'.template_match()
  end)
end

return M
