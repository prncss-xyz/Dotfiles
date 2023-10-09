local M = {}

M.path = '.config/mako/config'
M.contents = [[
    font={{font.name}} {{font.style}} {{font.size.1}}
    background-color=#{{primary}}
    text-color=#{{text}}
    border-color=#{{primary}}
    border-radius=3

    [urgency=low]
    border-color=#{{primary}}

    [urgency=normal]
    border-color=#{{primary}}

    [urgency=high]
    border-color=#{{term01}}
  ]]

return M
