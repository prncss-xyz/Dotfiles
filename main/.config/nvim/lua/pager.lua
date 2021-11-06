local augroup = require('utils').augroup
local full
local nvim_paging = os.getenv 'NVIM_PAGING'
if nvim_paging then
  full = false
  if nvim_paging ~= '1' then
    augroup('SetFiletype', {
      {
        events = { 'VimEnter' },
        targets = { '*' },
        command = function()
          vim.bo.filetype = nvim_paging
        end,
      },
    })
  end
else
  augroup('SetupStatusline', {
    {
      events = { 'BufReadPost' },
      targets = { '*' },
      command = function()
        require 'galaxyline'
      end,
    },
  })
  augroup('SetupLSP', {
    {
      events = { 'BufReadPost' },
      targets = { '*' },
      command = function()
        require 'lspconfig'
      end,
    },
  })
  full = true
end

return {
  full = full,
  is_full = function()
    return full
  end,
}
