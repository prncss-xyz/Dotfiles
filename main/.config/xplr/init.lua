version = '0.21.0'

-- override builtin modes to get rid of deep_merge
-- fzm: project root or current dir, unless in downloads (by mimetype then)
-- operation to restrict selection with current dir
-- tags: multiple selection
-- cat "${XPLR_PIPE_RESULT_OUT:?}" | commannd # selection or focused
-- nvim remote stuff
-- adapt alacritty.xplr

local xplr = xplr
local home = os.getenv 'HOME'
local xpm_path = home .. '/.local/share/xplr/dtomvan/xpm.xplr'
local xpm_url = 'https://github.com/dtomvan/xpm.xplr'

package.path = home .. '/.config/xplr/plugins/?.xplr/src/init.lua'
package.path = package.path
  .. ';'
  .. xpm_path
  .. '/?.lua;'
  .. xpm_path
  .. '/?/init.lua'

os.execute(
  string.format(
    "[ -e '%s' ] || git clone '%s' '%s'",
    xpm_path,
    xpm_url,
    xpm_path
  )
)

local d = {
  up = 'j',
  down = 'k',
  left = 'l',
  right = ';',
}

require('xpm').setup {
  'dtomvan/xpm.xplr',
  'sayanarijit/trash-cli.xplr',
  {
    'sayanarijit/dual-pane.xplr',
    setup = function()
      require('dual-pane').setup {
        active_pane_width = { Percentage = 70 },
        inactive_pane_width = { Percentage = 30 },
      }
    end,
  },
  {
    'sayanarijit/map.xplr',
    setup = function()
      require('map').setup {
        mode = 'selection_ops',
        key = 'f',
        placeholder = '{}',
        prefer_multi_map = false,
      }
    end,
  },
  {
    'sayanarijit/find.xplr',
    setup = function()
      require('find').setup {
        mode = 'selection_ops',
        key = 'é',
        templates = {
          ['all'] = {
            key = 'a',
            find_command = 'fd',
            find_args = '',
            cursor_position = 1,
          },
          ['directory'] = {
            key = 'd',
            find_command = 'fd',
            find_args = '-t d ',
            cursor_position = 5,
          },
          ['empty'] = {
            key = 'e',
            find_command = 'fd',
            find_args = '-t e ',
            cursor_position = 5,
          },
          ['file'] = {
            key = 'f',
            find_command = 'fd',
            find_args = '-t f ',
            cursor_position = 5,
          },
          ['git (diff)'] = {
            key = 'g',
            find_command = 'git diff HEAD~1 --name-only',
            find_args = ' ',
            cursor_position = 1,
          },
          ['link'] = {
            key = 'l',
            find_command = 'fd',
            find_args = '-t l ',
            cursor_position = 5,
          },
          ['socket'] = {
            key = 's',
            find_command = 'fd',
            find_args = '-t s ',
            cursor_position = 5,
          },
          ['pipe'] = {
            key = 'p',
            find_command = 'fd',
            find_args = '-t p ',
            cursor_position = 5,
          },
          ['executable'] = {
            key = 'x',
            find_command = 'fd',
            find_args = '-t x ',
            cursor_position = 5,
          },
          ['extension'] = {
            key = '.',
            find_command = 'fd',
            find_args = '-e ',
            cursor_position = 3,
          },
        },
        refresh_screen_key = 'ctrl-r',
      }
    end,
  },
  {
    'sayanarijit/dua-cli.xplr',
    setup = function()
      require('dua-cli').setup { mode = 'action', key = 'd' }
    end,
  },
  {
    'sayanarijit/zoxide.xplr',
    setup = function()
      require('zoxide').setup {
        mode = 'go_to',
        key = 'z',
      }
    end,
  },
}

-- local plugins
-- require('icons').setup()
-- local modules.utils = require 'utils'

local function deep_merge(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == 'table') and (type(t1[k] or false) == 'table') then
      deep_merge(t1[k], t2[k])
    else
      t1[k] = v
    end
  end
  return t1
end

for _, key in ipairs {
  'v',
  'h',
  'j',
  'k',
  'l',
  ':',
  '~',
  '/',
  '?',
  'n',
  'N',
  'V',
  'G',
  'right',
  'enter',
  'space',
  'tab',
} do
  xplr.config.modes.builtin.default.key_bindings.on_key[key] = nil
end
for _, key in ipairs {
  'a',
  'i',
  'o',
  'u',
  'w',
  'f',
  'd',
} do
  xplr.config.modes.builtin.default.key_bindings.on_key['ctrl-' .. key] = nil
end
for _, key in ipairs { 'c', 'e', 's', '!' } do
  xplr.config.modes.builtin.action.key_bindings.on_key[key] = nil
end

for _, key in ipairs { 'c', 'e', 's', '!' } do
  xplr.config.modes.builtin.action.key_bindings.on_key[key] = nil
