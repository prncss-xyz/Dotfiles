local script = [[
  . ./.env
  echo "MONGO_URL: $MONGO_URL"
  pnpm run dev:server
]]

return {
  name = 'pnpm dev:server',
  builder = function()
    return {
      cmd = { 'zsh' },
      args = { '-c', script },
      -- the name of the task (defaults to the cmd of the task)
      name = 'dev',
      components = { 'default' },
      metadata = {},
    }
  end,
}
