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

-- TODO: explore selection

local templates_dir = vim.env.HOME .. '/.config/nvim/snippets/templum'

local function title()
  local pat = vim.split(vim.fn.expand('%:p:h', nil, nil), '/')
  pat = pat[#pat]
  return pat
end

local function year()
  return os.date '%Y'
end

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

local function from_file_raw(filename)
  return {
    d(1, function()
      local res = {}
      filename = templates_dir .. '/' .. filename
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

local function quoted_filename()
  local source = vim.fn.expand '%:t'
  source = string.gsub(source, '(.test.)', '.')
  return string.format('%q', './' .. source)
end

local function raw_filename()
  local source = vim.fn.expand '%:t'
  source = string.gsub(source, '(.test.tsx)', '')
  return source
end

local function chmod_x()
  local filename = vim.fn.expand '%'
  local perm = vim.fn.getfperm(filename)
  local res = ''
  local r
  for j = 1, perm:len() do
    local char = perm:sub(j, j)
    if j % 3 == 1 then
      r = char == 'r'
    end
    if j % 3 == 0 and r then
      char = 'x'
    end
    res = res .. char
  end
  vim.fn.setfperm(filename, res)
end

local function from_buf_title()
  return d(1, function()
    --[[ local title = vim.b.title or 'title' ]]
    local title = 'title' --TODO: get note title
    return sn(1, i(1, title), {})
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
        t 'local ',
        i(1, 'M'),
        t " = require '",
        p(module, '(.+)_spec.lua$'),
        t { "'", '', '' },
        i(2, '-- tests'),
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
