---@diagnostic disable: undefined-global

-- these snippets are meant to be accessed through benfowler/telescope-luasnip.nvim

return {
  s('set keyboard layout', { t 'loadkeys ', i(1, 'cf') }),
  s('set symtem time date', { t 'sudo ntpd -qg; sudo hwclock -w' }),
  s('network: ping', { t 'ping 1.1.1.1' }),
  s('pacman: list unused dependencies', { t 'pacman -Qdt' }),
  s('pacman: remove unused dependencies', { t 'pacman -Rsn $(pacman -Qdtq)' }),
  s('pacman: update keyring', { t 'pacman -S archlinux-keyring' }),
  s('pacman: display package owing <file>', { t 'pacman -Qo ', i(1, 'file') }),
  s(
    'pacman: list files owned by <package>',
    { t 'pacman -Ql ', i(1, 'package') }
  ),
  s('pacman: remove <package>', { t 'sudo pacman -R ', i(1, 'package') }),
  s('pacman: downgrade <package>', {
    t 'sudo pacman -U file:///var/cache/pkg/',
    i(1, 'package'),
    t '.pkg.tar.zst',
  }),
  s('neovim: minimal config', { t 'nvim -u ~/.config/nvim/minimal.lua ' }),
  s("khal: list week's events", { t 'khal list now week' }),
  s(
    'khal: create event',
    { t 'khal new', i(1, 'date'), i(2, 'time'), i(3, 'description') }
  ),
  s('remove broken symlinks', { t 'find . -xtype l -delete' }),
  s('git: undo last commit', { t 'git reset HEAD~' }),
  s('git: restore <file> to last commit', { t 'git restore ', i(1, 'file') }),
  s(
    'git: restore <file> to commit',
    { t 'git checkout ', i(1, 'commit'), t ' -- ', i(2, 'files') }
  ),
  s('git: revert woking dir to last commit', { t 'git reset --hard HEAD' }),
  s('git: clone with submodules', { t 'git clone --recursive ', i(1, 'url') }),
  s(
    'git: update submodules',
    { t 'git submodule update --init --recursive', i(1, 'url') }
  ),
  s("git: find last file's commit", {
    t 'git rev-list HEAD -- ',
    i(1, 'file'),
    t ' -n 1',
  }),
  s(
    'git: create branch and checkout',
    { t 'git checkout -b ', i(1, 'branch') }
  ),
  s('gh: create repo in sync', {
    t 'gh repo create --private --license MIT --clone --gitignore ',
    i(1, 'Node'),
    i(2, 'zk-bib'),
  }),
  s('systemd: import environment', {
    t 'systemctl --user import-environment',
  }),
}
