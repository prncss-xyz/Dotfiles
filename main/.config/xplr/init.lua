version = '0.14.4'
package.path = os.getenv 'HOME' .. '/.config/xplr/plugins/?.xplr/src/init.lua'
require('fzf').setup()
require('comex').setup()
require('preview-tabbed').setup {
  mode = 'action',
  key = 'p',
  fifo_path = '/tmp/xplr.fifo',
  previewer = os.getenv 'HOME' .. '/.config/nnn/plugins/preview-tui',
}
require('xargs').setup()
require('zoxide').setup()
require('trash-cli').setup()
require('dua-cli').setup()
require 'icons'
require 'utils'

xplr.config.modes.builtin.default.key_bindings.on_key['q'] = {
  help = 'print pwd and quit',
  messages = { 'PrintPwdAndQuit' },
}
xplr.config.modes.builtin.default.key_bindings.on_key['Q'] = {
  help = 'quit',
  messages = { 'Quit' },
}
xplr.config.modes.builtin.default.key_bindings.on_key['!'] =
  xplr.config.modes.builtin.action.key_bindings.on_key['!']
xplr.config.modes.builtin.action.key_bindings.on_key['!'] = nil

xplr.config.modes.builtin.default.key_bindings.on_key['ctrl-h'] = {
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
}

xplr.config.modes.builtin.default.key_bindings.on_key['#'] = {
  help = 'debug',
  messages = { {
    Debug = '/tmp/xplr.debug.yaml',
  } },
}
xplr.config.modes.builtin.default.key_bindings.on_key['enter'] = {
  help = 'open',
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
}
xplr.config.modes.builtin.default.key_bindings.on_key['m'] = {
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
}
xplr.config.modes.builtin.default.key_bindings.on_key['M'] = {
  help = 'mvf last',
  messages = {
    {
      ['BashExec'] = [[
        mvf "$(cat /tmp/mvf)"
      ]],
    },
  },
}
require('type-to-nav').setup()
require('icons').setup()
-- xplr.config.node_types.symlink.meta.icon = nil
