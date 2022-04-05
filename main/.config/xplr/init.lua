version = '0.17.0'
package.path = os.getenv 'HOME' .. '/.config/xplr/plugins/?.xplr/src/init.lua'
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
require('context-switch').setup()
-- local modules.utils = require 'utils'

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

xplr.config.general.initial_layout = 'no_help_no_selection'

local copy_here = {
  unpack(
    xplr.config.modes.builtin.selection_ops.key_bindings.on_key.c.messages
  ),
}

for _, key in ipairs { 'space', 'v', 'h', 'j', 'k', 'l' } do
  xplr.config.modes.builtin.default.key_bindings.on_key[key] = nil
end

-- TODO: bash to lua

xplr.config.modes.builtin.default.key_bindings.on_key['j'] =
  xplr.config.modes.builtin.default.key_bindings.on_key.up

xplr.config.modes.builtin.default.key_bindings.on_key['k'] =
  xplr.config.modes.builtin.default.key_bindings.on_key.down

xplr.config.modes.builtin.default.key_bindings.on_key['l'] =
  xplr.config.modes.builtin.default.key_bindings.on_key.left

xplr.config.modes.builtin.default.key_bindings.on_key[';'] =
  xplr.config.modes.builtin.default.key_bindings.on_key.right

local common = {
  ['ctrl-c'] = {
    help = 'cancel',
    messages = { 'PopMode' },
  },
  ['ctrl-q'] = {
    help = 'terminate',
    messages = { 'Terminate' },
  },
  ['alt-h'] = {
    help = 'help',
    messages = {
      { BashExec = 'nvim ~/Dotfiles/main/.config/xplr/init.lua' },
    },
  },
  ['ctrl-h'] = {
    help = 'help',
    -- TODO: position to active mode
    messages = {
      {
        BashExec = 'less "$XPLR_PIPE_GLOBAL_HELP_MENU_OUT"',
      },
    },
  },
  esc = nop,
}

for _, mode in pairs(xplr.config.modes.builtin) do
  deep_merge(mode.key_bindings.on_key, common)
end

