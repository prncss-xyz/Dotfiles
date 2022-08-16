local M = {}

local group = vim.api.nvim_create_augroup('My_zk', {})

local path_separator = '/'

local pattern = vim.fn.getenv 'ZK_NOTEBOOK_DIR'
if not vim.endswith(pattern, path_separator) then
  pattern = pattern .. path_separator
end
pattern = pattern .. '*'

local function is_subdir(dir, prefix)
  if dir == prefix then
    return true
  end
  if vim.startswith(dir, prefix .. path_separator) then
    return true
  end
  return false
end

local function is_subdir_any(dir, prefixes)
  for _, prefix in ipairs(prefixes) do
    if is_subdir(dir, prefix) then
      return true
    end
  end
  return false
end

local function rel(dir, path)
  if not vim.endswith(dir, path_separator) then
    dir = dir .. path_separator
  end
  if not vim.startswith(path, dir) then
    return
  end
  local len = dir:len()
  return path:sub(1, len - 1), path:sub(len + 1)
end

---@param bufnr number?
---@return string? path inside a notebook
local function resolve_notebook_path_from_dir(path, cwd)
  -- if the buffer has no name (i.e. it is empty), set the current working directory as it's path
  if not path or path == '' then
    path = cwd
  end
  if not require('zk.util').notebook_root(path) then
    if not require('zk.util').notebook_root(cwd) then
      -- if neither the buffer nor the cwd belong to a notebook, use $ZK_NOTEBOOK_DIR as fallback if available
      if vim.env.ZK_NOTEBOOK_DIR then
        path = vim.env.ZK_NOTEBOOK_DIR
      end
    else
      -- the buffer doesn't belong to a notebook, but the cwd does!
      path = cwd
    end
  end
  -- at this point, the buffer either belongs to a notebook, or everything else failed
  return path
end

function M.update_title_void()
  local succ, title = pcall(vim.api.nvim_buf_get_var, 0, 'title')
  if succ and title == '' then
    M.update_title()
  end
end

function M.update_title()
  local fullPath = vim.api.nvim_buf_get_name(0)
  local dir, path
  if vim.fn.getenv 'ZK_NOTEBOOK_DIR' then
    dir, path = rel(vim.fn.getenv 'ZK_NOTEBOOK_DIR', fullPath)
  end
  if dir then
    vim.b.title = ''
    require('zk.api').list(dir, {
      select = { 'title' },
      hrefs = { path },
      limit = 1,
    }, function(err, notes)
      if err then
        print('Error querying notes ' .. vim.inspect(err))
        return
      end
      if notes[1] then
        vim.b.title = notes[1].title
      else
        vim.b.title = nil
      end
    end)
  end
end

function M.open_asset()
  local zk_dir = vim.fn.getenv 'ZK_NOTEBOOK_DIR'
  local dir = zk_dir .. '/sources'
  local f = vim.fn.expand '%:p'
  if is_subdir(f, dir) then
    local id = f:sub(dir:len() + 2)
    require('plenary.job')
      :new({
        command = 'zk-bib',
        args = { 'asset', id },
        on_exit = function(j, return_val)
          if return_val == 0 then
            local path = zk_dir .. '/' .. j:result()[1]
            require('plenary.job')
              :new({
                command = 'xdg-open',
                args = { path },
              })
              :start()
          end
        end,
      })
      :start()
  end
end

function M.remove_asset()
  local zk_dir = vim.fn.getenv 'ZK_NOTEBOOK_DIR'
  local dir = zk_dir .. '/sources'
  local f = vim.fn.expand '%:p'
  if is_subdir(f, dir) then
    local id = f:sub(dir:len() + 2)
    require('plenary.job')
      :new({
        command = 'zk-bib',
        args = { 'asset', id },
        on_exit = function(j, return_val)
          if return_val == 0 then
            local path = zk_dir .. '/' .. j:result()[1]
            vim.ui.input(
              string.format('Do you really want to remove %q? (y/N)', path),
              function(res)
                if res == 'y' then
                  os.remove(path)
                  vim.notify(string.format('File %q deleted', path))
                end
              end
            )
          end
        end,
      })
      :start()
  end
end

function M.setup_autocommit()
  -- Autocommit zettelkasten on every write
  -- if you are using an autocommand to save, make sure it uses
  -- `nested = true` option for this autocommand to be triggered
  vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = pattern,
    group = group,
    callback = function()
      -- we cannot assume vim.getcwd is current buffer's directory
      local cwd = vim.fn.expand '%:p:h'
      local job = require('plenary').job
      vim.defer_fn(function()
        job
          :new({
            command = 'git',
            args = { 'add', '--all' },
            cwd = cwd,
            on_exit = function()
              job
                :new({
                  command = 'git',
                  args = { 'commit', '--allow-empty-message', '-m', '' },
                  cwd = cwd,
                })
                :start()
            end,
          })
          :start()
      end, 0)
    end,
  })
end

local function correct_range(range)
  range['end'].character = range['end'].character + 1
end

-- TODO: ui.select dir instead of input
-- TODO: change to a range code action
function M.new_note_from_content()
  local zk_util = require 'zk.util'
  local location = zk_util.get_lsp_location_from_selection()
  correct_range(location.range)
  local selected_text = zk_util.get_text_in_range(location.range)
  -- exit selection mode
  require('plugins.binder.utils').keys '<esc>'
  vim.ui.input({ prompt = 'note title' }, function(title)
    if title ~= '' then
      local dir = vim.fn.expand '%:h'
      title = vim.fn.expand '%:t'
      vim.defer_fn(function()
        require('zk').new {
          dir = dir,
          title = title,
          content = selected_text,
          insertLinkAtLocation = location,
        }
      end, 0)
    end
  end)
end

function M.new_note_with_title()
  local zk_util = require 'zk.util'
  local location = zk_util.get_lsp_location_from_selection()
  correct_range(location.range)
  local selected_text = zk_util.get_text_in_range(location.range)
  -- local selected_text = require 'utils.vim'.get_selection()
  -- exit selection mode
  require('plugins.binder.utils').keys '<esc>'
  -- TODO: last value as default
  vim.ui.input({ prompt = 'note dir', default = 'topics' }, function(dir)
    if dir ~= '' then
      vim.defer_fn(function()
        require('zk').new {
          notebook_path = vim.fn.expand '%',
          dir = 'topics',
          title = selected_text,
          insertLinkAtLocation = location,
        }
      end, 0)
    end
  end)
end

return M
