local M = {}

local group = vim.api.nvim_create_augroup('My_zk', {})

local pattern = vim.fn.getenv 'ZK_NOTEBOOK_DIR'
if not vim.endswith(pattern, '/') then
  pattern = pattern .. '/'
end
pattern = pattern .. '*'

local function is_subdir(dir, prefix)
  if dir == prefix then
    return true
  end
  if vim.startswith(dir, prefix .. '/') then
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

function M.is_in_zk(dir)
  -- TODO: other critarias
  if is_subdir(dir, vim.fn.getenv 'ZK_NOTEBOOK_DIR') then
    return true
  end
  return false
end

function M.make_note(raw)
  local dir = vim.fn.fnamemodify(raw, ':h:p')
  if dir == '.' then
    dir = ''
  end
  local title = vim.fn.fnamemodify(raw, ':t')
  M.make_note_(dir, title)
end

local function gen_id()
  local id = ''
  for _ = 1, 5 do
    id = id .. string.char(math.random(0x61, 0x74))
  end
  return id
end

function M.make_note_(dir, title)
  local file = title
  file = require('utils.std').remove_title_parts(title, {
    words = { 'the', 'a', 'le', 'la', 'les', 'de', 'du' },
    prefixes = { "d'", "l'" },
    accents = false,
  })
  local template
  -- TODO: remove after ':' etc.

  local ls = require 'luasnip'
  local i = ls.insert_node
  local t = ls.text_node
  local s = ls.snippet
  local fmt = require('luasnip.extras.fmt').fmt
  local data = {
    lang = 'en',
    date = os.date '%Y-%m-%d',
    tags = '',
    title = title,
  }
  if is_subdir_any(dir, { 'journal' }) then
    file = data.date
    local pre
    if is_subdir(dir, 'journal/d') then
      pre = 'daily '
    elseif is_subdir(dir, 'journal/w') then
      pre = 'weekly '
    elseif is_subdir(dir, 'journal/m') then
      pre = 'monthly '
    elseif is_subdir(dir, 'journal/y') then
      pre = 'yearly '
    else
      pre = ''
    end
    data.title = pre .. data.date
  end
  if is_subdir_any(dir, { 'tasks' }) then
    file = os.date '%Y%m%d%H%M' .. ' ' .. file
  end
  if is_subdir_any(dir, { 'tasks', 'projects', 'writing', 'inventory' }) then
    data.tags = 'w/backlog'
  end
  if is_subdir_any(dir, { 'topics' }) then
    data.lang = 'en'
  end
  if is_subdir_any(dir, { 'sources' }) then
    local res = vim.split(title, ' ')
    local author = res[1]
    if author == '' then
      author = 'unknown'
    end
    local issued = res[2]
    if not issued:find '^%d' then
      issued = os.date '%Y'
    end
    title = table.concat(res, ' ', 3)
    data.lang = 'en'
    local id = gen_id()
    file = author .. issued .. id .. ' ' .. title
    dump {
      res = res,
      author = author,
      date = issued,
      title = title,
      id = id,
      file = file,
    }
    template = template
      or fmt(
        [[
    ---
    lang: {lang}
    date: {date}
    tags: [{tags}]
    citation:
      title: {title}
      issued: {issued}
      authors:
        - family: {author}
          given: {given}
    id: {id}
    ---
    
    # {author} {issued} {title}

    {end_}
    ]],
        {
          lang = i(1, data.lang),
          date = data.date,
          tags = i(2, ''),
          title = title,
          issued = issued,
          author = author,
          given = i(3, ''),
          id = id,
          end_ = i(4, ''),
        }
      )
  end

  template = template
    or fmt(
      [[
  ---
  lang: {}
  date: {}
  tags: [{}]
  ---
  
  # {}

  {}
  ]],
      {
        i(2, data.lang),
        t(data.date),
        i(3, data.tags),
        t(data.title),
        i(1, ''),
      }
    )
  local path = file .. '.md'
  if dir ~= '' then
    path = dir .. '/' .. path
  end

  if vim.fn.filereadable(path) == 0 and vim.fn.isdirectory(path) == 0 then
    vim.api.nvim_create_autocmd('BufNewFile', {
      once = true,
      pattern = '*',
      callback = function()
        ls.snip_expand(s('', template))
      end,
    })
  end
  vim.cmd('edit ' .. path)
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
      local cwd = vim.fn.expand('%:p:h', nil, nil)
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
