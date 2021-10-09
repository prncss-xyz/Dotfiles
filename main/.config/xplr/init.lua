version = '0.14.4'
package.path = os.getenv 'HOME' .. '/.config/xplr/plugins/?.xplr/src/init.lua'
require('fzf').setup()
require('comex').setup { compress_key = 'c', extract_key = 'x' }
require('preview-tabbed').setup {
  mode = 'action',
  key = 'p',
  fifo_path = '/tmp/xplr.fifo',
  previewer = 'preview-tui',
}
require('xargs').setup()
require('trash-cli').setup()
-- require('type-to-nav').setup()
require('icons').setup()

-- local utils = require 'utils'

-- TODO merge arrays
local function deep_merge(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == 'table') and (type(t1[k] or false) == 'table') then
      deep_merge(t1[k], t2[k])
    elseif type(v) == 'function' then
      t1[k] = v(k, t1[k])
    else
      t1[k] = v
    end
  end
  return t1
end

local function nop() end
local reg = {}
local function register(message)
  return function(key)
    reg[message] = key
  end
end

local xplr = xplr

-- TODO find actual message
local shell = xplr.config.modes.builtin.action.key_bindings.on_key['!'].messages
local search =
  xplr.config.modes.builtin.default.key_bindings.on_key['/'].messages
local copy_here =
  xplr.config.modes.builtin.selection_ops.key_bindings.on_key.c.messages

-- TODO: search, help, editoe

