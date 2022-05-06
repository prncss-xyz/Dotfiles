---@diagnostic disable: undefined-global

-- these snippets are meant to be accessed through benfowler/telescope-luasnip.nvim

return {
  s(
    { trig = '', dscr = 'change keyboard layout' },
    { t 'loadkeys ', i(1, 'cf') }
  ),
  s({ trig = 'network: ping', dscr = 'network: ping' }, { t 'ping 1.1.1.1' }),
  s(
    { trig = '', dscr = 'pacman: update keyring' },
    { t 'pacman -S archlinux-keyring' }
  ),
  s(
    { trig = '', dscr = 'pacman: display package owing <file>' },
    { t 'pacman -Qo ', i(1, 'file') }
  ),
  s(
    { trig = '', dscr = 'pacman: list files owned by <package>' },
    { t 'pacman -Ql ', i(1, 'package') }
  ),
  s(
    { trig = '', dscr = 'pacman: remove <package>' },
    { t 'sudo pacman -R ', i(1, 'package') }
  ),
  s(
    { trig = '', dscr = "khal: list week's events" },
    { t 'khal list now week' }
  ),
  s(
    { trig = '', dscr = 'khal: create event' },
    { t 'khal new', i(1, 'date'), i(2, 'time'), i(3, 'description') }
  ),
  s(
    { trig = '', dscr = 'remove broken symlinks' },
    { t 'find . -xtype l -delete' }
  ),
  s({ trig = 'git undo', dscr = 'undo last commit' }, { t 'git reset HEAD~' }),
  s(
    { trig = '', dscr = 'git: restore <file> to last commit' },
    { t 'git restore ', i(1, 'file') }
  ),
  s(
    { trig = '', dscr = 'git: restore <file> to commit' },
    { t 'git checkout ', i(1, 'commit'), t ' -- ', i(2, 'files') }
  ),
  s(
    { trig = '', dscr = 'git: revert woking dir to last commit' },
    { t 'git reset --hard HEAD' }
  ),
  s(
    { trig = '', dscr = 'git: clone with submodules' },
    { t 'git clone --recursive ', i(1, 'url') }
  ),
  s(
    { trig = '', dscr = 'git: update submodules' },
    { t 'git submodule update --init --recursive', i(1, 'url') }
  ),
  s(
    { trig = '', dscr = "git: find last file's commit" },
    { t 'git rev-list HEAD -- ', i(1, 'file'), t ' -n 1' }
  ),
  s(
    { trig = '', dscr = 'git: create branch and checkout' },
    { t 'git checkout -b ', i(1, 'branch') }
  ),
}