end

for _, key in ipairs { 'g', 'x' } do
  xplr.config.modes.builtin.go_to.key_bindings.on_key[key] = nil
end
for _, key in ipairs { 'c', 'e', 's', '!' } do
  xplr.config.modes.builtin.action.key_bindings.on_key[key] = nil
end

xplr.config.modes.builtin.delete.key_bindings.on_key = {
  ['D'] = {
    help = 'force delete',
    messages = {
      {
        BashExecSilently = [===[
              (while IFS= read -r line; do
              if rm -rfv -- "${line:?}"; then
                echo LogSuccess: $line deleted >> "${XPLR_PIPE_MSG_IN:?}"
              else
                echo LogError: Failed to delete $line >> "${XPLR_PIPE_MSG_IN:?}"
              fi
              done < "${XPLR_PIPE_RESULT_OUT:?}")
              echo ExplorePwdAsync >> "${XPLR_PIPE_MSG_IN:?}"
              read -p "[enter to continue]"
            ]===],
      },
      'PopMode',
    },
  },
  d = {
    help = 'delete',
    messages = {
      {
        BashExecSilently = [===[
              (while IFS= read -r line; do
              if [ -d "$line" ] && [ ! -L "$line" ]; then
                if rmdir -v -- "${line:?}"; then
                  echo LogSuccess: $line deleted >> "${XPLR_PIPE_MSG_IN:?}"
                else
                  echo LogError: Failed to delete $line >> "${XPLR_PIPE_MSG_IN:?}"
                fi
              else
                if rm -v -- "${line:?}"; then
                  echo LogSuccess: $line deleted >> "${XPLR_PIPE_MSG_IN:?}"
                else
                  echo LogError: Failed to delete $line >> "${XPLR_PIPE_MSG_IN:?}"
                fi
              fi
              done < "${XPLR_PIPE_RESULT_OUT:?}")
              echo ExplorePwdAsync >> "${XPLR_PIPE_MSG_IN:?}"
              read -p "[enter to continue]"
            ]===],
      },
      'PopMode',
    },
  },
}


