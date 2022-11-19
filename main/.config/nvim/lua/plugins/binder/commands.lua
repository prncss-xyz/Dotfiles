M = {}

-- REFACT: get consistent with commands

function M.setup()
  local command = require('legendary').command
  for _, v in ipairs {
    'FoldToggle',
    'FeMaco',
    'registers',
    'LaunchOSV',
    'Reload',
    'TSPlaygroundToggle',
    'PackerCompile',
    'PackerSync',
    'PackerInstall',
    'PackerStatus',
    'PackerUpdate',
    'PackerProfile',
    'StartupTime',
    'Gitsigns stage_buffer',
    'Gitsigns reset_buffer',
    'TSHighlightCapturesUnderCursor',
    'SnipRun',
    'SnipInfo',
    'SnipReset',
    'SnipReplMemoryClean',
    'SnipClose',
    'OverseerOpen',
    'OverseerClose',
    'OverseerToggle',
    'OverseerSaveBundle',
    'OverseerLoadBundle',
    'OverseerDeleteBundle',
    'OverseerRunCmd',
    'OverseerRun',
    'OverseerBuild',
    'OverseerQuickAction',
    'OverseerTaskAction',
  } do
    command { ':' .. v }
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
    'TodoTrouble',
    'TodoTelescope',
  } do
    require('binder.utils').light_command_legendary {
      desc = v,
      string.format(':%s<cr>', v),
    }
  end

  for _, v in ipairs {
    'Dump',
    'PutText',
  } do
    command { ':' .. v .. ' ', unfinished = true }
  end
  command {
    ':Delete',
    function ()
      local filename = vim.api.nvim_buf_get_name(0)
      require 'utils.bbye'.close()
      os.remove(filename)
    end
  }
  command {
    ':EditSnippet',
    require 'utils.edit_snippets',
  }
end

return M
