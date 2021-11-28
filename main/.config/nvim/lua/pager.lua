local augroup = require('modules.utils').augroup
local full
local nvim_paging = os.getenv 'NVIM_PAGING'
if nvim_paging then
  -- FIXME:
  full = false
  augroup('SetFiletype', {
    {
      events = { 'VimEnter' },
      targets = { '*' },
      command = function()
        if nvim_paging ~= '1' then
          vim.bo.filetype = nvim_paging
        else
          vim.cmd'Man!'
        end
      end,
    },
  })
else
  --[[ if vim.fn.argc() == 0 then
  augroup('LoadFile', {
    {
      events = { 'VimEnter' },
      targets = { '*' },
      command = function()
        require('bufjump').backward()
      end,
    },
  })
  end ]]
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
