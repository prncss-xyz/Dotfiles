local M = {}

function M.config()
  local augend = require 'dial.augend'

  require('dial.config').augends:register_group {
    -- default augends used when no group name is specified
    default = {
      augend.misc.alias.markdown_header,
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.integer.alias.binary,
      augend.date.alias['%Y-%m-%d'],
      augend.constant.alias.bool,
      augend.user.new {
        find = require('dial.augend.common').find_pattern '- %[.%]',
        add = function(text, _, cursor)
          if text:sub(4, 4) == ' ' then
            text = '- [x]'
          else
            text = '- [ ]'
          end
          cursor = #text
          return { text = text, cursor = cursor }
        end,
      },
    },
  }
end

return M
