local M = {}

function M.config()
  local overseer = require 'overseer'
  overseer.setup {}
  overseer.register_template {
    name = 'term',
    builder = function()
      return {
        -- footclient wont pass the environment
        cmd = { 'foot' },
      }
    end,
  }

  overseer.register_template {
    name = 'pnpm install',
    builder = function(params)
      return {
        cmd = { 'pnpm' },
        args = { 'install', params.name },
        name = 'pnpm install',
      }
      -- block
    end,
    params = {
      name = {
        type = 'string',
        optional = false,
      },
    },
    condition = {
      callback = function()
        return require('my.utils.std').file_exists 'package.json'
      end,
    },
  }

  -- FIXME: apparently a breaking change affects this
  if false then
    overseer.register_template {
      generator = function()
        if false then
          if require('my.utils.std').file_exists 'package.json' then
            return {
              {
                name = 'pnpm install --recursive',
                params = {},
                builder = function()
                  return {
                    cmd = { 'pnpm', 'install', 'recursive' },
                  }
                end,
              },
              {
                name = 'pnpm update --recursive',
                params = {},
                builder = function()
                  return {
                    cmd = { 'pnpm', 'update', 'recursive' },
                  }
                end,
              },
              {
                name = 'pnpm prune',
                params = {},
                builder = function()
                  return {
                    cmd = { 'pnpm', 'prune' },
                  }
                end,
              },
            }
          else
            return {}
          end
        end
      end,
      -- FIX: do not seem to work as described
      -- condition = function()
      --   return require('my.utils.std').file_exists 'package.json'
      -- end,
    }
  end
end

return M
