local M = {}

function M.config()
  require('overseer').setup {
    pre_task_hook = function(task_defn)
      local env = require('utils.set_env').env
      if env then
        task_defn.env = env
        dump(task_defn)
      end
    end,
  }
end

return M
