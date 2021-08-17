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
    path = {
      priority = 10000, -- default
    },
    buffer = {
      kind = '﬘',
      priority = 10, -- default
    },
    nvim_lsp = {
      priority = 1000,
      -- dup = false,
    },
    calc = {
      priority = 50, -- default
    },
    nvim_lua = {
      priority = 100, -- default
    },
    spell = {
      priority = 90, -- default
    },
    emoji = false,
    omni = false, -- Warning: It has a lot of side-effect.
    -- FIXME dup = false makes then disappear
    luasnip = {
      kind = '', -- FIXME
      dup = false,
      priority = 100, -- default,
    },
    treesitter = false, -- Warning: it sometimes really slow.
    tabnine = false,
  },
}
