local lockfiles = {
  npm = 'package-lock.json',
  pnpm = 'pnpm-lock.yaml',
  yarn = 'yarn.lock',
  bun = 'bun.lockb',
}
---@param opts overseer.SearchParams
local function get_package_file(opts)
  return vim.fs.find(
    'package.json',
    { upward = true, type = 'file', path = opts.dir }
  )[1]
end

local function pick_package_manager(opts)
  local package_dir = vim.fs.dirname(get_package_file(opts))
  for mgr, lockfile in pairs(lockfiles) do
    if files.exists(files.join(package_dir, lockfile)) then
      return mgr
    end
  end
  return 'npm'
end

return {
  {
    'stevearc/overseer.nvim',
    opts = {},
    config = function(_, opts)
      local overseer = require 'overseer'
      overseer.setup(opts)
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
    end,
    cmd = {
      'OverseerOpen',
      'OverseerClose',
      'OverseerToggle',
      'OverseerSaveBundle',
      'OverseerLoadBundle',
      'OverseerDeleteBundle',
      'OverseerRunCmd',
      'OverseerRun',
      'OverseerInfo',
      'OverseerBuild',
      'OverseerQuickAction',
      'OverseerTaskAction',
      'OverseerClearCache',
    },
  },
}
