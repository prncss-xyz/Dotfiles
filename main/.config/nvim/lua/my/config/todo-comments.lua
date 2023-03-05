local M = {}

-- idea is to use the same vocabulary to name something to be done or it's result in conventionnal commit message
-- QUESTION: does seperate keywords leads to better navigation? 

function M.config()
  require('todo-comments').setup {
    keywords = {
      FIX = {
        icon = ' ', -- icon used for the sign, and in search results
        color = 'error', -- can be a hex color, or a named color (see below)
        alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' }, -- a set of other keywords that all map to this FIX keywords
        -- signs = false, -- configure signs for some keywords individually
      },
      TODO = {
        icon = ' ',
        color = 'info',
        alt = {
          'BUILD',
          'CI',
          'DOCS',
          'FEAT',
          'REFACT',
          'STYLE',
          'TEST',
          'QUESTION'
        },
      },
      HACK = { icon = ' ', color = 'warning' },
      WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
      PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
      NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
    },
  }
end

return M
