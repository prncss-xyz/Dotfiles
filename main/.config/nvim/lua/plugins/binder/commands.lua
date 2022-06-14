M = {}

-- TODO: define commands here

function M.setup()
  for _, v in ipairs {
    'Reload',
    'NodeInfo',
    'WinInfo',
    'messages',
    'registers',
    'TSPlaygroundToggle',
    'TSHighlightCapturesUnderCursor',
    'Neogit',
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
  } do
    require('legendary').bind_command { ':' .. v }
  end
  for _, v in ipairs {
    'Dump',
    'PutText',
  } do
    require('legendary').bind_command { ':' .. v .. ' ', unfinished = true }
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
    require('binder.util').light_command_legendary {
      desc = 'telescope ' .. v,
      function()
        require('telescope.builtin')[v]()
      end,
    }
  end
  require('binder.util').light_command_legendary {
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
  require('legendary').bind_command {
    ':LaunchOSV',
    function()
      local filetype = vim.bo.filetype
      if filetype == 'lua' then
        -- require('osv').run_this()
        require('osv').launch {
          type = 'server',
          host = '127.0.0.1',
          port = 30000,
        }
      end
    end,
  }
end

return M
