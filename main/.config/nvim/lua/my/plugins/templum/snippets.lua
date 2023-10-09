local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local isn = ls.indent_snippet_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local p = require('luasnip.extras').partial
local l = require('luasnip.extras').lambda
local fmt = require('luasnip.extras.fmt').fmt

local templates_dir = vim.env.HOME
  .. '/.config/nvim/lua/my/plugins/templum/litterals'

local function id(...)
  return ...
end

--- get filepath's title part
---@return string
local function title(cb)
  local name = vim.fn.expand '%:t:r'
  if cb then
    return cb(name)
  end
  return name
end

--- get current year
---@return string|osdate
local function year()
  return os.date '%Y'
end

--- get user name from git config
---@return string
local function git_name()
  local res
  local Job = require('plenary').job
  Job:new({
    command = 'git',
    args = { 'config', '--get', 'user.name' },
    cwd = os.getenv 'HOME',
    on_exit = function(j, _)
      res = j:result()[1] or 'name'
    end,
  }):sync()
  return res
end

local function li(n, cb, ...)
  local str = cb(...)
  return d(n, function()
    return sn(1, { i(1, str) })
  end, {})
end

--- create litteral snippet from file content (from templates_dir)
---@param filename string
local function from_file_raw(filename)
  filename = templates_dir .. '/' .. filename
  return {
    d(1, function()
      local res = {}
      for line in io.lines(filename) do
        table.insert(res, line)
      end
      return sn(1, t(res))
    end, {}, {}),
  }
end

local function from_file_fmt(filename, args, opts)
  filename = templates_dir .. '/' .. filename
  return {
    d(1, function()
      local h = io.open(filename)
      if not h then
        return
      end
      local raw = h:read '*a'
      h:close()
      return sn(1, fmt(raw, args or {}), opts)
    end, {}, {}),
  }
end

local function module(pattern)
  local filename = vim.fn.expand '%'
  return filename:match(pattern)
end

local function module_lua()
  local pattern = '(.+)_spec.lua$'
  local filename = vim.fn.expand '%'
  filename = filename:match 'lua/(.+)$' or filename
  filename = filename:match(pattern)
  filename = filename:gsub('/', '.')
  return filename
end

local chmod_x = require('khutulun').chmod_x

local function from_buf_title()
  return d(1, function()
    --[[ local title = vim.b.title or 'title' ]]
    local res = 'title' --TODO: get note title
    return sn(1, i(1, res), {})
  end, {}, {})
end

return {
  filetype = {
    lua = {
      t { 'local M = {}', '', '' },
      i(0),
      t { '', '', 'return M' },
    },
  },
  pattern = {
    {
      '/%.local/bin/.+%..+',
      {},
    },
    {
      '/%.local/bin/',
      {
        t '#!/usr/bin/env sh',
        t { '', '' },
        f(function()
          vim.cmd 'filetype detect'
          chmod_x()
          return ''
        end, {}),
      },
    },
    {
      '_spec%.lua$',
      {
        t "local M = require '",
        p(module_lua),
        t { "'", '', '' },
        i(1, '-- TODO:'),
      },
    },
    {
      '%.test%.ts$',
      {
        t 'import ',
        i(1, 'M'),
        t " from './",
        p(module, '(.+).test.ts$'),
        t { "';", '', '' },
        i(2, '// tests'),
      },
    },
    -- {
    --   '%.test%.tsx$',
    --   {
    --     fmt(
    --       [[
    --     import { describe, expect, it, vi } from "vitest";
    --     import { render, screen } from "@testing-library/react";
    --     import userEvent from "@testing-library/user-event";
    --     import { [] } from [];
    --
    --     describe("[]", async () => {
    --       const { container } = render(
    --         <[] />
    --       );
    --       it("should match snapshot", () => {
    --         expect(container).toMatchSnapshot();
    --       });
    --     });
    --       ]],
    --       {
    --         -- i(1, "Element"),
    --         p(raw_filename),
    --         -- i(2, "filepath"),
    --         p(quoted_filename),
    --         p(raw_filename),
    --         p(raw_filename),
    --         -- f(function(args)
    --         -- 	return args[1][1]
    --         -- end, { 1 }),
    --         -- f(function(args)
    --         -- 	return args[1][1]
    --         -- end, { 1 }),
    --       },
    --       {
    --         delimiters = '[]',
    --       }
    --     ),
    --   },
    -- },
    -- {
    --   '%.test%.jsx$',
    --   {
    --     t {
    --       "import React from 'react';",
    --       "import renderer from 'react-test-renderer';",
    --       'import ',
    --     },
    --     i(1, 'M'),
    --     t " from './",
    --     p(module, '(.+).test.jsx$'),
    --     t { "';", '', '' },
    --     i(2, '// tests'),
    --   },
    -- },
    -- {
    --   '%.test%.tsx$',
    --   {
    --     t {
    --       "import React from 'react';",
    --       "import renderer from 'react-test-renderer';",
    --       'import ',
    --     },
    --     i(1, 'M'),
    --     t " from './",
    --     p(module, '(.+).test.tsx$'),
    --     t { "';", '', '' },
    --     i(2, '// tests'),
    --   },
    -- },
    {
      ' - extra%.md$',
      {
        t { '# ' },
        from_buf_title(),
        --[[ i(1, 'title'), ]]
        t { ' - extra', '', '' },
      },
    },
  },
  filename = {
    ['hie.yaml'] = from_file_raw 'hie.yaml',
    ['log.lua'] = from_file_raw 'log.lua',
    ['.busted'] = from_file_raw '.busted',
    ['stylua.toml'] = from_file_fmt 'stylua.toml',
    ['selene.toml'] = from_file_fmt 'selene.toml',
    ['.eslintrc.js'] = from_file_raw '.eslintrc.js',
    ['.prettierrc.yaml'] = from_file_fmt '.prettierrc.yaml',
    ['LICENSE'] = from_file_fmt('LICENSE', {
      name = i(2, git_name()),
      year = i(1, year()),
    }),
    ['README.md'] = {
      t { '# ' },
      li(1, title),
      t { '', '', '' },
      i(2, '...'),
    },
  },
}
