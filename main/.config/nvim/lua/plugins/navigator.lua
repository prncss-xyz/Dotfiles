local m = {}

function m.config()
  require('navigator').setup {
    default_mapping = false,
  }
end

return m
