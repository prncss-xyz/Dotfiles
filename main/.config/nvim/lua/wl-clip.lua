local m = {}

-- luarocks install lua-iconv

local sql = require 'sql'
local ffi = require 'ffi'
local iconv = require 'iconv'
local cd = iconv.new('ascii', 'utf-8')

local dbpath = (os.getenv 'XDG_DATA_HOME' or os.getenv 'HOME')
  .. '/.local/share/wl-clipboard-manager/history.db'
local db = sql:open(dbpath)
-- local t = db:table('sqlite_sequence', { nocache = true })
-- local q = t:get {
--   select = { 'seq' },
--   where = { name = 'entries' },
-- }
-- local last_paste = q[1].seq

local entries = db:table('entries', { nocache = true })

local function nth(n)
  local e = entries:get {
    select = { 'id', 'contents', 'mime' },
    -- contains = { mime = 'text%' },
    order_by = {
      desc = 'id',
    },
    limit = { 1, n - 1 },
  }
  local r = e[1]
  if r and r.mime == 'application/json' or r.mime:match '^text/' then
    print(r.id)
    local str = ffi.string(r.contents)
    local nstr, err = cd:iconv(str)
    return nstr
  end
  return ''
end

print(nth(1))

return m

-- if [[ "$mime" == "application/json" || "$mime" == text/* ]]; then
--     sed -i -Ez 's/\s+$//' "$file"
