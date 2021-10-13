version = '0.14.4'
package.path = os.getenv 'HOME' .. '/.config/xplr/plugins/?.xplr/src/init.lua'
require('fzf').setup()
require('comex').setup { compress_key = 'c', extract_key = 'x' }
require('type-to-nav').setup()
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
local shell = {
  unpack(xplr.config.modes.builtin.action.key_bindings.on_key['!'].messages),
}
local follow_symlink = {
  unpack(xplr.config.modes.builtin.go_to.key_bindings.on_key.f.messages),
}
local search = {
  unpack(xplr.config.modes.builtin.default.key_bindings.on_key['/'].messages),
}
local copy_here = {
  unpack(xplr.config.modes.builtin.selection_ops.key_bindings.on_key.c.messages),
}

-- TODO go top, go bottom (Ee)
-- TODO bash to lua
-- TODO create in editor

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
                    BashExec = [[ mvf --last ]],
                  },
                },
              },
              t = {
                help = 'mvf last',
                messages = {
                  {
                    BashExec = [[ tag-put "$XPLR_FOCUS_PATH" --repeat ]],
                  },
                },
              },
              w = {
                help = 'tag put last',
                messages = {
                  {
                    BashExec = [[ tag-put --last ]],
                  },
                },
              },
              W = {
                help = 'tag del last',
                messages = {
                  {
                    BashExec = [[ tag-del --last ]],
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
              c = {
                help = 'selection mode',
                messages = {
                  { SwitchModeBuiltin = 'selection_ops' },
                },
              },
              e = {
                help = 'open editor',
                messages = {
                  {
                    BashExecSilently = [[ exec $TERMINAL -e nvim & ]],
                  },
                },
              },
              i = {
                help = 'view images',
                messages = {
                  {
                    BashExec = [[
                      if [ -n "$XPLR_PIPE_SELECTION_OUT" ]; then
                        imv <"$XPLR_PIPE_SELECTION_OUT" &
                      elif [ -d "$XPLR_FOCUS_PATH" ]; then
                        # TODO: respect filters ??
                        PTH="$XPLR_FOCUS_PATH"
                        fd -tl . "$PTH"|imv&
                      else
                        PTH=$(basedir "$XPLR_FOCUS_PATH")
                        fd -tl . "$PTH"|imv&
                      fi
                    ]],
                  },
                },
              },
              l = {
                help = 'open',
                messages = {
                  {
                    BashExecSilently = [[
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
                help = 'fzf open dir',
                messages = {
                  {
                    BashExec = [[
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
                    BashExec = [[
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
                    --  --preview 'echo {} >/tmp/xplr.fifo' --preview-window 0
                    BashExec = [[
                      res="$(fd --type file --follow --hidden --exclude .git | fzf --preview 'echo {} >/tmp/xplr.fifo' --preview-window 0)" -- FIXME
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
              t = {
                help = 'terminal',
                messages = {
                  {
                    BashExecSilently = [[ exec $TERMINAL & ]],
                  },
                },
              },
              w = {
                help = 'tag put current',
                messages = {
                  {
                    BashExec = [[ tag-put "$XPLR_FOCUS_PATH" ]],
                  },
                },
              },
              W = {
                help = 'tag del current',
                messages = {
                  {
                    BashExec = [[ tag-del "$XPLR_FOCUS_PATH" ]],
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
              ['?'] = nop,
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
                    BashExec = [[
                      PTH=$(cat "${XPLR_PIPE_HISTORY_OUT:?}" | head -n -1 | tac | fzf --no-sort)
                      if [ "$PTH" ]; then
                        PTH="${PTH%/}" # remove trailing slash
                        echo ChangeDirectory: "'"${PTH:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                      fi
                    ]],
                  },
                },
              },
              ['ctrl-j'] = {
                help = 'pane-swap',
                messages = {
                  {
                    BashExec = [[ 
                      LOC="$(cat "$XPLR_SESSION_PATH/pane")"
                      if [ -n "$LOC" ]; then
                        echo "$PWD" > "$XPLR_SESSION_PATH/pane" 
                        echo ChangeDirectory: "'"${LOC:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                      fi
                    ]],
                  },
                  'PopMode',
                  { SwitchModeBuiltin = 'default' },
                },
              },
              ['alt-h'] = {
                help = 'help',
                messages = {
                  {
                    -- TODO: position to active mode
                    BashExec = [[
                      PAGER=${PAGER-less}
                      "$PAGER" "$XPLR_PIPE_GLOBAL_HELP_MENU_OUT"
                    ]],
                  },
                },
              },
              ['ctrl-v'] = {
                help = 'fzf toggle selection',
                messages = {
                  {
                    BashExec = [[
                      res="$(ls | sort | fzf)"
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
                    BashExec = [[
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
              f = {
                help = 'fzf focus',
                messages = {
                  {
                    BashExec = [[
                      res="$(ls -A | fzf)"
                      if [ -n "$res" ]; then
                        echo FocusPath: "'"${res:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                      fi
                    ]],
                  },
                },
              },
              F = {
                help = 'fzf focus recursive',
                messages = {
                  {
                    BashExec = [[
                      res="$(fd . . | fzf)"
                      if [ -n "$res" ]; then
                        echo FocusPath: "'"${res:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                      fi
                    ]],
                  },
                },
              },
              j = {
                help = 'pane-set',
                messages = {
                  {
                    BashExecSilently = [[ echo "$PWD" > "$XPLR_SESSION_PATH/pane" ]],
                  },
                  'PopMode',
                  { SwitchModeBuiltin = 'default' },
                },
              },
              p = {
                help = 'project root',
                messages = {
                  {
                    BashExecSilently = [[
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
              r = {
                help = 'random',
                messages = {
                  {
                    BashExecSilently = [[
                      PTH=$(fd --type file .|shuf -n1) 
                      if [ "$PTH" ]; then
                        echo FocusPath: "'"${PTH:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                      fi
                      echo "$PTH"
                    ]],
                  },
                  'PopMode',
                  { SwitchModeBuiltin = 'default' },
                },
              },
              s = {
                help = 'follow symlink',
                messages = follow_symlink,
              },
              t = {
                help = 'tag',
                messages = {
                  {
                    BashExecSilently = [[
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
              u = {
                help = 'add tag to selection',
                messages = {
                  {
                    BashExec = [[
                    tag="$(tag-ls | fzf --print-query | tail -1)"  
                    if [ -n "$tag" ]; then
                      tag-u "$tag" | sort -u /dev/stdin | while read -r PTH ; do
                        ESC="$(echo "$PTH"|sed 's/"/\\"/g')"
                        echo "SelectPath: \"$ESC\"" >> "$XPLR_PIPE_MSG_IN"
                      done
                    fi
                  ]],
                  },
                },
              },
              U = {
                help = 'intersect tag with selection',
                messages = {
                  {
                    BashExec = [[
                    tag="$(tag-ls | fzf --print-query | tail -1)"  
                    if [ -n "$tag" ]; then
                      echo > "$XPLR_SESSION_PATH/raw"
                      tag-u "$tag" | while read -r PTH ; do
                        echo "$(realpath "$PTH")" >> "$XPLR_SESSION_PATH/raw"
                      done
                      sort "$XPLR_SESSION_PATH/raw" > "$XPLR_SESSION_PATH/operand"
                      cat "$XPLR_PIPE_SELECTION_OUT" | while read -r PTH ; do
                        if [ -z "$(look "$PTH" "$XPLR_SESSION_PATH/operand")" ]; then
                          ESC="$(echo "$PTH"|sed 's/"/\\"/g')"
                          echo "UnSelectPath: \"$ESC\"" >> "$XPLR_PIPE_MSG_IN"
                        fi
                      done
                    fi
                    ]],
                  },
                },
              },
              d = {
                help = 'remove tag from selection',
                messages = {
                  {
                    BashExec = [[
                    tag="$(tag-ls | fzf --print-query | tail -1)"  
                    if [ -n "$tag" ]; then
                      tag-u "$tag" | sort -u /dev/stdin | while read -r PTH ; do
                        ESC="$(echo "$PTH"|sed 's/"/\\"/g')"
                        echo "UnSelectPath: \"$ESC\"" >> "$XPLR_PIPE_MSG_IN"
                      done
                    fi
                  ]],
                  },
                },
              },
              -- TODO: cycle selected
              m = {
                -- TODO: revert to builtin when there is not .tags
                help = 'move with tags here',
                messages = {
                  {
                    BashExec = [[
                      cat "$XPLR_PIPE_SELECTION_OUT" | while read -r line ; do
                        tag-mv "$line" "$PWD"
                      done
                    ]],
                  },
                },
              },
              a = {
                help = 'select untagged from current dir',
                messages = {
                  {
                    BashExecSilently = [[
                      for PTH in *; do
                        if [ -z "$(tag-get "$PTH")" ]; then
                          ESC="$(echo "$PTH"|sed 's/"/\\"/g')"
                          echo "SelectPath: \"$ESC\"" >> "$XPLR_PIPE_MSG_IN"
                        fi
                      done
                    ]]
                  }
              }},
              o = {
                help = 'open from selection',
                messages = {
                  {
                    BashExec = [[
                      PTH=$(fzf <"$XPLR_PIPE_SELECTION_OUT")
                      if [ -n "$PTH" ]; then
                        opener "$PTH"
                      fi
                    ]],
                  },
                },
              },
              p = {
                help = 'copy here',
                messages = copy_here.messages,
              },
              w = {
                help = 'assign tag to selection',
                messages = {
                  {
                    BashExec = [[
                      cat "$XPLR_PIPE_SELECTION_OUT" | while read -r line ; do
                        if [ -z "$succ" ]; then
                          succ=succ
                          tag-put "$line"
                        else
                          tag-put "$line" --repeat
                        fi
                      done
                    ]],
                  },
                },
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
