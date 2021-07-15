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
--
-- require("snippets").use_suggested_mappings()

require('nvim-autopairs.completion.compe').setup {
  map_cr = true,
  map_complete = true,
}

-- function _G.completions()
-- 	-- local npairs = require 'nvim-autopairs'
-- 	if vim.fn.pumvisible() == 1 then
-- 		if vim.fn.complete_info()["selected"] ~= -1 then
-- 			return vim.fn["compe#confirm"]("<CR>")
-- 		end
-- 	end
-- 	-- return npairs.check_break_line_char()
-- end

require('luasnip/loaders/from_vscode').lazy_load() -- FIXME: failling to use "path" argument

-- completion-nvim

-- Completion is triggered if completion_trigger_character is entered. It's limitation of completion-nvim.

vim.g.completion_trigger_character = { '.' }
