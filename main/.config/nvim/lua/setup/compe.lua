require('compe').setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = 'enable',
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = {
    border = { '', '', '', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = 'NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder',
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  },
  source = {
    path = true,
    buffer = {
      kind = '﬘',
    },
    nvim_lsp = {
      -- dup = false,
    },
    calc = true,
    nvim_lua = true,
    spell = {
      filetypes = { 'markdown' },
    },
    emoji = false,
    omni = false, -- Warning: It has a lot of side-effect.
    -- FIXME dup = false makes then disappear
    luasnip = {
      -- kind = '', -- FIXME
      kind = 'x', -- FIXME
      dup = false,
      priority = 9999,
    },
    treesitter = false, -- Warning: it sometimes really slow.
    tabnine = false,
  },
}

require 'snip'

-- require("snippets").use_suggested_mappings()
require('nvim-autopairs.completion.compe').setup {
  map_cr = true,
  map_complete = true,
}

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function check_back_space()
  local col = vim.fn.col '.' - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' then
    return true
  else
    return false
  end
end

local ls = require 'luasnip'
-- local ls = require("snippets")

function _G.tab_complete()
  if vim.fn.pumvisible() == 1 then
    return t '<C-n>'
  elseif ls.jumpable(1) == true then
    -- return t("<cmd>lua require'snippets'.expand_or_advance(1)<Cr>")
    return t "<cmd>lua require'luasnip'.expand_or_jump(1)<Cr>"
  elseif check_back_space() then
    return t '<Tab>'
  else
    return t '<cmd>call emmet#moveNextPrev(1)<cr>'
    -- return vim.fn["compe#complete"]()
  end
end

function _G.s_tab_complete()
  if vim.fn.pumvisible() == 1 then
    return t '<C-p>'
  elseif ls.jumpable(-1) == true then
    -- return t("<cmd>lua require'snippets'.expand_or_advance(-1)<Cr>")
    return t "<cmd>lua require'luasnip'.expand_or_jump(-1)<Cr>"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    -- return t("<cmd>call emmet#moveNextPrev(0)<cr>")
    return t '<S-Tab>'
  end
end

require('luasnip/loaders/from_vscode').lazy_load {
  paths = os.getenv 'PROJECTS' .. '/closet',
}

-- completion-nvim

-- Completion is triggered if completion_trigger_character is entered. It's limitation of completion-nvim.
-- used with emmet language server
-- vim.g.completion_trigger_character = { '.' }