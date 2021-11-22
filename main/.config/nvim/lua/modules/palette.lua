local M = {}


-- visual mode
-- shrink selection by one character
-- vim.schedule causes exiting visual selection
function M.shrink()
  get_visual_selection(function(selection)
    -- if selection:match '^%[%[.*%]%]$' then
    --   vim.fn.feedkeys(t 'hhollo', 'n')
    -- else
    vim.fn.feedkeys(t 'holo', 'n')
    -- end
  end)
end

function M.pre()
  local prefix = ''
  local p0 = vim.fn.getpos 'v'
  local p1 = vim.fn.getpos '.'
  if p0[2] < p1[2] or p0[2] == p1[2] and p0[3] < p1[3] then
    prefix = 'o'
  end
  local postfix = true and 'i' or 'I' -- TODO: detect selection mode
  vim.fn.feedkeys(t(prefix .. '<esc>' .. postfix))
end

function M.post()
  local prefix = ''
  local p0 = vim.fn.getpos 'v'
  local p1 = vim.fn.getpos '.'
  local postfix = true and 'a' or 'A' -- TODO: detect selection mode
  if p0[2] > p1[2] or p0[2] == p1[2] and p0[3] > p1[3] then
    prefix = 'o'
  end
  vim.fn.feedkeys(t(prefix .. '<esc>' .. postfix))
end


return M
