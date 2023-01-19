local M = {}

local url

function M.config()
  require('flies2').setup {
    queries = {
      a = require('flies2.flies._ts'):new { name = 'argument', context = true },
      b = require 'flies2.flies.brackets',
      c = require 'flies2.flies.char',
      e = require 'flies2.flies.buffer',
      i = require('flies2.flies._ts'):new { name = 'conditional' },
      j = require('flies2.flies._ts'):new { name = 'block' },
      k = require('flies2.flies._ts'):new { name = 'call' },
      l = require('flies2.flies._ts'):new { name = 'loop' },
      Q = require 'flies2.flies.quote',
      q = require('flies2.flies._ts'):new {
        name = 'string',
        no_tree = require 'flies2.flies.quote',
      },
      s = require('flies2.flies._ts'):new { name = 'function' },
      t = require('flies2.flies._ts'):new { name = 'tag' },
      v = require 'flies2.flies.variable_segment',
      w = require 'flies2.flies.word',
      [' '] = require 'flies2.flies.bigword',
      ['<cr>'] = require 'flies2.flies.line',
      ['*'] = require('flies2.flies._ts'):new { name = 'comment' },
      ['é'] = require 'flies2.flies.search',
    },
    x = require('flies2.flies._ts'):new { name = 'class' },
    axis = {
      n = 'forward',
      p = 'backward',
      h = 'hint',
    },
    domains = {
      o = 'outer',
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
