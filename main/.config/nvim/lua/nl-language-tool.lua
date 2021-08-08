local Job = require 'plenary.job'
local null_ls = require 'null-ls'

local sample = {
  '1.) Line 5, column 3, Rule ID: MORFOLOGIK_RULE_EN_US prio=-10',
  'Message: Possible spelling mistake found.',
  'Suggestion: Vim; NVM; N vim',
  '# Nvim - TODO',
  '  ^^^^',
  '',
}

-- Dump(parse(sample))

function parse(lines)
  local next, l, i = ipairs(lines)
  local line
  local diagnostics = {}
  i, line = next(l, i)
  while line do
    local diagnostic = {
      source = 'languagetool',
      severity = 2,
    }
    local _, _, row, col, rule =
      line:find 'Line (%d+), column (%d+), Rule ID: (%S+) '
    -- print(line)
    -- print(row, col)
    if row and col then
      diagnostic.row = 0 + row
      diagnostic.col = 0 + col
      -- diagnostic.rule = rule
    end
    i, line = next(l, i)
    local _, _, message = line:find 'Message: (.*)'
    if message then
      diagnostic.message = message
      i, line = next(l, i)
    end
    local _, _, suggestions_string = line:find 'Suggestion: (.*)'
    if suggestions_string then
      -- local suggestions = {}
      -- for str in string.gmatch(suggestions_string, '([^; ]+)') do
      --   table.insert(suggestions, str)
      -- end
      -- diagnostic.suggestions = suggestions
      i, line = next(l, i)
    end
    -- line contains buffer extract; skipped
    i, line = next(l, i)
    local _, end_col = line:find '%^+'
    diagnostic.end_col = end_col - 1
    i, line = next(l, i)
    if line then
      local _, _, more_info = line:find 'More info: (.*)'
      if more_info then
        -- diagnostic.more_info = more_info
        i, line = next(l, i)
      end
    end
    if line == '' then
      i, line = next(l, i)
    end
    if row and col and message and end_col then
      table.insert(diagnostics, diagnostic)
    end
  end
  return diagnostics
end

local results = {}

local m = {}

m.dump = function()
  Dump(results)
end

m.refresh = function()
  local bufname = vim.fn.expand '%:p'
  Job
    :new({
      -- command = 'cat',
      -- args = { 'sample.txt' },
      command = 'languagetool',
      args = { '--autoDetect', '--line-by-line', '--disable', 'DASH_RULE', bufname },
      on_exit = function(j)
        local diagnostics = parse(j:result())
        results[bufname] = diagnostics
        print 'Refreshed'
      end,
    })
    :start()
end

-- TODO spaces in filenames
m.start_current_file = function()
  local bufname = vim.fn.expand '%:p'
  vim.cmd 'augroup NLLanguageTool'
  vim.cmd(
    string.format(
      "autocmd BufWritePost %s, lua require'nl-language-tool'.refresh()",
      bufname
    )
  )
  vim.cmd 'augroup END'
end

m.stop_current_file = function()
  local bufname = vim.fn.expand '%:p'
  vim.cmd 'augroup NLLanguageTool'
  vim.cmd(string.format('autocmd! * %s', bufname))
  vim.cmd 'augroup END'
  results[bufname] = nil
end

local fake = {

}

m.diagnostics = {
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = { 'markdown', 'txt' },
  generator = {
    fn = function(params)
      return results[params.bufname]
    end,
  },
}

return m
