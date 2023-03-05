local M = {}

function M.config()
  -- diminishes flashing while typing
  require('illuminate').configure {
    providers = {
      'lsp',
      'treesitter',
      'regex',
    },
    delay = 0,
    -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
    filetypes_denylist = {
      'dirvish',
      'fugitive',
    },
    -- filetypes_allowlist: filetypes to illuminate, this is overriden by filetypes_denylist
    filetypes_allowlist = {},
    -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
    modes_denylist = {},
    -- modes_allowlist: modes to illuminate, this is overriden by modes_denylist
    modes_allowlist = {},
    -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
    -- Only applies to the 'regex' provider
    -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
    providers_regex_syntax_denylist = {},
    -- providers_regex_syntax_allowlist: syntax to illuminate, this is overriden by providers_regex_syntax_denylist
    -- Only applies to the 'regex' provider
    -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
    providers_regex_syntax_allowlist = {},
    -- under_cursor: whether or not to illuminate under the cursor
    under_cursor = true,
  }
  if false then
    vim.api.nvim_create_autocmd('InsertEnter', {
      pattern = '*',
      callback = function()
        vim.g.Illuminate_delay = 1000
      end,
    })
    vim.api.nvim_create_autocmd('InsertEnter', {
      pattern = '*',
      callback = function()
        vim.g.Illuminate_delay = 0
      end,
    })
  end
end

return M
