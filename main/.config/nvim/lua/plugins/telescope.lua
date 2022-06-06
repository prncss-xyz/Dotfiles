local M = {}

-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#performing-an-arbitrary-command-by-extending-existing-find_files-picker
local previewers = require 'telescope.previewers'
local Job = require 'plenary.job'
local buffer_preview_maker = function(filepath, bufnr, opts)
  filepath = vim.fn.expand(filepath, nil, nil)
  Job
    :new({
      command = 'file',
      args = { '--mime-type', '-b', filepath },
      on_exit = function(j)
        local mime_type = vim.split(j:result()[1], '/')[1]
        if mime_type == 'text' then
          previewers.buffer_previewer_maker(filepath, bufnr, opts)
        else
          -- maybe we want to write something to the buffer here
          vim.schedule(function()
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'BINARY' })
          end)
        end
      end,
    })
    :sync()
end

local termviewer = 'catimg'

local function mime_hook(filepath, bufnr, opts)
  local is_image = function(filepath)
    local image_extensions = { 'png', 'jpg' } -- Supported image formats
    local split_path = vim.split(filepath:lower(), '.', { plain = true })
    local extension = split_path[#split_path]
    return vim.tbl_contains(image_extensions, extension)
  end
  if is_image(filepath) then
    local term = vim.api.nvim_open_term(bufnr, {})
    local function send_output(_, data, _)
      for _, d in ipairs(data) do
        vim.api.nvim_chan_send(term, d .. '\r\n')
      end
    end
    vim.fn.jobstart({
      termviewer,
      filepath, -- Terminal image viewer command
    }, { on_stdout = send_output, stdout_buffered = true })
  else
    require('telescope.previewers.utils').set_preview_message(
      bufnr,
      opts.winid,
      'Binary cannot be previewed'
    )
  end
end

function M.config()
  local telescope = require 'telescope'
  local actions = require 'telescope.actions'
  telescope.setup {
    defaults = {
      -- buffer_previewer_maker = buffer_preview_maker,
      preview = {
        mime_hook = mime_hook,
      },
      mappings = {
        i = {
          ['<c-q>'] = actions.send_to_qflist,
          ['<c-t>'] = function(...)
            require('trouble.providers.telescope').open_with_trouble(...)
          end,
          ['<c-u>'] = false,
        },
        n = {
          ['qq'] = actions.send_to_qflist,
          ['qt'] = function(...)
            require('trouble.providers.telescope').open_with_trouble(...)
          end,
          ['qh'] = actions.file_split,
          ['qv'] = actions.file_vsplit,
          ['qd'] = function(prompt_bufnr)
            local selection =
              require('telescope.actions.state').get_selected_entry()
            local dir = vim.fn.fnamemodify(selection.path, ':p:h')
            require('telescope.actions').close(prompt_bufnr)
            -- Depending on what you want put `cd`, `lcd`, `tcd`
            vim.cmd(string.format('silent lcd %s', dir))
          end,
        },
      },
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
        '--hidden',
      },
      color_devicons = true,
      file_ignore_patterns = {
        '.git/*',
        'node_modules/*',
      },
    },
    extensions = {
      cheat = {
        mappings = {},
      },
      -- curently not in use
      frecency = {
        default_workspace = 'CWD',
        ignore_patterns = { '*.git/*', '*/tmp/*', 'node_modules/*' },
        show_unindexed = false,
        workspaces = {
          dot = vim.g.dotfiles,
          vim = vim.g.vim_dir,
          notes = vim.env.HOME .. 'Personal/neuron',
          data = vim.env.HOME .. '.local/share',
        },
      },
    },
  }
end

return M
