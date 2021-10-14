local full
local nvim_paging = os.getenv 'NVIM_PAGING'
if nvim_paging then
  full = false
  if nvim_paging ~= "1" then
    require('utils').augroup('SetFiletype', {
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
  full = true
end

return {
  full = full,
  is_full = function() return full end,
}
