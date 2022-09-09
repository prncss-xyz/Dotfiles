local M = {}

function M.config()
  local overseer = require 'overseer'
  overseer.setup {
    pre_task_hook = function(task_defn)
      task_defn.env = require('utils.env').get()
    end,
  }

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
        return require('utils.std').file_exists 'package.json'
      end,
    },
  }

  overseer.register_template {
    generator = function()
      if require('utils.std').file_exists 'package.json' then
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
    end,
    -- FIX: do not seem to work as described
    -- condition = function()
    --   return require('utils.std').file_exists 'package.json'
    -- end,
  }
end

return M