deep_merge(xplr, {
  config = {
    modes = {
      custom = {
        last = {
          key_bindings = {
            on_key = {
              m = {
                help = 'mvf last',
                messages = {
                  {
                    ['BashExec'] = [[
                      mvf --last
                    ]],
                  },
                },
              },
              t = {
                help = 'mvf last',
                messages = {
                  {
                    ['BashExec'] = [[
                      tag-put "$XPLR_FOCUS_PATH" --repeat
                    ]],
                  },
                },
              },
              w = {
                help = 'tag put last',
                messages = {
                  {
                    ['BashExec'] = [[
                      tag-put --last
                    ]],
                  },
                },
              },
              W = {
                help = 'tag del last',
                messages = {
                  {
                    ['BashExec'] = [[
                      tag-del --last
                    ]],
                  },
                },
              },
              esc = {
                help = 'default mode',
                messages = {
                  'PopMode',
                  { SwitchModeBuiltin = 'default' },
                },
              },
            },
          },
        },
      },
      builtin = {
        action = {
          key_bindings = {
            on_key = {
              c = nop,
              e = nop,
              s = nop,
              d = {
                help = 'debug',
                messages = {
                  {
                    Debug = '/tmp/xplr.debug.yaml',
                  },
                },
              },
              ['!'] = nop,
            },
          },
        },
        default = {
          key_bindings = {
            on_key = {
              a = {
                help = 'action mode',
                messages = {
                  { SwitchModeBuiltin = 'create' },
                },
              },
              b = {
                help = 'last',
                messages = {
                  { SwitchModeCustom = 'last' },
                },
              },
              e = {
                help = 'open editor',
                messages = {
                  {
                    ['BashExecSilently'] = [[
                    exec $TERMINAL -e nvim &
                    ]],
                  },
                },
              },
              i = {
                help = 'images',
                messages = {
                  {
                    ['BashExecSilently'] = [[
                      if [ -d "$XPLR_FOCUS_PATH" ]; then
                        PTH="$XPLR_FOCUS_PATH"
                      else
                        PTH=$(basedir "$XPLR_FOCUS_PATH")
                      fi
                      fd -tl . "$PTH"|imv&
                    ]],
                  },
                },
              },
              K = {
                help = 'selection mode',
                messages = {
                  { SwitchModeBuiltin = 'selection_ops' },
                },
              },
              l = {
                help = 'open',
                -- TODO: make builtin
                -- TODO: follow symbolic link
                messages = {
                  {
                    ['BashExecSilently'] = [[
                      if [ -d "$XPLR_FOCUS_PATH" ]; then
                        echo "ChangeDirectory: $XPLR_FOCUS_PATH" >> $XPLR_PIPE_MSG_IN
                      else
                        opener "$XPLR_FOCUS_PATH"
                      fi
                    ]],
                  },
                },
              },
              L = {
                help = 'fzf open',
                messages = {
                  {
                    ['BashExec'] = [[
                      res="$(fd --type directory --follow --hidden --exclude .git | fzf)"
                      if [ -n "$res" ]; then
                        echo ChangeDirectory: "'"${res:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                      fi
                    ]],
                  },
                },
              },
              m = {
                help = 'mvf current',
                messages = {
                  {
                    ['BashExec'] = [[
                      if [ -f "$XPLR_FOCUS_PATH" ]; then
                        mvf "$XPLR_FOCUS_PATH"
                      fi
                    ]],
                  },
                },
              },
              o = {
                help = 'fzf open',
                messages = {
                  {
                    ['BashExec'] = [[
                      res="$(fd --type file --follow --hidden --exclude .git | fzf)"
                        if [ -n "$res" ]; then
                          opener "$res"
                        fi
                    ]],
                  },
                },
              },
              q = {
                help = 'print pwd and quit',
                messages = { 'PrintPwdAndQuit' },
              },
              Q = {
                help = 'quit',
                messages = { 'Quit' },
              },
              S = {
                help = 'back',
                -- TODO
                -- messages = { '' },
              },
              t = {
                help = 'terminal',
                messages = {
                  {
                    ['BashExec'] = [[
                      exec $TERMINAL &
                    ]],
                  },
                },
              },
              w = {
                help = 'tag put current',
                messages = {
                  {
                    ['BashExec'] = [[
                      tag-put "$XPLR_FOCUS_PATH"
                    ]],
                  },
                },
              },
              W = {
                help = 'tag del current',
                messages = {
                  {
                    ['BashExec'] = [[
                      tag-del "$XPLR_FOCUS_PATH"
                    ]],
                  },
                },
              },
              u = register 'dua_cli',
              z = register 'zoxide',
              ['/'] = nop,
              ['é'] = {
                help = 'search',
                messages = search,
              },
              ['!'] = {
                help = 'shell',
                messages = shell,
              },
              [':'] = nop,
              [';'] = {
                help = 'default mode',
                messages = {
                  { SwitchModeBuiltin = 'action' },
                },
              },
              ['enter'] = nop,
              ['ctrl-h'] = {
                help = 'history',
                messages = {
                  {
                    ['BashExec'] = [[
                      PTH=$(cat "${XPLR_PIPE_HISTORY_OUT:?}" | sort -u | fzf --no-sort)
                      if [ "$PTH" ]; then
                        echo ChangeDirectory: "'"${PTH:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                      fi
                    ]],
                  },
                },
              },
              -- TODO: use lua
              -- TODO: prevent accumulation of trailing slashes
              ['alt-a'] = {
                help = 'back',
                messages = {
                  {
                    ['BashExec'] = [[
                      PTH=$(cat "${XPLR_PIPE_HISTORY_OUT:?}"|tail -2|head -1)
                      if [ "$PTH" ]; then
                        echo ChangeDirectory: "'"${PTH:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                      fi
                    ]],
                  },
                },
              },
              ['ctrl-v'] = {
                help = 'fzf open',
                messages = {
                  {
                    ['BashExec'] = [[
                      res="$(fd --type directory --follow --hidden --exclude .git | fzf)"
                      if [ -n "$res" ]; then
                        echo ToggleSelectionByPath: "'"${res:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                      fi
                    ]],
                  },
                },
              },
            },
          },
        },
        go_to = {
          key_bindings = {
            on_key = {
              b = {
                help = 'bookmarks',
                messages = {
                  {
                    ['BashExec'] = [[
                      PTH="$(cat "$HOME/.config/xplr/bookmarks" | fzf)" 
                      if [ "$PTH" ]; then
                        echo ChangeDirectory: "'"${PTH:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                      fi
                    ]],
                  },
                  'PopMode',
                  { SwitchModeBuiltin = 'default' },
                },
              },
              p = {
                help = 'project root',
                messages = {
                  {
                    ['BashExec'] = [[
                      PTH="$(project_root)" 
                      if [ "$PTH" ]; then
                        echo ChangeDirectory: "'"${PTH:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                      fi
                    ]],
                  },
                  'PopMode',
                  { SwitchModeBuiltin = 'default' },
                },
              },
              w = {
                help = 'visit tag',
                messages = {
                  {
                    ['BashExec'] = [[
                      PTH="$(tag-go "$PWD")"  
                      if [ "$PTH" ]; then
                        echo ChangeDirectory: "'"${PTH:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                      fi
                    ]],
                  },
                  'PopMode',
                  { SwitchModeBuiltin = 'default' },
                },
              },
            },
          },
        },
        selection_ops = {
          key_bindings = {
            on_key = {
              p = {
                help = 'copy here',
                messages = copy_here.messages,
              },
              w = {
                help = 'tag selection',
                messages = {{ BashExec = [[
                cat "$XPLR_PIPE_SELECTION_OUT" | while read -r line ; do
                  if [ -z "$succ" ]; then
                    succ=succ
                    tag-put "$line"
                  else
                    tag-put "$line" --repeat
                  fi
                done
                ]] }},
              },
            },
          },
        },
      },
    },
  },
})

require('zoxide').setup { key = reg.zoxide }
require('dua-cli').setup { key = reg.dua_cli }
