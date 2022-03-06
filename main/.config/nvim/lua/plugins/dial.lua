local augend = require 'dial.augend'

require('dial.config').augends:register_group {
  -- default augends used when no group name is specified
  default = {
    augend.integer.alias.decimal,
    augend.integer.alias.hex,
    augend.integer.alias.binary,
    augend.date.alias['%Y-%m-%d'],
    augend.constant.alias.bool,
    -- 'markup#markdown#header': not implemented (https://github.com/monaqa/dial.nvim/blob/f1f68d3ab39597107f6582cc17f698c0ff0c6945/TROUBLESHOOTING.md)
    -- toggle markdown todo
    augend.user.new {
      find = require('dial.augend.common').find_pattern '- %[.%]',
      add = function(text, _, cursor)
        if text:sub(4, 4) == ' ' then
          text = '- [x]'
        else
          text = '- [ ]'
        end
        cursor = #text
			  return {text = text, cursor = cursor}
      end,
    },
  },
}
