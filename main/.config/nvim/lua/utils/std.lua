local M = {}

-- https://stackoverflow.com/questions/50459102/replace-accented-characters-in-string-to-standard-with-lua
local tableAccents = {}
tableAccents['À'] = 'A'
tableAccents['Á'] = 'A'
tableAccents['Â'] = 'A'
tableAccents['Ã'] = 'A'
tableAccents['Ä'] = 'A'
tableAccents['Å'] = 'A'
tableAccents['Æ'] = 'AE'
tableAccents['Ç'] = 'C'
tableAccents['È'] = 'E'
tableAccents['É'] = 'E'
tableAccents['Ê'] = 'E'
tableAccents['Ë'] = 'E'
tableAccents['Ì'] = 'I'
tableAccents['Í'] = 'I'
tableAccents['Î'] = 'I'
tableAccents['Ï'] = 'I'
tableAccents['Ð'] = 'D'
tableAccents['Ñ'] = 'N'
tableAccents['Ò'] = 'O'
tableAccents['Ó'] = 'O'
tableAccents['Ô'] = 'O'
tableAccents['Õ'] = 'O'
tableAccents['Ö'] = 'O'
tableAccents['Ø'] = 'O'
tableAccents['Ù'] = 'U'
tableAccents['Ú'] = 'U'
tableAccents['Û'] = 'U'
tableAccents['Ü'] = 'U'
tableAccents['Ý'] = 'Y'
tableAccents['Þ'] = 'P'
tableAccents['ß'] = 's'
tableAccents['à'] = 'a'
tableAccents['á'] = 'a'
tableAccents['â'] = 'a'
tableAccents['ã'] = 'a'
tableAccents['ä'] = 'a'
tableAccents['å'] = 'a'
tableAccents['æ'] = 'ae'
tableAccents['ç'] = 'c'
tableAccents['è'] = 'e'
tableAccents['é'] = 'e'
tableAccents['ê'] = 'e'
tableAccents['ë'] = 'e'
tableAccents['ì'] = 'i'
tableAccents['í'] = 'i'
tableAccents['î'] = 'i'
tableAccents['ï'] = 'i'
tableAccents['ð'] = 'eth'
tableAccents['ñ'] = 'n'
tableAccents['ò'] = 'o'
tableAccents['ó'] = 'o'
tableAccents['ô'] = 'o'
tableAccents['õ'] = 'o'
tableAccents['ö'] = 'o'
tableAccents['ø'] = 'o'
tableAccents['ù'] = 'u'
tableAccents['ú'] = 'u'
tableAccents['û'] = 'u'
tableAccents['ü'] = 'u'
tableAccents['ý'] = 'y'
tableAccents['þ'] = 'p'
tableAccents['ÿ'] = 'y'

function M.remove_accents(str)
  local normalisedString = str:gsub(
    '[%z\1-\127\194-\244][\128-\191]*',
    tableAccents
  )
  return normalisedString
end

local function remove_forbidden_chars(str)
  -- outmost parenthesis makes the function return the first value only
  return (str:gsub('["*/:<>?\\|]', ''))
end

function M.capitalize_first_letter(str)
  return str:sub(1, 1):upper() .. str:sub(2)
end

function M.remove_title_parts(title, opts)
  opts.words = opts.words or {}
  local words = {}
  for _, word in ipairs(opts.words or {}) do
    table.insert(words, word)
    table.insert(words, M.capitalize_first_letter(word))
  end
  local prefixes = {}
  for _, word in ipairs(opts.prefixes or {}) do
    table.insert(prefixes, word)
    table.insert(prefixes, M.capitalize_first_letter(word))
  end
  local ws = {}
  for _, w in ipairs(vim.split(title, ' ')) do
    if w ~= '' then
      if not vim.tbl_contains(words, w) then
        for _, p in ipairs(prefixes) do
          if vim.startswith(w, p) then
            w = w:sub(p:len() + 1)
          end
        end
        table.insert(ws, w)
      end
    end
  end
  title = table.concat(ws, ' ')
  title = remove_forbidden_chars(title)
  if opts.accents then
    title = M.remove_accents(title)
  end
  return title
end

function M.split_string(str, delimiter)
  local result = {}
  local from = 1
  local delim_from, delim_to = string.find(str, delimiter, from)
  while delim_from do
    table.insert(result, string.sub(str, from, delim_from - 1))
    from = delim_to + 1
    delim_from, delim_to = string.find(str, delimiter, from)
  end
  table.insert(result, string.sub(str, from))
  return result
end

function M.deep_merge(t1, t2)
  local offset = #t1
  for k, v in pairs(t2) do
    if (type(v) == 'table') and (type(t1[k] or false) == 'table') then
      M.deep_merge(t1[k], t2[k])
    elseif (type(k) == 'number') then
      t1[offset + k] = v
    else
      t1[k] = v
    end
  end
  return t1
end

function M.invert(tbl)
  local res = {}
  for key, value in pairs(tbl) do
    res[value] = key
  end
  return res
end

function M.reverse(t)
  local i = 1
  local j
  while true do
    j = #t + 1 - i
    if j <= i then
      break
    end
    t[i], t[j] = t[j], t[i]
    i = i + 1
  end
end

-- http://lua-users.org/wiki/StringRecipes
function M.encode_uri(str)
  if str then
    str = str:gsub('\n', '\r\n')
    str = str:gsub('([^%w %-%_%.%~])', function(c)
      return ('%%%02X'):format(string.byte(c))
    end)
    str = str:gsub(' ', '+')
  end
  return str
end

function M.file_exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

return M
