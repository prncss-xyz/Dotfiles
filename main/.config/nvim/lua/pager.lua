-- from nvimpager
-- local function detect_parent_process()
--   local ppid = os.getenv('PARENT') -- FIXME
--   print('ppid', ppid)
--   if not ppid then return nil end
--   local proc = vim.api.nvim_get_proc(tonumber(ppid))
--   if proc == nil then return 'none' end
--   local command = proc.name
--   print(command)
--   if command == 'man' then
--     return 'man'
--   elseif command:find('^[Pp]ython[0-9.]*') ~= nil or
-- 	 command:find('^[Pp]ydoc[0-9.]*') ~= nil then
--     return 'pydoc'
--   elseif command == 'ruby' or command == 'irb' or command == 'ri' then
--     return 'ri'
--   elseif command == 'perl' or command == 'perldoc' then
--     return 'perldoc'
--   elseif command == 'git' then
--     return 'git'
--   end
--   return nil
-- end

-- -- from nvimpager
-- -- Search the begining of the current buffer to detect if it contains a man
-- -- page.
-- local function detect_man_page_in_current_buffer()
--   -- Only check the first twelve lines (for speed).
--   for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, 12, false)) do
--     -- Check if the line contains the string "NAME" or "NAME" with every
--     -- character overwritten by itself.
--     -- An earlier version of this code did also check if there are whitespace
--     -- characters at the end of the line.  I could not find a man pager where
--     -- this was the case.
--     -- FIXME This only works for man pages in languages where "NAME" is used
--     -- as the headline.  Some (not all!) German man pages use "BBEZEICHNUNG"
--     -- instead.
--     if line == 'NAME' or line == 'N\bNA\bAM\bME\bE' then
--       return true
--     end
--   end
--   return false
-- end

-- local full = not os.getenv'NVIM_PAGING'
-- local filetype = detect_parent_process()
-- if filetype then
--   full = false
-- elseif not full and detect_man_page_in_current_buffer() then
--   filetype = 'man'
-- end

local full
local nvim_paging = os.getenv 'NVIM_PAGING'
if nvim_paging then
  full = false
  if nvim_paging ~= 1 then
    require('utils').augroup('SetFiletype', {
      {
        events = { 'VimEnter' },
        targets = { '*' },
        command = function()
          vim.api.nvim_buf_set_option(0, 'filetype', nvim_paging)
        end,
      },
    })
  end
else
  full = true
end

return {
  is_full = function()
    return full
  end,
}
