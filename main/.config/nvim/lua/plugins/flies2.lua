local M = {}

local url

function M.config()
  require('flies2').setup {
    queries = {
      b = require 'flies2.flies.brackets',
      c = require 'flies2.flies.char',
      e = require 'flies2.flies.buffer',
      q = require 'flies2.flies.quote',
      t = require 'flies2.flies.tags',
      v = require 'flies2.flies.variable_segment',
      w = require 'flies2.flies.word',
      [' '] = require 'flies2.flies.bigword',
      ['<cr>'] = require 'flies2.flies.line',
    },
    axis = {
      n = 'forward',
      p = 'backward',
      h = 'hop',
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
