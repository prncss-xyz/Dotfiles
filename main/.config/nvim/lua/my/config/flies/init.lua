local M = {}

local url

function M.config()
  require('flies').setup {
    hlslens = true,
    op = {
      wrap = {
        chars = require 'my.config.flies.chars',
      },
    },
    hint_keys = 'asdfjkl;ghqweruiopzxcvm,étybn', -- '.'
    mappings = {
      a = 'toggle',
      b = require 'flies.flies.brackets',
      c = require 'flies.flies.char_to_any',
      d = require 'flies.flies.line',
      e = require 'flies.flies.buffer',
      f = 'right',
      g = 'left',
      h = 'hint',
      i = require('flies.flies._ts'):new { names = 'conditional' },
      j = require('flies.flies._ts'):new { names = 'block' },
      k = require('flies.flies._ts'):new { names = 'call' },
      l = require('flies.flies._ts'):new { names = 'loop' },
      m = 'first',
      n = 'forward',
      O = require('flies.flies._ts'):new {
        names = 'argument',
        nested = false,
        many = false,
      },
      o = require('flies.flies._ts_'):new {
        names = 'argument',
        nested = false,
        many = true,
      },
      p = 'backward',
      q = require 'flies.flies.quote',
      Q = require('flies.flies._ts'):new {
        names = 'string',
        no_tree = require 'flies.flies.quote',
        nested = true,
      },
      -- r =
      s = require('flies.flies._ts'):new {
        names = { 'function', 'section' },
        op = {
          wrap = { snip = true },
        },
      },
      t = require('flies.flies._ts'):new { names = 'tag' },
      -- u ...........................................
      v = require 'flies.flies.variable_segment',
      w = require 'flies.flies.word',
      x = require 'flies.flies.dot_segment',
      -- y =
      -- z =
      ['<'] = require('flies.flies.brackets'):new {
        left_patterns = { '<' },
        right_patterns = { '>' },
      },
      ['$'] = 'last',
      [' '] = require 'flies.flies.bigword',
      ['*'] = require('flies.flies._ts'):new {
        names = 'comment',
        nested = false,
      },
      ['é'] = require 'flies.flies.search',
    },
  }
end

local function browse(url_)
  local Job = require 'plenary.job'
  Job:new({
    command = 'open',
    args = { url_ },
  }):sync()
end

function M.url()
  url = require('flies.operations.one_shot_subline'):new {
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
