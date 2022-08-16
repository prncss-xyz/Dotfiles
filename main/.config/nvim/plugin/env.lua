local M = {}
--
local function my(name)
  return 'github.com/prncss-xyz/' .. name
end

require('utils.env').setup {
  prefix = require('parameters').project_files .. '/',
  port = true,
  confs = {
    [my 'oie-de-cravan'] = {
      AIRTABLE_API_KEY = {
        'sh',
        {
          '-c',
          'pass show airtable.com/quarknoir@gmail.com|tail -1',
        },
      },
      GATSBY_TRANSACTION = true,
    },
  },
}

return M
