local M = {}

function M.config()
  require('neorg').setup {
    -- Tell Neorg what modules to load
    load = {
      ['core.defaults'] = {}, -- Load all the default modules
      ['core.norg.concealer'] = {}, -- Allows for use of icons
      ['core.keybinds'] = { -- Configure core.keybinds
        config = {
          default_keybinds = true, -- Generate the default keybinds
          neorg_leader = '<Leader>o', -- This is the default if unspecified
        },
      },
      ['core.norg.dirman'] = { -- Manage your directories with Neorg
        config = {
          workspaces = {
            my = '~/Personal/neorg',
            example_gtd = '~/Projects/exws',
          },
          autodetect = true,
          autochdir = true,
        },
      },
      ['core.norg.completion'] = {
        config = {
          engine = 'nvim-cmp',
        },
      },
      ['core.norg.journal'] = {
        config = {
          workspace = 'my',
        },
      },
      ['core.gtd.base'] = {
        config = {
          -- workspace = 'my'
          workspace = 'example_gtd',
        },
      },
    },
  }
end

return M
