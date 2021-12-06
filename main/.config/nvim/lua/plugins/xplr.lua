local M = {}

function M.setup()
  require('xplr').setup {
    ui = {
      border = {
        style = 'single',
        highlight = 'FloatBorder',
      },
      position = {
        row = '90%',
        col = '50%',
      },
      relative = 'editor',
      size = {
        width = '80%',
        height = '30%',
      },
    },
    previewer = {
      split = true,
      split_percent = 0.5,
      ui = {
        border = {
          style = 'single',
          highlight = 'FloatBorder',
        },
        position = { row = '1%', col = '99%' },
        relative = 'editor', -- editor only supported for now
        size = {
          width = '30%',
          height = '99%',
        },
      },
    },
    xplr = {
      open_selection = {
        enabled = true,
        mode = 'action',
        key = 'o',
      },
      preview = {
        enabled = true,
        mode = 'action',
        key = 'i',
        fifo_path = '/tmp/nvim-xplr.fifo',
      },
      set_nvim_cwd = {
        enabled = true,
        mode = 'action',
        key = 'j',
      },
      set_xplr_cwd = {
        enabled = true,
        mode = 'action',
        key = 'h',
      },
    },
  }
end

return M
