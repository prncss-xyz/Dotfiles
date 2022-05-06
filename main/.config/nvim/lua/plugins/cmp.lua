local M = {}

function M.config()
  if false then
    print 'not cmp'
    return
  end
  local cmp = require 'cmp'

  local symbolic = require('symbols').symbolic

  ---@diagnostic disable-next-line: redundant-parameter
  cmp.setup {
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    window = {
      documentation = true,
    },
    formatting = {
      format = function(_, vim_item)
        vim_item.kind = symbolic(vim_item.kind)
        vim_item.abbr = string.sub(vim_item.abbr, 1, 50)
        return vim_item
      end,
      sorting = {
        priority_weight = 10,
      },
    },
    experimental = {
      ghost_text = false,
    },
    sources = {
      { name = 'luasnip' },
      { name = 'fish' },
      { name = 'npm', keyword_length = 4 },
      { name = 'nvim_lua' },
      { name = 'nvim_lsp' },
      { name = 'path' },
      { name = 'buffer' },
    },
  }

  for _, f in ipairs { 'gitcommit', 'NeogitCommitMessage' } do
    cmp.setup.filetype(f, {
      { name = 'cmp_git' },
      { name = 'cmp-conventionalcommits' },
      { name = 'path' },
      { name = 'buffer' },
    })
  end

  for _, c in ipairs { '/', '?' } do
    cmp.setup.cmdline(c, {
      { name = 'cmp-cmdline-history' },
      { name = 'buffer' },
    })
  end
  -- input commandline
  cmp.setup.cmdline('@', {
    { name = 'cmp-cmdline-history' },
    { name = 'buffer' },
  })
  cmp.setup.cmdline(':', {
    sources = {
      { name = 'cmp-cmdline-history' },
      { name = 'cmdline' },
      { name = 'path' },
    },
  })
end

local U = {}

M.utils = U

function U.toggle()
  local cmp = require 'cmp'
  if cmp.visible() then
    cmp.close()
  else
    cmp.complete() -- not working
  end
end

-- function U.up()
--   local cmp = require 'cmp'
--   if cmp.visible() then
--     cmp.select_prev_item()
--     return
--   end
--   vim.fn.feedkeys(require('utils').t '<up>', '')
-- end

function U.confirm()
  local cmp = require 'cmp'
  if cmp.visible() then
    cmp.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }
    return true
  end
end

return M
