local function fallback_register0(t, mode, prefix)
  for key, value in pairs(t) do
    -- local desc = ''
    if key == 'name' then
      -- desc = desc .. prefix .. key .. ' -> +' .. value .. '\n'
    else
      if value[1] then
        -- print(prefix .. key, value[1], mode)
        require('utils').map(mode, prefix .. key, value[1])
        -- desc = desc .. prefix .. key .. ' -> ' .. value[2] .. '\n'
      else
        fallback_register0(value, mode, prefix .. key)
      end
    end
  end
end

local function fallback_register(t, opts)
  opts = opts or {}
  fallback_register0(t, opts.mode or '', opts.prefix or '')
end

local ok, register = pcall(function()
  return require('which-key').register
end)
return ok and register or fallback_register
