local M = {}

--[[
local background_active = diff_add.fg
local background_inactive = diff_change.fg
local text = vim.g.terminal_color_7
]]

function M.config()
  require('lualine').setup {
    options = {
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      always_divide_middle = false,
      globalstatus = true,
    },
    sections = {
      lualine_a = { require 'my.utils.uiline.file' },
      lualine_b = { require 'my.utils.uiline.aerial' },
      lualine_c = {},
      lualine_x = { require 'my.utils.uiline.overseer' },
      -- lualine_x = { 'overseer' },
      lualine_y = { require 'my.utils.uiline.coordinates' },
      lualine_z = {},
    },
    -- tabline = {
    --   lualine_a = {
    --     {
    --       'buffers',
    --       show_modified_status = false,
    --       max_length = function()
    --         return vim.o.columns -- block
    --       end,
    --     },
    --   },
    -- },
  }
end

return M
