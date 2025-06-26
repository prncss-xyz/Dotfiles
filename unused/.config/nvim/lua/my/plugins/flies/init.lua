return {
  {
    dir = require('my.utils').local_repo 'flies.nvim',
    enabled = true,
    config = function()
      require('flies').setup {
        hlslens = true,
        op = {
          wrap = {
            chars = require 'my.plugins.flies.chars',
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
          h = require 'flies.flies.hunk',
          i = require('flies.flies._ts'):new { names = 'conditional' },
          j = require('flies.flies._ts'):new { names = 'block' },
          k = require('flies.flies._ts'):new { names = 'call' },
          l = require('flies.flies._ts'):new { names = 'loop' },
          m = 'first',
          n = 'forward',
          o = require('flies.flies._ts'):new {
            names = 'argument',
            use_context = true,
            ctx_pre = false,
          },
          p = 'backward',
          q = require 'flies.flies.quote',
          Q = require('flies.flies._ts'):new {
            names = 'string',
            no_tree = require 'flies.flies.quote',
            nested = true,
          },
          r = require 'flies.flies.number',
          s = 'hint',
          t = require('flies.flies._ts'):new { names = 'tag' },
          -- u ...........................................
          v = require 'flies.flies.variable_segment',
          w = require 'flies.flies.word',
          x = require 'flies.flies.dot_segment',
          y = require('flies.flies._ts'):new {
            names = { 'function', 'section' },
            op = {
              wrap = { snip = true },
            },
          },
          z = require 'flies.flies.diagnostic',
          ['<'] = require('flies.flies.brackets'):new {
            left_patterns = { '<' },
            right_patterns = { '>' },
          },
          ['$'] = 'last',
          [' '] = require 'flies.flies.bigword',
          ['*'] = require('flies.flies._ts'):new {
            names = 'comment',
            nested = false,
            lonely_wiseness_inner = 'v',
            lonely_wiseness_outer = 'V',
          },
          ['é'] = require 'flies.flies.search',
          -- ['<tab>']
        },
      }
    end,
  },
}
