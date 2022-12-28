local M = {}

local std = require 'utils.std'

-- see also: https://github.com/rgroli/other.nvim

-- TODO: patterns based on filetype

local config = {
  alternatives = {
    test = {
      create = true,
      patterns = {
        { '(.+)%_spec(%.[%w%d]+)$', '%1%2' },
        { '(.+)%.test(%.[%w%d]+)$', '%1%2' },
        { '(.+)%.ts', '%1.test.tsx' },
        { '(.+)%.test.tsx', '%1.ts' },
        { '(.+)%.tsx', '%1.test.ts' },
        { '(.+)%.test.ts', '%1.tsx' },
        { '(.+)%.lua$', '%1_spec.lua' },
        { '(.+) %- extra%.md$', '%1.md' },
        { '(.+)%.md$', '%1 - extra.md' },
        { '(.+)(%.[%w%d]+)$', '%1.test%2' },
      },
    },
    snapshot = {
      create = false,
      patterns = {
        { '(.+)/(.+)', '%1/__snapshots__/%2.snap' },
        { '(.+)/__snapshots__/(.+)%.snap', '%1/%2' },
      },
    },
    css = {
      create = true,
      patterns = {
        { '(.+)%.tsx', '%1.css.tsx' },
        { '(.+)%.css.tsx', '%1.tsx' },
      },
    },
    playground = {
      create = true,
      patterns = {
        { '.+%.(.+)$', '_my_/playground.%1' },
      },
    },
    textobjects = {
      create = true,
      patterns = {
        {
          '.+%.(.+)$',
          require('parameters').vim_conf .. '/queries/%1/textobjects.scm',
        },
      },
    },
    snippets = {
      create = true,
      patterns = {
        {
          '.+%.(.+)$',
          function(ext)
            if ext == 'jsx' or ext == 'ts' or ext == 'tsx' then
              ext = 'js'
            end
            return string.format(
              '%s/snippets/luasnip/%s.lua',
              require('parameters').vim_conf,
              ext
            )
          end,
        },
      },
    },
  },
  projections = {
    config = {
      files = {
        'package.json',
      },
    },
  },
}

local function edit(file)
  vim.cmd { cmd = 'edit', args = { file } }
end

local function get_alternative(patterns, file)
  local match
  for _, pattern in ipairs(patterns) do
    if file:match(pattern[1]) then
      local target = file:gsub(pattern[1], pattern[2])
      if std.file_exists(target) then
        return target, true
      end
      match = match or target
    end
  end
  return match, false
end

function M.alternative(key)
  local entry = config.alternatives[key]
  local target, doesExists = get_alternative(entry.patterns, vim.fn.expand '%')
  if entry.create or doesExists then
    if entry.cb then
      entry.cb(target)
    else
      edit(target)
    end
  end
end

local function get_projection(files, file)
  local match
  for _, file_ in ipairs(files) do
    if std.file_exists(file_) then
      return file_, true
    end
    match = match or file_
  end
  return match, false
end

function M.projection(key)
  local entry = config.projections[key]
  local target, doesExists = get_projection(entry.files, vim.fn.expand '%')
  if entry.create or doesExists then
    if entry.cb then
      entry.cb(target)
    else
      edit(target)
    end
  end
end

return M
