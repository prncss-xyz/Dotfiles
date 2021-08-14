local deep_merge = require('utils').deep_merge
local map = require('utils').buf_map

map('', 'j', 'gj')
map('', 'k', 'gk')
map('', 'gj', 'j')
map('', 'gk', 'k')
map('', 'gs', '<cmd>Telescope heading<cr>')
map('', 'gh', '<Plug>Markdown_MoveToNextHeader', { noremap = false })
map('', 'gH', '<Plug>Markdown_MoveToPreviousHeader', { noremap = false })
map('', 'gu', '<Plug>Markdown_MoveToCurHeader', { noremap = false })
map('', 'g;', '<Plug>Markdown_MoveToParentHeader', { noremap = false })

-- both are identical
map('ox', 'ad', '<Plug>(textobj-datetime-auto)', { noremap = false })
map('ox', 'id', '<Plug>(textobj-datetime-auto)', { noremap = false })

-- vim.fn.call('textobj#sentence#init', {})

-- I write poetry
deep_merge(vim.opt_local, {
  breakindent = true,
  breakindentopt = 'shift:2',
})
