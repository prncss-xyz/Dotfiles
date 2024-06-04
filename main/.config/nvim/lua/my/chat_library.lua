local chats = require 'model.prompts.chats'

local M = {
  gtp3_5turbo = chats.openai,
  gpt4o = chats.gpt4,
  gemini = chats.gemini,
  llama = chats.groq,
  review = vim.tbl_extend('force', chats.gemini, {
    system = "You are an expert programmer that gives constructive feedback. Review the changes in the user's git diff.",
    create = function()
      local git_diff = vim.fn.system { 'git', 'diff', '--staged' }
      ---@cast git_diff string

      if not git_diff:match '^diff' then
        error('Git error:\n' .. git_diff)
      end
      return git_diff
    end,
  }),
  explain = vim.tbl_extend('force', chats.gemini, {
    system = 'You are an expert programmer. Explain the following code. Use markdown format.',
    create = function(input)
      local cursor = require('flies.utils.windows').get_cursor()
      local filetype =
        require('flies.utils.editor').get_vim_lang(0, { cursor, cursor })
      return string.format(
        [[
Code:
```%s
%s
```
        ]],
        filetype,
        input
      )
    end,
  }),
}

return M
