local function on_output(params, done)
  if not params.output then
    return done()
  end
  local iter = params.output:gmatch '(.-)\r?\n'
  local diagnostics = {}
  local line = iter()
  while line do
    local diagnostic = {
      source = 'languagetool', -- string, optional (defaults to "null-ls")
      severity = 2, -- 1 (error), 2 (warning), 3 (information), 4 (hint)
    }
    local _, _, row, col, rule =
      line:find 'Line (%d+), column (%d+), Rule ID: (%S+)'
    diagnostic.row = row
    diagnostic.end_row = row
    diagnostic.col = col
    diagnostic.rule = rule
    line = iter()
    local _, _, message = line:find 'Message: (.*)'
    diagnostic.message = message
    line = iter()
    local _, _, suggestions_string = line:find 'Suggestion: (.*)'
    if suggestions_string then
      local suggestions = {}
      for str in string.gmatch(suggestions_string, '([^; ]+)') do
        table.insert(suggestions, str)
      end
      diagnostic.suggestions = suggestions
    end
    line = iter() -- this line contains extract of the buffer, discarded
    line = iter()
    local _, end_col = line:find '%^+'
    diagnostic.end_col = end_col
    line = iter()
    if line then
      local _, _, more_info = line:find 'More info: (.*)'
      if more_info then
        diagnostic.more_info = more_info
        line = iter()
      end
    end
    if line == '' then
      line = iter()
    end
    table.insert(diagnostics, diagnostic)
  end
  return done(diagnostics)
end
