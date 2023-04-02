local M = {}

local url

function M.config()
  require('flies2').setup {
    hlslens = true,
    op = {
      wrap = {
        chars = require 'my.config.flies2.chars',
      },
    },
    queries = {
      b = require 'flies2.flies.brackets',
      c = require 'flies2.flies.char',
      e = require 'flies2.flies.buffer',
      i = require('flies2.flies._ts'):new { names = 'conditional' },
      j = require('flies2.flies._ts'):new { names = 'block' },
      k = require('flies2.flies._ts'):new { names = 'call' },
      l = require('flies2.flies._ts'):new { names = 'loop' },
      o = require('flies2.flies._ts'):new {
        names = 'argument',
        solid = true,
      },
      q = require 'flies2.flies.quote',
      Q = require('flies2.flies._ts'):new {
        names = 'string',
        no_tree = require 'flies2.flies.quote',
      },
      s = require('flies2.flies._ts'):new {
        names = { 'function', 'section' },
        op = {
          wrap = { snip = true },
        },
      },
      t = require('flies2.flies._ts'):new { names = 'tag' },
      v = require 'flies2.flies.variable_segment',
      w = require 'flies2.flies.word',
      ['<'] = require('flies2.flies.brackets'):new {
        left_patterns = { '<' },
        right_patterns = { '>' },
      },
      [' '] = require 'flies2.flies.bigword',
      ['.'] = require 'flies2.flies.dot_segment',
      ['<cr>'] = require 'flies2.flies.line',
      ['*'] = require('flies2.flies._ts'):new { names = 'comment' },
      ['é'] = require 'flies2.flies.search',
    },
    x = require('flies2.flies._ts'):new { names = 'class' },
    axis = {
      n = 'forward',
      p = 'backward',
      h = 'hint',
    },
    domains = {
      a = 'outer',
      f = 'right',
      g = 'left',
    },
  }
end

local function browse(url)
  print(url)
end

function M.url()
  url = url
    or require('flies2.operations.one_shot_subline'):new {
      {
        '([^%s/]+/[^%s/]+)',
        function(match)
          browse('https://www.github.com/' .. match.capture)
        end,
      },
      {
        -- url part of markdown link
        '%[[^%]]*%]%(([^%)]*)%)',
        function(match)
          browse(match.capture)
        end,
        ft = 'markdown',
      },
    }
  url:exec()
end

return M
