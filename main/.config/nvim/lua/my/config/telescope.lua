local M = {}

-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#performing-an-arbitrary-command-by-extending-existing-find_files-picker

-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#dont-preview-binaries
local buffer_preview_maker = function(filepath, bufnr, opts)
  filepath = vim.fn.expand(filepath)
  local Job = require 'plenary.job'
  Job:new({
    command = 'file',
    args = { '--mime-type', '-b', filepath },
    on_exit = function(j)
      local mime_type = vim.split(j:result()[1], '/')[1]
      if mime_type == 'text' or vim.endswith(filepath, 'json') then
        require 'telescope.previewers'.buffer_previewer_maker(filepath, bufnr, opts)
      else
        -- maybe we want to write something to the buffer here
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'BINARY' })
        end)
      end
    end,
  }):sync()
end

-- TODO: actions to delete and move cf. telescope file manager
local function current_dir_action()
  local action_state = require 'telescope.actions.state'
  local entry = action_state.get_selected_entry()
  if not entry then
    return
  end

  local raw = entry[1] -- entry.value.path
  local dir = vim.fn.fnamemodify(raw, ':h:p')
  if dir == '.' then
    dir = ''
  end
  dir = dir .. '/'
  require('my.config.binder.utils').keys('<c-u>' .. dir)
end

local function create_dir(new_dir)
  if vim.fn.isdirectory(new_dir) == 0 then
    local success, errormsg = pcall(vim.fn.mkdir, new_dir, 'p')
    if success then
      vim.notify(string.format('Created directory %q', new_dir))
    else
      vim.notify('Could not create directory: ' .. errormsg, log_error)
      return false
    end
  end
  return true
end

local function ensure_dir(target)
  local new_dir = vim.fn.fnamemodify(target, ':h')
  return create_dir(new_dir)
end

-- TODO: intercept telescope relative path
local function edit()
  local filepath = state.get_current_line()
  local bufnr = vim.api.nvim_win_get_buf(0)
  require 'telescope.actions'.close(bufnr)
  if not filepath then
    return
  end
  if ensure_dir(filepath) then
    vim.cmd.edit(filepath)
  end
end

function M.config()
  local telescope = require 'telescope'
  local util = require 'my.config.binder.utils'
  local lazy_req = util.lazy_req
  local actions = require 'telescope.actions'
  telescope.setup {
    defaults = {
      buffer_previewer_maker = buffer_preview_maker,
      mappings = {
        i = {
          ['<c-f>'] = current_dir_action,
          ['<c-cr>'] = edit,
          ['<c-a>'] = lazy_req('readline', 'beginning_of_line'),
          -- ['<c-f>'] = lazy_req('my.config.cmp', 'my.utils.confirm'),
          -- ['<c-q>'] = false, -- TODO: close
          ['<c-e>'] = lazy_req('readline', 'end_of_line'),
          ['<m-f>'] = lazy_req('readline', 'forward_word'),
          ['<c-k>'] = lazy_req('readline', 'kill_line'),
          ['<c-u>'] = lazy_req('readline', 'backward_kill_line'),
          ['<c-w>'] = lazy_req('readline', 'backward_kill_word'),
          ['<m-b>'] = lazy_req('readline', 'backward_word'),
          ['<m-d>'] = lazy_req('readline', 'kill_word'),
          ['<c-t>'] = function(...)
            require('trouble.providers.telescope').open_with_trouble(...)
            require('my.utils.windows').show_ui('Trouble', 'Trouble')
          end,
        },
        n = {
          ['qt'] = function(...)
            require('trouble.providers.telescope').open_with_trouble(...)
            require('my.utils.windows').show_ui('Trouble', 'Trouble')
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
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = 'smart_case',
      },
      repo = {
        list = {
          project_files = require('my.utils.open_project').open_project,
          fd_opts = {
            '--no-ignore-vcs',
            '--exclude',
            'node_modules',
            '--exclude',
            '0 archivés',
            '--max-depth',
            '4',
          },
          search_dirs = {
            vim.fn.getenv 'DOTFILES',
            vim.fn.getenv 'PROJECTS',
            vim.fn.getenv 'ZK_NOTEBOOK_DIR',
            -- '~/.local/share/nvim/site/pack',
            -- node modules
          },
        },
      },
      headings = {
        treesitter = true,
      },
      -- curently not in use
      frecency = {
        default_workspace = 'CWD',
        ignore_patterns = { '*.git/*', '*/tmp/*', 'node_modules/*' },
        show_unindexed = false,
        workspaces = {
          dot = require('my.parameters').dotfiles,
          vim = require('my.parameters').vim_conf,
          notes = vim.env.HOME .. 'Personal/neuron',
          data = vim.env.HOME .. '.local/share',
        },
      },
    },
  }

  require('telescope').load_extension 'fzf'
  pcall(function()
    require('telescope').load_extension 'noice'
  end)
  pcall(function()
    require('telescope').load_extension 'refactoring'
  end)
end

return M