-- xplr.config.modes.builtin.default.key_bindings.on_key['ctrl-c'] = nil
deep_merge(xplr, {
  config = {
    modes = {
      custom = {
        create_in_external_editor = {
          name = 'create in external editor',
          help = nil,
          extra_help = nil,
          key_bindings = {
            on_key = {
              backspace = {
                help = 'remove last character',
                messages = { 'RemoveInputBufferLastCharacter' },
              },
              ['ctrl-u'] = {
                help = 'remove line',
                messages = {
                  {
                    SetInputBuffer = '',
                  },
                },
              },
              ['ctrl-w'] = {
                help = 'remove last word',
                messages = { 'RemoveInputBufferLastWord' },
              },
              enter = {
                help = 'create file',
                messages = {
                  {
                    BashExecSilently = [===[
                    PTH="$XPLR_INPUT_BUFFER"
                    if [ "${PTH}" ]; then
                      nvr -- "${PTH:?}" \
                      && echo "SetInputBuffer: ''" >> "${XPLR_PIPE_MSG_IN:?}" \
                      && echo LogSuccess: $PTH created >> "${XPLR_PIPE_MSG_IN:?}" \
                      && echo ExplorePwd >> "${XPLR_PIPE_MSG_IN:?}" \
                      && echo FocusByFileName: "'"$PTH"'" >> "${XPLR_PIPE_MSG_IN:?}"
                    else
                      echo PopMode >> "${XPLR_PIPE_MSG_IN:?}"
                    fi
                    ]===],
                  },
                },
              },
            },
            on_alphabet = nil,
            on_number = nil,
            on_special_character = nil,
            default = {
              help = nil,
              messages = { 'BufferInputFromKey' },
            },
          },
        },
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
        context_switch = {
          key_bindings = {
            on_key = {
              j = {
                help = 'up',
                messages = {
                  { CallLuaSilently = 'custom.context_switch.prev' },
                },
              },
              k = {
                help = 'down',
                messages = {
                  { CallLuaSilently = 'custom.context_switch.next' },
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
        create = {
          key_bindings = {
            on_key = {
              e = {
                help = 'create in external editor',
                messages = {
                  { SwitchModeCustom = 'create_in_external_editor' },
                },
              },
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
                help = 'bottom',
                messages = { 'FocusLast', 'PopMode' },
              },
              E = {
                help = 'top',
                messages = { 'FocusFirst', 'PopMode' },
              },
              h = {
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
                        xdg-open "$res"
                      fi
                    ]],
                  },
                },
              },
              O = {
                help = 'open editor',
                messages = {
                  {
                    BashExecSilently = [[ exec $TERMINAL -e nvim & ]],
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
              v = {
                help = 'toggle selection',
                messages = { 'ToggleSelection', 'FocusNext' },
              },
              V = {
                help = 'selection mode',
                messages = {
                  { SwitchModeBuiltin = 'selection_ops' },
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
              [';'] = { -- right
                help = 'open',
                messages = {
                  {
                    BashExecSilently = [[
                      if [ -d "$XPLR_FOCUS_PATH" ]; then
                        echo "ChangeDirectory: $XPLR_FOCUS_PATH" >> $XPLR_PIPE_MSG_IN
                      else
                        xdg-open "$XPLR_FOCUS_PATH"
                      fi
                    ]],
                  },
                },
              },
              [':'] = { -- shift right
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
              ['~'] = nop,
              ['/'] = nop,
              ['é'] = {
                help = 'search',
                messages = {
                  'PopMode',
                  { SwitchModeBuiltin = 'search' },
                  { SetInputBuffer = '' },
                  'ExplorePwdAsync',
                },
              },
              ['?'] = nop,
              ['!'] = {
                help = 'shell',
                messages = {
                  {
                    Call = {
                      command = 'fish',
                      args = { '-i' },
                    },
                  },
                  'ExplorePwdAsync',
                  'PopMode',
                },
              },
              space = {
                help = 'action mode',
                messages = {
                  { SwitchModeBuiltin = 'action' },
                },
              },
              enter = nop,
              ['ctrl-a'] = nop,
              ['ctrl-f'] = {
                help = 'fzf focus/cd',
                messages = {
                  {
                    BashExec = [[
                      SELECTED=$(cat "${XPLR_PIPE_DIRECTORY_NODES_OUT:?}" | awk -F / '{print $NF}' | fzf --no-sort)
                      if [ "$SELECTED" ]; then
                      echo FocusPath: '"'$PWD/$SELECTED'"' >> "${XPLR_PIPE_MSG_IN:?}"
                      fi
                      if [ -d "$SELECTED" ]; then
                      echo Enter >> "${XPLR_PIPE_MSG_IN:?}"
                      fi
                    ]],
                  },
                  'PopMode',
                },
              },
              -- ['ctrl-i'] = {
              --   help = "next visited path",
              --   messages = { "NextVisitedPath" },
              -- },
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
              g = nop,
              h = {
                help = 'home',
                messages = {
                  {
                    BashExecSilently = [===[
                    echo ChangeDirectory: "'"${HOME:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                    ]===],
                  },
                },
              },
              M = {
                help = 'pane-set',
                messages = {
                  {
                    BashExecSilently = [[ echo "$PWD" > "$XPLR_SESSION_PATH/pane" ]],
                  },
                  'PopMode',
                  { SwitchModeBuiltin = 'default' },
                },
              },
              m = {
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
                messages = { 'FollowSymlink', 'PopMode' },
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
                    ]],
                  },
                },
              },
              o = {
                help = 'open from selection',
                messages = {
                  {
                    BashExec = [[
                      PTH=$(fzf <"$XPLR_PIPE_SELECTION_OUT")
                      if [ -n "$PTH" ]; then
                        xdg-open "$PTH"
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
        switch_layout = {
          key_bindings = {
            on_key = {
              h = {
                help = 'help',
                messages = {
                  { SwitchLayoutBuiltin = 'no_selection' },
                  'PopMode',
                },
              },
              v = {
                help = 'selection',
                messages = {
                  { SwitchLayoutBuiltin = 'no_help' },
                  'PopMode',
                },
              },
              w = {
                help = 'default',
                messages = {
                  { SwitchLayoutBuiltin = 'no_help_no_selection' },
                  'PopMode',
                },
              },
            },
          },
        },
      },
    },
  },
})

for _, mode in pairs(xplr.config.modes.custom) do
  deep_merge(mode.key_bindings.on_key, common)
end

xplr.config.modes.custom.type_to_nav.key_bindings.on_key['esc'] = {
  help = 'quit mode',
  messages = { { CallLuaSilently = 'custom.type_to_nav_quit' } },
}

require('zoxide').setup { key = reg.zoxide }
require('dua-cli').setup { key = reg.dua_cli }

-------- Col widths
xplr.config.general.table.col_widths = {
  { Percentage = 100 },
}

-------- Header
xplr.config.general.table.header.cols = {
  {
    format = '',
    style = { add_modifiers = nil, bg = nil, fg = nil, sub_modifiers = nil },
  },
}
xplr.config.general.table.header.height = 0
xplr.config.general.table.header.style.add_modifiers = { 'Bold' }
xplr.config.general.table.header.style.sub_modifiers = nil
xplr.config.general.table.header.style.bg = nil
xplr.config.general.table.header.style.fg = nil

-------- Row
xplr.config.general.table.row.cols = {
  {
    format = 'builtin.fmt_general_table_row_cols_1',
    style = { add_modifiers = nil, bg = nil, fg = nil, sub_modifiers = nil },
  },
}
xplr.config.general.table.row.height = 0
xplr.config.general.table.row.style.add_modifiers = nil
xplr.config.general.table.row.style.bg = nil
xplr.config.general.table.row.style.fg = nil
xplr.config.general.table.row.style.sub_modifiers = nil

-------- Tree
xplr.config.general.table.tree = nil