-- TODO: bash to lua
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
                    BashExecSilently = [[
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
                    ]],
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
        wl_copy = {
          -- adapted from https://github.com/sayanarijit/wl-clipboard.xplr
          name = 'copy',
          key_bindings = {
            on_key = {
              p = {
                help = 'paste from clipboard',
                messages = {
                  {
                    BashExec = [[
                      wl-paste | while read -r path; do
                        [ -e "$path" ] && cp -var "${path:?}" ./
                      done
                      read -p "[press ENTER to continue]"
                    ]],
                  },
                  'ExplorePwd',
                  'PopMode',
                },
              },
              y = {
                help = 'copy files',
                messages = {
                  {
                    BashExecSilently = [[
                     if cat "${XPLR_PIPE_RESULT_OUT:?}" | wl-copy; then
                       echo LogSuccess: Copied paths to clipboard >> ${XPLR_PIPE_MSG_IN:?}
                     else
                       echo LogSuccess: Failed to copy paths >> ${XPLR_PIPE_MSG_IN:?}
                     fi
                  ]],
                  },
                  'ClearSelection',
                  'PopMode',
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
              b = {
                help = 'debug',
                messages = {
                  {
                    Debug = '/tmp/xplr.debug.yaml',
                  },
                },
              },
              h = {
                help = 'help',
                messages = {
                  'PopMode',
                  {
                    BashExec = 'less "$XPLR_PIPE_GLOBAL_HELP_MENU_OUT"',
                  },
                },
              },
              i = {
                help = 'preview images',
                messages = {
                  'PopMode',
                  {
                    BashExec = [[
                      FIFO_PATH="/tmp/xplr.fifo"
                      if [ -e "$FIFO_PATH" ]; then
                        echo StopFifo >> "$XPLR_PIPE_MSG_IN"
                        rm "$FIFO_PATH"
                      else
                        mkfifo "$FIFO_PATH"
                        "$HOME/.local/bin/imv-open" "$FIFO_PATH" "$XPLR_FOCUS_PATH" &
                        echo "StartFifo: '$FIFO_PATH'" >> "$XPLR_PIPE_MSG_IN"
                      fi
                    ]],
                  },
                },
              },
              M = {
                help = 'delete bookmark',
                messages = {
                  {
                    BashExec = [[
                      PTH=$(cat "${XPLR_BOOKMARK_FILE:?}" | fzf --no-sort)
                      sd "$PTH\n" "" "${XPLR_BOOKMARK_FILE:?}"
                    ]],
                  },
                },
              },
              m = {
                help = 'add bookmarks',
                messages = {
                  {
                    BashExec = [[
                      PTH="${XPLR_FOCUS_PATH:?}"
                      PTH="$(dirname "${PTH}")"
                      if echo "${PTH:?}" >> "${XPLR_BOOKMARK_FILE:?}"; then
                        echo "LogSuccess: ${PTH:?} added to bookmarks" >> "${XPLR_PIPE_MSG_IN:?}"
                      else
                        echo "LogError: Failed to bookmark ${PTH:?}" >> "${XPLR_PIPE_MSG_IN:?}"
                      fi
                    ]],
                  },
                  'PopMode',
                },
              },
              -- p = {
              --   help = 'mtp mount',
              --   messages = {
              --     'PopMode',
              --     {
              --       BashExec = [[mtpmount]],
              --     },
              --   },
              -- },
              q = {
                help = 'quit mode',
                messages = {
                  'PopMode',
                  { SwitchModeBuiltin = 'quit' },
                },
              },
              t = {
                help = 'terminal',
                messages = {
                  'PopMode',
                  {
                    BashExecSilently = [[ exec $TERMINAL & ]],
                  },
                },
              },
              x = {
                help = 'xplr',
                messages = {
                  'PopMode',
                  {
                    BashExecSilently = [[ exec $TERMINAL -e xplr & ]],
                  },
                },
              },
              z = {
                help = 'zk-bib eat --yes',
                messages = {
                  {
                    BashExecSilently = [[
                      zk-bib eat --yes "$XPLR_FOCUS_PATH"
                    ]],
                  },
                },
              },
              space = {
                help = 'shell',
                messages = {
                  'PopMode',
                  { Call = { command = 'fish', args = { '-i' } } },
                  'ExplorePwdAsync',
                },
              },
            },
          },
        },
        create = {
          key_bindings = {
            on_key = {
              c = {
                help = 'duplicate as',
                messages = {
                  'PopMode',
                  { SwitchModeBuiltin = 'duplicate_as' },
                  {
                    BashExecSilently = [[
                      echo SetInputBuffer: "'"$(basename "${XPLR_FOCUS_PATH}")"'" >> "${XPLR_PIPE_MSG_IN:?}"
                    ]],
                  },
                },
              },
              e = {
                help = 'create in external editor',
                messages = {
                  'PopMode',
                  { SwitchModeCustom = 'create_in_external_editor' },
                },
              },
            },
          },
        },
        default = {
          key_bindings = {
            on_key = {
              [d.up] = {
                help = 'up',
                messages = {
                  'FocusPrevious',
                },
              },
              [d.down] = {
                help = 'down',
                messages = {
                  'FocusNext',
                },
              },
              [d.left] = {
                help = 'back',
                messages = {
                  'Back',
                },
              },
              b = {
                help = 'mvf',
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
              B = {
                help = 'mvf --last',
                messages = {
                  {
                    BashExec = [[ mvf --last ]],
                  },
                },
              },
              a = {
                help = 'create',
                messages = {
                  { SwitchModeBuiltin = 'create' },
                },
              },
              space = {
                help = 'action',
                messages = {
                  { SwitchModeBuiltin = 'action' },
                },
              },
              n = {
                help = 'next visited path',
                messages = { 'NextVisitedPath' },
              },
              p = {
                help = 'last visited path',
                messages = { 'LastVisitedPath' },
              },
              m = {
                help = 'move here',
                messages = {
                  {
                    BashExecSilently = [[
                      (while IFS= read -r line; do
                      if mv -v -- "${line:?}" ./; then
                        echo LogSuccess: $line moved to $PWD >> "${XPLR_PIPE_MSG_IN:?}"
                      else
                        echo LogError: Failed to move $line to $PWD >> "${XPLR_PIPE_MSG_IN:?}"
                      fi
                        done < "${XPLR_PIPE_SELECTION_OUT:?}")
                        echo ExplorePwdAsync >> "${XPLR_PIPE_MSG_IN:?}"
                        read -p "[enter to continue]"
                    ]],
                  },
                  'PopMode',
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
              e = {
                help = 'open editor',
                messages = {
                  {
                    BashExecSilently = [[ exec $TERMINAL -e nvim & ]],
                  },
                },
              },
              q = {
                help = 'print pwd and quit',
                messages = {
                  'PrintPwdAndQuit',
                },
              },
              u = {
                help = 'select/unselect all',
                messages = {
                  'ToggleSelectAll',
                },
              },
              v = {
                help = 'selection mode',
                messages = {
                  { SwitchModeBuiltin = 'selection_ops' },
                },
              },
              w = {
                help = 'switch layout',
                messages = {
                  { SwitchModeBuiltin = 'switch_layout' },
                },
              },
              y = {
                help = 'copy',
                messages = {
                  { SwitchModeCustom = 'wl_copy' },
                },
              },
              z = {
                help = 'zk-bib eat --yes',
                messages = {
                  {
                    BashExecSilently = [[
                      if [ -f "$XPLR_FOCUS_PATH" ]; then
                        zk-bib eat --yes "$XPLR_FOCUS_PATH"
                      else
                        echo "Sory, this is not a file."
                      fi
                    ]],
                  },
                },
              },
              [d.right] = { -- right
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
              ['é'] = {
                help = 'search',
                messages = {
                  'PopMode',
                  { SwitchModeBuiltin = 'search' },
                  { SetInputBuffer = '' },
                },
              },
            },
          },
        },
        go_to = {
          key_bindings = {
            on_key = {
              a = {
                help = 'home',
                messages = {
                  {
                    BashExecSilently = [[
                    echo ChangeDirectory: "'"${HOME:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                    ]],
                  },
                  'PopMode',
                },
              },
              d = { -- shift right
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
                  'PopMode',
                },
              },
              e = {
                help = 'bottom',
                messages = { 'FocusLast', 'PopMode' },
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
                  'PopMode',
                },
              },
              m = {
                help = 'bookmarks',
                messages = {
                  {
                    BashExec = [[
                      PTH="$(cat "${XPLR_BOOKMARK_FILE:?}" | fzf)" 
                      if [ "$PTH" ]; then
                        echo ChangeDirectory: "'"${PTH:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                      fi
                    ]],
                  },
                  'PopMode',
                },
              },
              p = {
                help = 'gvfs',
                messages = {
                  {
                    BashExec = [[
                      res="$(ls -d /run/user/"$(id -u)"/gvfs/* | fzf)"
                      if [ -n "$res" ]; then
                        echo ChangeDirectory: "'"${res:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                      fi
                    ]],
                  },
                  'PopMode',
                },
              },
              q = {
                help = 'history',
                messages = {
                  {
                    BashExec = [[
                      PTH="$(cat "${XPLR_PIPE_HISTORY_OUT:?}" | head -n -1 | tac | fzf --no-sort)"
                      if [ -d "$PTH" ]; then
                        PTH="${PTH%/}" # remove trailing slash
                        echo ChangeDirectory: "'"${PTH:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                      fi
                    ]],
                  },
                  'PopMode',
                },
              },
              r = {
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
                },
              },
              s = {
                help = 'follow symlink',
                messages = { 'FollowSymlink', 'PopMode' },
              },
              u = {
                help = 'top',
                messages = { 'FocusFirst', 'PopMode' },
              },
              x = {
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
                },
              },
            },
          },
        },
        selection_ops = {
          name = 'selection',
          key_bindings = {
            on_key = {
              [d.up] = {
                help = 'up',
                messages = {
                  'FocusPrevious',
                },
              },
              [d.down] = {
                help = 'down',
                messages = {
                  'FocusNext',
                },
              },
              x = {
                help = 'clear selection',
                messages = {
                  'ClearSelection',
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
            },
          },
        },
        switch_layout = {
          key_bindings = {
            on_key = {
              -- h = {
              --   help = 'help',
              --   messages = {
              --     { SwitchLayoutBuiltin = 'no_selection' },
              --     'PopMode',
              --   },
              -- },
              v = {
                help = 'selection',
                messages = {
                  { SwitchLayoutBuiltin = 'no_help' },
                  'PopMode',
                },
              },
              x = {
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

-- let arrow keys do the same as letter equivalent
for _, mode in ipairs { 'default', 'selection_ops' } do
  for k, v in pairs(d) do
    xplr.config.modes.builtin[mode].key_bindings.on_key[k] =
      xplr.config.modes.builtin[mode].key_bindings.on_key[v]
  end
end

-- use tab to select focus everywhere
for _, mode in ipairs { 'default', 'selection_ops' } do
  xplr.config.modes.builtin[mode].key_bindings.on_key.tab = {
    help = 'toggle selection',
    messages = { 'ToggleSelection', 'FocusNext' },
  }
  xplr.config.modes.builtin[mode].key_bindings.on_key['back-tab'] = {
    help = 'toggle selection backward',
    messages = { 'ToggleSelection', 'FocusPrevious' },
  }
end

xplr.config.general.focus_ui.prefix = '▸ '

xplr.config.general.focus_selection_ui.suffix = ']'
xplr.config.general.focus_selection_ui.suffix = ']'
xplr.config.general.focus_ui.suffix = ' ◂'
xplr.config.general.default_ui.prefix = '  '
xplr.config.general.selection_ui.prefix = ' {'
xplr.config.general.selection_ui.suffix = '}'
xplr.config.general.focus_selection_ui.prefix = '▸{'
xplr.config.general.focus_selection_ui.suffix = '}◂'

-- xplr.config.general.initial_layout = 'no_help_no_selection'
xplr.config.general.initial_layout = 'no_selection'

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
xplr.config.general.table.tree = {
  { format = '', style = {} },
  { format = '', style = {} },
  { format = '', style = {} },
}
