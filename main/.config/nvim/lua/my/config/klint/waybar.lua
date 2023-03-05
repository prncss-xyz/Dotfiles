local M = {}

M.path = '.config/waybar/style.css'
M.contents = [[
    * {
      border: none;
      border-radius: 0;
      font-family: {{font.name}};
      font-size: {{font.size.2}}px;
      min-height: 0;
      color: #{{background}};
    }

    window#waybar {
      background: #{{primary}};
      opacity: 0.9;
    }

    #window {
      padding-left: 10px;
      padding-right: 10px;
      padding-top: 1px;
    }

    #workspaces button {
      padding-top: 1px;
      padding-bottom: 0px;
      padding-left: 3px;
      padding-right: 3px;
      background: transparent;
      color: #{{foreground}};
    }

    #mode {
      padding-top: 1px;
      padding-left: 5px;
      padding-right: 5px;
      background-color: #{{accent}};
      color: #{{text}};
    }

    #clock {
      padding-top: 2px;
      padding-left: 5px;
      padding-right: 5px;
    }

    /* not themed the battery yet */

    #temperature,
    #battery,
    #cpu,
    #memory {
      padding-top: 2px;
      padding-left: 5px;
      padding-right: 5px;
      background: #{{primary}};
    }
    #battery.discharging {
      background: #{{accent}};
    }
  ]]

return M
