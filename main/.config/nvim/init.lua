function _G.Dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
  return ...
end

local disabled_built_ins = {
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
  'gzip',
  'zip',
  'zipPlugin',
  'tar',
  'tarPlugin',
  'getscript',
  'getscriptPlugin',
  'vimball',
  'vimballPlugin',
  '2html_plugin',
  'logipat',
  'rrhelper',
  'spellfile_plugin',
  'matchit',
}
for _, plugin in pairs(disabled_built_ins) do
  vim.g['loaded_' .. plugin] = 1
end

require('signs').setup()
require 'options'
require 'plugins'

require('bindings').setup()
require 'signs'
require 'commands'
require 'autocommands'
require('theme').setup()
require 'theme-exporter'
require 'setup-session'

require'utils'.augroup('SessionAsk', {
  {
    events = { 'VimEnter' },
    targets = { '*' },
    modifiers = { 'silent!' },
    command = function () 
      -- require'persistence'.load()
      -- vim.cmd("silent! BufferGoto %i<cr>")
        -- require("persistence").load()
      -- local isHome = os.getenv 'HOME' == os.getenv 'PWD'
      -- if isHome then
      --   -- require("persistence").load({last=true})
      --   -- require('session-lens').search_session()
      --   -- require'telescope'.extensions.repo.list()
      -- else
      --   require("persistence").load()
      --   require'telescope' -- workaround
      -- end
    end,
  },
})

