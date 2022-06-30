M = {}

function M.setup()
  local bind_command = require('legendary').bind_command
  for _, v in ipairs {
    'FoldToggle',
    'registers',
    'LaunchOSV',
    'EditSnippets',
    'Reload',
    'TSPlaygroundToggle',
    'PackerCompile',
    'PackerSync',
    'PackerInstall',
    'PackerStatus',
    'PackerUpdate',
    'PackerProfile',
    'StartupTime',
    'EditSnippets',
    'Gitsigns stage_buffer',
    'Gitsigns reset_buffer',
    'TSHighlightCapturesUnderCursor',
  } do
    bind_command { ':' .. v }
  end
  for _, v in ipairs {
    'help_tags',
    'search_history',
    'jumplist',
    'marks',
    'register',
    'lsp_references',
    'lsp_workspace_symbols',
  } do
    require('binder.utils').light_command_legendary {
      desc = 'telescope ' .. v,
      function()
        require('telescope.builtin')[v]()
      end,
    }
  end
  for _, v in ipairs {
    'gitignore',
  } do
    require('binder.utils').light_command_legendary {
      desc = 'telescope ' .. v,
      function()
        require('telescope').extensions.my[v]()
      end,
    }
  end
  for _, v in ipairs {
    'NodeInfo',
    'WinInfo',
    'messages',
  } do
    require('binder.utils').light_command_legendary {
      desc = v,
      string.format(':%s<cr>', v),
    }
  end
  require('binder.utils').light_command_legendary {
    desc = 'telescope symbols',
    function()
      require('telescope.builtin').symbols {
        'emoji',
        'gitmoji',
        'math',
        'nerd',
      }
    end,
  }

  for _, v in ipairs {
    'Dump',
    'PutText',
  } do
    bind_command { ':' .. v .. ' ', unfinished = true }
  end

  bind_command {
    ':Delete',
    ':call delete(expand("%"))|bdelete!',
  }
end

return M
