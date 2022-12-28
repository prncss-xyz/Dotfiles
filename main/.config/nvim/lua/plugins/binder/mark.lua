local M = {}

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local modes = binder.modes
  local util = require 'plugins.binder.utils'
  local np = util.np
  local lazy_req = util.lazy_req
  return keys {
    b = keys {
      -- prev = b { '<Plug>(Marks-next-bookmark)' },
      -- next = b {
      --   function()
      --     require('marks').bookmark_state:all_to_list 'quickfixlist'
      --     require('telescope.builtin').quickfix()
      --   end,
      -- },
      -- [a.mark] = {
      --   ['pp' .. a.mark] = plug {
      --     '(Marks-deletebuf)',
      --     name = 'Deletes all marks in current buffer.',
      --   },
      --   ['p' .. a.mark] = plug {
      --     '(Marks-deleteline)',
      --     name = 'Deletes all marks on current line.',
      --   },
      -- },
      -- a = require('utils').bookmark_next(0),
      -- s = require('utils').bookmark_next(1),
      -- d = require('utils').bookmark_next(2),
      -- f = require('utils').bookmark_next(3),
      -- b = plug '(Marks-prev-bookmark)',
      next = b {
        b = {
          '<cmd>rshada<cr><Plug>(Marks-delete-bookmark)<cmd>wshada!<cr>',
        },
      },
      a = b { '<Plug>(Marks-set-bookmark0)' },
      s = b { '<Plug>(Marks-set-bookmark1)' },
      d = b { '<Plug>(Marks-set-bookmark2)' },
      f = b { '<Plug>(Marks-set-bookmark3)' },
    },
    o = keys {
      prev = b { 'zO', desc = 'open current fold recursive' },
      next = b { 'zo', desc = 'open current fold' },
    },
    c = keys {
      prev = b { 'zC', desc = 'close current fold recursive' },
      next = b { 'zc', desc = 'close current fold' },
    },
    a = keys {
      prev = b { 'zA', desc = 'toggle current fold recursive' },
      next = b { 'za', desc = 'toggle current fold' },
    },
    m = keys {
      prev = b { 'zM', desc = 'close all folds' },
      next = b { 'zm', desc = 'more fold' },
    },
    r = keys {
      prev = b { 'zR', desc = 'open all folds' },
      next = b { 'zr', desc = 'less folds' },
    },
    t = b {
      desc = 'FoldToggle (markdown)',
      ':FoldToggle<cr>',
    },
    l = b {
      function()
        if not vim.g.secret then
          vim.fn.feedkeys(
            t '<cmd>rshada<cr><Plug>(Marks-toggle)<cmd>wshada!<cr>',
            'm'
          )
        end
      end,
      desc = 'toggle next available mark at cursor',
    },
  }

  --[[
        '<Plug>(Marks-next)',
      pl = plug {
        '(Marks-delete)',
        desc = 'Delete a letter mark (will wait for input).',
      },
      l = plug {
        '(Marks-set)',
        desc = 'Sets a letter mark (will wait for input).',
      },
      prev = b {
        '<Plug>(Marks-set)',
      },
      next = b {
        function()
          require('marks').mark_state:all_to_list 'quickfixlist'
          require('telescope.builtin').quickfix()
        end,
      },
        l = plug { '(Marks-prev)', name = 'Goes to previous mark in buffer.' },
  --]]
end

return M
