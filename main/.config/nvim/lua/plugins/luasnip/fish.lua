local ls = require 'luasnip'

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local isn = ls.indent_snippet_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node

local count = 0
local function id()
  count = count + 1
  return string.format('%d', count)
end

local fish = {
  s({ trig = id(), dscr = 'test network' }, { t 'ping 1.1.1.1' }),
  s(
    { trig = id(), dscr = 'pacman: display package owing <file>' },
    { t 'pacman -Qo ', i(1, 'file') }
  ),
  s(
    { trig = id(), dscr = 'pacman: list files owned by <package>' },
    { t 'pacman -Ql ', i(1, 'package') }
  ),
  s(
    { trig = id(), dscr = 'pacman: remove <package>' },
    { t 'sudo pacman -R ', i(1, 'package') }
  ),
  s(
    { trig = id(), dscr = "khal: list week's events" },
    { t 'khal list now week' }
  ),
  s(
    { trig = id(), dscr = 'khal: create event' },
    { t 'khal new', i(1, 'date'), i(2, 'time'), i(3, 'description') }
  ),
  s(
    { trig = id(), dscr = 'remove broken symlinks' },
    { t 'find . -xtype l -delete' }
  ),
  s(
    { trig = id(), dscr = 'git: restore <file> to last commit' },
    { t 'git restore ', i(1, 'file') }
  ),
  s(
    { trig = id(), dscr = 'git: revert woking dir to last commit' },
    { t 'git reset --hard HEAD' }
  ),
  s(
    { trig = id(), dscr = 'git: clone with submodules' },
    { t 'git clone --recursive ', i(1, 'url') }
  ),
  s(
    { trig = id(), dscr = 'git: update submodules' },
    { t 'git submodule update --init --recursive', i(1, 'url') }
  ),
  s(
    { trig = id(), dscr = "git: find last file's commit" },
    { t 'git rev-list HEAD -- ', i(1, 'file'), t ' -n 1' }
  ),
}

return fish
