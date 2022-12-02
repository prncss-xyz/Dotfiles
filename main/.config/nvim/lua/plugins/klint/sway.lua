local M = {}

M.path = '.config/sway/config.d/theme'
M.contents = [[
  default_border pixel 3
  # class                 border background text indicator child_border
  client.focused         	#{{background}}	#{{background}} #{{foreground}} #{{term02}} #{{term04}}
  client.unfocused       	#{{background}}	#{{background}} #{{foreground}} #{{term04}} #{{background}}
  client.focused_inactive	#{{background}}	#{{background}} #{{foreground}} #{{term04}} #{{background}}
  client.urgent       		#{{background}}	#{{background}} #{{foreground}} #{{term04}} #{{background}}
  client.placeholder	    #{{background}}	#{{background}} #{{foreground}} #{{term04}} #{{background}}

  client.background       #${{background}}

  exec_always {
    gsettings set org.gnome.desktop.interface gtk-theme  '{{gtk_theme}}'
    gsettings set org.gnome.desktop.interface font-name '{{font.name}}'
  }

  exec mkfifo $WOBSOCK && tail -f $WOBSOCK | wob --border-color;#aa{{foreground}} --bar-color #aa{{foreground}} --background-color '#55{{background}}
]]

return M
